FROM debian:stable-slim as build
ARG DOCKER_IMAGE_TAG=0.1.0

RUN apt-get update && apt-get -y install \
 curl \
 unzip

ARG TARGETARCH

RUN [ "${TARGETARCH}" = "amd64" ] && IMAGEIO="linux-x86_64.zip" || IMAGEIO="ImageIOJars.zip"

RUN curl -LOsS http://mirc.rsna.org/download/CTP-installer.jar \
 && curl -LOsS http://mirc.rsna.org/ImageIO/${IMAGEIO}

RUN mkdir -p /JavaPrograms/ext /JavaPrograms/lib \
 && unzip "${IMAGEIO}" -d /JavaPrograms/ext \
 && mv /JavaPrograms/ext/*.so /JavaPrograms/lib \
 && unzip CTP-installer.jar -d /JavaPrograms


FROM debian:stable-slim

RUN apt-get update && apt-get -y install \
 openjdk-17-jre-headless \
 && rm -rf /var/lib/apt/lists/*

COPY --from=build /JavaPrograms/ /JavaPrograms/

COPY ./ /

RUN ln -sfr /JavaPrograms/config/config.xml /JavaPrograms/CTP/config.xml

# java -XshowSettings:properties -version
ENV CLASSPATH="/JavaPrograms/CTP:/JavaPrograms/ext" \
 LD_LIBRARY_PATH="/JavaPrograms/lib" \
 TZ=Australia/Sydney

WORKDIR /JavaPrograms/CTP
EXPOSE 8080/tcp
CMD ["java","-jar","Runner.jar"]
