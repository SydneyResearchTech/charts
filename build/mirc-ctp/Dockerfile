FROM debian:stable-slim as build
ARG DOCKER_IMAGE_TAG=0.1.0

RUN apt-get update && apt-get -y install \
 curl \
 openjdk-17-jdk-headless \
 unzip

RUN curl -OLsS http://mirc.rsna.org/download/CTP-installer.jar \
 && curl -OLsS http://mirc.rsna.org/ImageIO/ImageIOJars.zip

RUN mkdir -p /JavaPrograms/lib/ext \
 && unzip ImageIOJars.zip -d /JavaPrograms/lib/ext \
 && jar xf CTP-installer.jar /JavaPrograms/CTP



FROM debian:stable-slim

RUN apt-get update && apt-get -y install \
 openjdk-17-jre-headless \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /JavaPrograms/ /JavaPrograms/

COPY ./ /

ENV CLASSPATH="/JavaPrograms/CTP:/JavaPrograms/lib/ext"

ENV TZ=Australia/Sydney

WORKDIR /JavaPrograms/CTP

CMD ["java","-jar","/JavaPrograms/CTP/Runner.jar"]
