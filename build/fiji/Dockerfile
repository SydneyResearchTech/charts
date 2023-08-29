FROM openjdk:7-jdk-alpine
ARG DOCKER_IMAGE_TAG=7-jdk-alpine

RUN apk add --no-cache \
 curl

COPY . ./

WORKDIR /fiji

RUN curl -O https://update.imagej.net/bootstrap.js \
 && jrunscript bootstrap.js update-force-pristine

RUN \
 cd /fiji/plugins \
 && curl -O https://github.com/ome/omero-insight/releases/download/v5.8.2/omero_ij-5.8.2-all.jar

ENV PATH=/fiji:$PATH

CMD ["fiji-linux64"]
