ARG DOCKER_IMAGE_TAG=0.1.0

FROM alpine:3.24

RUN apk add --no-cache \
 nfs-utils \
 unfs3

COPY ./ /
RUN mkdir -p /vol

ENTRYPOINT ["entrypoint.sh"]
CMD ["unfsd", "-d", "-t"]
