FROM openjdk:7-jdk-alpine
ARG DOCKER_IMAGE_TAG=7-jdk-alpine

RUN apk add --no-cache \
 curl

COPY . ./

WORKDIR /fiji

RUN curl -O https://update.imagej.net/bootstrap.js \
 && jrunscript bootstrap.js update-force-pristine

ENV PATH=/fiji:$PATH

CMD ["fiji-linux64"]
