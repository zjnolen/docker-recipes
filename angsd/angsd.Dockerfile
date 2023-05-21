FROM debian:bullseye
ARG vANGSD="0.940"
ARG vHTSlib="1.16"

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
											   bc \
	&& apt-get clean

# set locales
RUN locale-gen en_US.utf8
ENV LC_ALL en_US.UTF-8
ENV LC_LANG en_US.UTF-8

# Install angsd and create bin folder
RUN wget https://github.com/ANGSD/angsd/releases/download/${vANGSD}/angsd${vANGSD}.tar.gz && \
	tar xf angsd${vANGSD}.tar.gz && \
	rm angsd${vANGSD}.tar.gz && \
	cd htslib && \
	make && \
	cd ../angsd && \
	git config --global --add safe.directory /angsd && \
	make HTSSRC=../htslib && \
	cp angsd /usr/local/bin/ && \
	cd misc && \
	cp $(find . -executable -type f) /usr/local/bin/ && \
	cd ../../ && \
	rm -r angsd