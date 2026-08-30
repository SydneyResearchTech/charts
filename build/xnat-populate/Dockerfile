ARG DOCKER_IMAGE_TAG=0.1.0

FROM groovy:3.0.14 AS builder
USER root

RUN <<EOT
apt-get update
apt-get -y install \
 git
EOT

RUN git clone https://bitbucket.org/xnatdev/xnat_populate.git



FROM groovy:3.0.14

COPY --from=builder /home/groovy/xnat_populate/ ./

RUN groovy PopulateXnat.groovy || true

ENV \
XNAT_USER=admin \
XNAT_PASSWORD=admin \
XNAT_URL=xnat-xnat-web.default.svc \
XNAT_DATA=minimalData.txt

USER root
COPY ./ /

USER groovy
ENTRYPOINT ["entrypoint.sh"]
CMD ["groovy", "PopulateXnat.groovy", "--insecure"]
