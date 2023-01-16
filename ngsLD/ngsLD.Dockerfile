FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive
ARG commit="ecee582ecf92afea91b4c30cde27df47b6b57625"
ARG commit_date="20220902"
ARG commit_short="ecee582"

LABEL container.name "ngsLD"
LABEL container.desc "ngsLD, estimate pairwise linkage disequilibrium (LD) taking the uncertainty of genotype's assignation into account."
LABEL container.maintainer.name "Zachary J. Nolen"
LABEL container.maintainer.contact "zachary.nolen@biol.lu.se"
LABEL software.commit.ngsLD commit
LABEL software.commit-date.ngsLD commit_date
LABEL software.source.ngsLD "https://github.com/fgvieira/ngsLD"
LABEL citation.doi.ngsLD "https://doi.org/10.1093/bioinformatics/btz200"

# The software contained in this image come from the above sources and if used should be cited accordingly.

# Fox EA, Wright AE, Fumagalli M, and Vieira FG
# ngsLD: evaluating linkage disequilibrium using genotype likelihoods
# Bioinformatics (2019) 35(19):3855 - 3856

# Install required tools and dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		git \
		build-essential \
		pkg-config \
		libgsl-dev \
		zlib1g-dev \
		gzip \
		gnupg2 \
		r-base \
		r-cran-optparse \
		r-cran-ggplot2 \
		r-cran-reshape2 \
		r-cran-plyr \
		r-cran-gtools \
		r-cran-biocmanager \
		python3 \
		python3-pandas \
		perl \
		perl-doc \
		libgetopt-simple-perl \
		libgraph-easy-perl \
		libmath-bigint-perl \
		libio-zlib-perl \
		liblist-allutils-perl \
		libscalar-util-numeric-perl \
	&& \
	echo "deb [ arch=amd64 ] https://downloads.skewed.de/apt focal main" >> /etc/apt/sources.list && \
	apt-key adv --keyserver keyserver.ubuntu.com --recv-key 612DEFB798507F25 && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		python3-graph-tool \
	&& \
	Rscript -e "BiocManager::install('LDheatmap')" && \
	# Install ngsLD:
	git clone https://github.com/fgvieira/ngsLD.git && \
	cd ngsLD && \
	git checkout ${commit} && \
	make && \
	echo $PATH && \
	cp ngsLD /usr/local/bin/ && \
	sed -i 's/#!\/bin\/env Rscript/#!\/usr\/bin\/env Rscript/g' scripts/fit_LDdecay.R && \
	cp scripts/* /usr/local/bin/ && \
	# Clean up:
	cd ../ && \
	rm -rf ngsLD && \
	apt-get clean && \
	apt-get autoremove -y
