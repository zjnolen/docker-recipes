FROM ubuntu:focal
ARG version="0.961"
ARG commit="845b0ec8b1acd553d886f6e187858c02ba40f964"
ARG commit_short="845b0ec"

LABEL container.name "evalAdmix"
LABEL container.desc "Evaluate the results of an admixture analysis"
LABEL container.maintainer.name "Zachary J. Nolen"
LABEL container.maintainer.contact "zachary.nolen@biol.lu.se"
LABEL software.version.evaladmix version
LABEL software.commit.evaladmix commit
LABEL software.source.evaladmix "https://github.com/GenisGE/evalAdmix"
LABEL citation.doi.evaladmix "https://doi.org/10.1111/1755-0998.13171"

# The software contained in this image come from the above sources and if used should be cited accordingly.

#  Garcia-Erill, G, Albrechtsen, A. Evaluation of model fit of inferred admixture proportions. 
#  Mol Ecol Resour. 2020; 20: 936– 949. https://doi.org/10.1111/1755-0998.13171 

# Use bash as shell
SHELL ["/bin/bash", "-c"]

# Set workdir
WORKDIR /opt

# Install necessary tools and dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends wget \
											   gzip \
											   tar \
											   unzip \
											   locales \
											   ca-certificates \
											   build-essential \
											   make \
											   zlib1g-dev \
	&& apt-get clean

# set locales
RUN locale-gen en_US.utf8
ENV LC_ALL en_US.UTF-8
ENV LC_LANG en_US.UTF-8

RUN cd /opt && \
	wget https://github.com/GenisGE/evalAdmix/archive/${commit}.zip && \
	unzip ${commit}.zip && \
	cd evalAdmix-${commit} && \
	make && \
	cp evalAdmix /usr/local/bin/ && \
	cd .. && \
	rm -r evalAdmix-${commit}