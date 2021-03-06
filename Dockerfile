# Run with:
# docker run [-e REPO=pa.archive.ubuntu.com] --privileged -it fai

FROM	ubuntu

#
#==============================================================
# Following added by wgb....
#==============================================================

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-utils
RUN apt-get install --no-install-recommends -y gnupg

# ---- Not sure if this is needed, but it balks without it....
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2BF8D9FE074BCDE4
# ----

ENV DEBIAN_FRONTEND=noninteractive

# ---- The following for debugging ONLY......
RUN apt-get install --no-install-recommends -y nano

ENV WGB_DEBUG=true
ENV WGB_VERBOSE=true
# ----

#
#==============================================================
#

# Redirection sites like http.debian.net or httpredir.debian.org don't seem to work well with apt-cacher-ng
ENV	MAIN_REPO	us.archive.ubuntu.com

# Add FAI repository and install GPG key
ADD	keys/074BCDE4.asc /tmp/

RUN	echo "deb http://fai-project.org/download jessie koeln" >> /etc/apt/sources.list && \
	apt-key add /tmp/074BCDE4.asc && \
	rm -f /tmp/074BCDE4.asc

# Install packages
RUN	sed -ri -e 's/^deb-src/#&/' -e '/[a-z]+-security/s/archive.ubuntu.com/security.ubuntu.com/' /etc/apt/sources.list && \
	sed -i "s/archive\.ubuntu\.com/${MAIN_REPO}/" /etc/apt/sources.list && \
	apt-get update && \
	apt-get upgrade -y && \
	apt-get install --no-install-recommends -y apt-cacher-ng \
		apt-transport-https \
		aptitude \
		binutils \
		bzip2 \
		ca-certificates \
		fai-client=4.3.3 \
		fai-server=4.3.3 isc-dhcp-server- nfs-kernel-server- openbsd-inetd- openssh-server- tcpd- tftpd-hpa- update-inetd- \
		debian-archive-keyring \
		gawk \
		grub-pc-bin \
		less \
		liblz4-tool \
		memtest86+ \
		openssh-client \
		patch \
		reprepro \
		tzdata \
		vim \
		wget \
		xorriso \
		xz-utils && \
	apt-get clean

ADD	fai /etc/fai/
ADD	hooks /etc/fai/nfsroot-hooks/
ADD	bin /usr/local/bin/
ADD	patches /tmp/
# Add FAI key downloaded from http://fai-project.org/download/074BCDE4.asc
ADD	keys /etc/fai/apt/keys/

# removed from between the two back slashes below
# --------
# 	sed -i 's%http://%&127.0.0.1:9999/%' /etc/fai/apt/sources.list && \
# --------

# Configuration
RUN \
	sed -ri 's/^(# )?Port:3142/Port:9999/' /etc/apt-cacher-ng/acng.conf && \
	sed -ri 's/^Remap-(gentoo|sfnet):/#&/' /etc/apt-cacher-ng/acng.conf && \
	echo "http://us.archive.ubuntu.com/ubuntu" > /etc/apt-cacher-ng/backends_ubuntu && \
	. /etc/lsb-release && \
	sed -ri "s%^(FAI_DEBOOTSTRAP)=.*%\1=\"$DISTRIB_CODENAME http://$MAIN_REPO/ubuntu\"%" /etc/fai/nfsroot.conf && \
	cp /etc/apt/sources.list /etc/fai/apt/ && \
	\
	\
	mkdir -p /etc/fai/faimirror/apt && \
	cp /etc/fai/fai.conf /etc/fai/faimirror && \
	cp /etc/fai/nfsroot.conf /etc/fai/faimirror && \
	chmod +x /etc/fai/nfsroot-hooks/* && \
	chmod +x /usr/local/bin/*

# Apply some patches
RUN	patch /usr/sbin/fai-cd < /tmp/fai-cd.patch && \
	patch /usr/bin/fai-mirror < /tmp/fai-mirror.patch && \
	patch /usr/sbin/fai-make-nfsroot < /tmp/fai-make-nfsroot.patch && \
	rm -f /tmp/fai-cd.patch /tmp/fai-make-nfsroot.patch /tmp/fai-mirror.patch \
		/usr/sbin/fai-make-nfsroot.orig /usr/bin/fai-mirror.orig /usr/sbin/fai-cd.orig


# ------------------------------------------------
# Added by wgb to fix the missing gnupg module
# ------------------------------------------------
ADD patches/fai-make-nfsroot.full    /usr/sbin/fai-make-nfsroot
# ------------------------------------------------


# Add these volumes to speed up fai-setup & fai-mirror
VOLUME	/var/cache/apt-cacher-ng

# ----------------------------------------------------
# NOTE by wgb
# ------------
# The following needs to be debugged - gnupg is broken
# also... 
#

#RUN echo "not this... ##RUN fai-setup -vl"

# Note: use -vl to make a "live" boot and "verbose" messaging
#
RUN \
	echo "echo" \
		> /what-is-next.sh && \
		\
		\
	echo "echo Running fai-setup.sh ... this will take awhile...." \
		>> /what-is-next.sh && \
		\
		\
	echo "echo " \
		>> /what-is-next.sh && \
		\
		\
	echo "sleep 2" \
		>> /what-is-next.sh && \
		\
		\
	echo "fai-setup -vl" \
		>> /what-is-next.sh && \
		\
		\
	echo "echo " \
		>> /what-is-next.sh && \
		\
		\
	echo "cp /what-is-after.sh /what-is-next.sh" \
		>> /what-is-next.sh && \
		\
		\
	echo "rm -rf /what-is-after.sh" \
		>> /what-is-next.sh && \
		\
		\
	chmod u+x /what-is-next.sh && \
		\
		\
		\
	echo "echo " \
		> /what-is-after.sh && \
	echo "echo \"Here are my instructions...\" " \
		> /what-is-after.sh && \
	echo "echo " \
		> /what-is-after.sh && \
		\
		\
	chmod u+x /what-is-after.sh

# ----------------------------------------------------


# ----------------------------------------------------
# NOTE by wgb
# ------------
# The following only gets ran / (aka fixed up with sed) 
# if there is a $REPO environment override
# ----------------------------------------------------

CMD	test -n "$REPO" && sed -i -re "s/${MAIN_REPO}/${REPO}/" /etc/apt/sources.list /etc/fai/apt/sources.list /etc/fai/nfsroot.conf ; \
	/bin/bash ./what-is-next.sh.sh

#	/bin/bash ./whatsnext.sh

#CMD	test -n "$REPO" && sed -i -re "s/${MAIN_REPO}/${REPO}/" /etc/apt/sources.list /etc/fai/apt/sources.list /etc/fai/nfsroot.conf ; \
#	/etc/init.d/apt-cacher-ng start && \
#	/bin/bash



