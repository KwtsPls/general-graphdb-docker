################################
# Dockerfile for DA4DTE's KG   #
# DI @ UoA                     #
#                              #
# Java 11                      #
# graphdb 10.6.3               #
################################

FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

ENV PORT 7200
ENV GRAPH_DB_VERSION 10.6.3

# INSTALL PREREQUISITIES
RUN apt-get update \
 && apt-get install -y \
    wget \
    openjdk-11-jdk \
    curl \
    unzip \
    gzip \
    gnupg2 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Download and extract graphdb
RUN wget "https://maven.ontotext.com/repository/owlim-releases/com/ontotext/graphdb/graphdb/${GRAPH_DB_VERSION}/graphdb-${GRAPH_DB_VERSION}-dist.zip" \
	&& unzip graphdb-${GRAPH_DB_VERSION}-dist.zip

# Download the knowledge graph data
RUN wget "https://strabon.di.uoa.gr/da4dte_data/da4dte.nt.gz" \
    && gzip -d da4dte.nt.gz

RUN wget "https://strabon.di.uoa.gr/da4dte_data/images.nt.gz" \
    && gzip -d images.nt.gz

RUN wget "https://strabon.di.uoa.gr/da4dte_data/non_satellite_mat_reduced_map.nt.gz" \
    && gzip -d non_satellite_mat_reduced_map.nt.gz

RUN wget "https://strabon.di.uoa.gr/da4dte_data/s1_mat_intersects_only_map.nt.gz" \
    && gzip -d s1_mat_intersects_only_map.nt.gz

RUN wget "https://strabon.di.uoa.gr/da4dte_data/s2_mat_intersects_only_map.nt.gz" \
   && gzip -d s2_mat_intersects_only_map.nt.gz

RUN wget "https://strabon.di.uoa.gr/da4dte_data/da4dte_en_labels_unique.nt.gz" \
    && gzip -d da4dte_en_labels_unique.nt.gz

COPY template.ttl . 

EXPOSE 7200
EXPOSE 7300

RUN ./graphdb-10.6.3/bin/importrdf preload -c template.ttl da4dte.nt da4dte_en_labels_unique.nt images.nt non_satellite_mat_reduced_map.nt s1_mat_intersects_only_map.nt s2_mat_intersects_only_map.nt
ENTRYPOINT ["./graphdb-10.6.3/bin/graphdb"]
