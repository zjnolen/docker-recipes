FROM continuumio/miniconda3:4.12.0
ARG version="1.10"
ARG commit="0f06e368e491254e470e1d8d3e17ab628151d343"
ARG commit_short="0f06e36"

LABEL container.name "PCAngsd"
LABEL container.desc "Framework for analyzing low-depth next-generation sequencing (NGS) data in heterogeneous/structured populations using principal component analysis (PCA)"
LABEL container.maintainer.name "Zachary J. Nolen"
LABEL container.maintainer.contact "zachary.nolen@biol.lu.se"
LABEL software.version.pcangsd version
LABEL software.commit.pcangsd commit
LABEL software.source.pcangsd "https://github.com/Rosemeis/pcangsd"
LABEL citation.doi.pca "https://doi.org/10.1534/genetics.118.301336"
LABEL citation.doi.structure "https://doi.org/10.1534/genetics.118.301336"
LABEL citation.doi.hwe "https://doi.org/10.1111/1755-0998.13019"

# The software contained in this image come from the above sources and if used should be cited accordingly:
#
# PCA - Jonas Meisner, Anders Albrechtsen, Inferring Population Structure and Admixture Proportions in 
# 				Low-Depth NGS Data, Genetics, Volume 210, Issue 2, 1 October 2018, Pages 719–731, 
#				https://doi.org/10.1534/genetics.118.301336
#
# Structure analyses - Jonas Meisner, Anders Albrechtsen, Inferring Population Structure and Admixture 
#					   Proportions in Low-Depth NGS Data, Genetics, Volume 210, Issue 2, 1 October 2018, 
#					   Pages 719–731, https://doi.org/10.1534/genetics.118.301336
#
# HWE - Meisner, Jonas, and Anders Albrechtsen. "Testing for Hardy–Weinberg equilibrium in structured 
#	    populations using genotype or low‐depth next generation sequencing data." Molecular ecology 
#	    resources 19, no. 5 (2019): 1144-1152.

# Use bash as shell
SHELL ["/bin/bash", "-c"]

# Set workdir
WORKDIR /opt

# install pcangsd
RUN cd /opt && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict && \
	conda update -n base conda && \
	conda install unzip gxx numpy cython scipy && \
	wget https://github.com/Rosemeis/pcangsd/archive/${commit}.zip && \
	unzip ${commit}.zip && \
	cd pcangsd-${commit} && \
	python setup.py build_ext --inplace && \
	pip install . && \
	cd /opt && \
	rm -r pcangsd* && \
	conda clean -afy