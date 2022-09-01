FROM ubuntu:focal
ARG vANGSD="0.937"
ARG vHTSlib="1.15.1"

LABEL container.name "ANGSD"
LABEL container.desc "ANGSD, a software for analyzing next generation sequencing data"
LABEL container.maintainer.name "Zachary J. Nolen"
LABEL container.maintainer.contact "zachary.nolen@biol.lu.se"
LABEL software.version.angsd vANGSD
LABEL software.version.htslib vHTSlib
LABEL software.source.angsd "https://github.com/angsd/angsd"
LABEL software.source.htslib "https://github.com/samtools/htslib/"
LABEL citation.doi.angsd "https://doi.org/10.1186/s12859-014-0356-4"
LABEL citation.doi.htslib "https://doi.org/10.1093/gigascience/giab007"

# The software contained in this image come from the above sources and if used should be cited accordingly.

# ANGSD - Korneliussen, T.S., Albrechtsen, A. & Nielsen, R. ANGSD: Analysis of Next Generation Sequencing Data. 
#		  BMC Bioinformatics 15, 356 (2014). https://doi.org/10.1186/s12859-014-0356-4

# HTSlib - HTSlib: C library for reading/writing high-throughput sequencing data.
#		   James K Bonfield, John Marshall, Petr Danecek, Heng Li, Valeriu Ohan, Andrew Whitwham, Thomas Keane, Robert M Davies
#		   GigaScience, Volume 10, Issue 2, February 2021, giab007, https://doi.org/10.1093/gigascience/giab007

# Use bash as shell
SHELL ["/bin/bash", "-c"]

# Set workdir
WORKDIR /opt

# Install necessary tools and dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends wget \
											   gzip \
											   tar \
											   bzip2 \
											   autoconf \
											   locales \
											   ca-certificates \
											   build-essential \
											   zlib1g-dev \
											   libbz2-dev \
											   liblzma-dev \
											   git \
											   libcurl4-gnutls-dev \
											   libssl-dev \
	&& apt-get clean

# set locales
RUN locale-gen en_US.utf8
ENV LC_ALL en_US.UTF-8
ENV LC_LANG en_US.UTF-8

# Install htslib
RUN cd /opt && \
	wget https://github.com/samtools/htslib/releases/download/${vHTSlib}/htslib-${vHTSlib}.tar.bz2 && \
	tar -xvf htslib-${vHTSlib}.tar.bz2 && \
	rm htslib-${vHTSlib}.tar.bz2 && \
	cd htslib-${vHTSlib} && \
	autoconf && \
	autoheader && \
	./configure && \
	make && \
	make install && \
	cd /opt && \
	rm -r htslib-${vHTSlib}

# Install angsd and create bin folder
RUN cd /opt && \
	wget https://github.com/ANGSD/angsd/archive/refs/tags/${vANGSD}.tar.gz && \
	tar -xvf ${vANGSD}.tar.gz && \
	rm ${vANGSD}.tar.gz && \
	cd angsd-${vANGSD} && \
	make HTSSRC=/usr/local/lib && \
	cp angsd /usr/local/bin/ && \
	cd misc && \
	cp $(find . -executable -type f) /usr/local/bin/ && \
	cd /opt && \
	rm -r angsd-${vANGSD}