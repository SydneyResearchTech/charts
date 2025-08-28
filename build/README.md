# charts/build/README.md

## Dockerfile arguments used in the image build process

| Argument         | Image name                                        |
| ---------------- | ------------------------------------------------- |
| APP_VERSION      | DIRECTORY_NAME-${APP_VERSION}:${DOCKER_IMAGE_TAG} |
| DOCKER_IMAGE_TAG | DIRECTORY_NAME:${DOCKER_IMAGE_TAG}                |
| VERSION          | DIRECTORY_NAME:${DOCKER_IMAGE_TAG}                |

* APP_VERSION
  * APP_VERSION and VERSION are mutually exclusive.
  * Minor changes to base container.
  * No major alterations to functionality or purpose.
  * The directory name should be identical to the base container or application name.
* VERSION
  * APP_VERSION and VERSION are mutually exclusive.
  * Functionality is not linked to base containers direct purpose.
  * E.g., Using the Debian base image to create a sidecar or job container.

```Dockerfile
ARG APP_VERSION
FROM APPLICATION_NAME:${APP_VERSION}
ARG DOCKER_IMAGE_TAG=0.1.0
```

```Dockerfile
ARG VERSION
FROM BASE_IMAGE_NAME:${VERSION}
ARG DOCKER_IMAGE_TAG=0.1.0
```
