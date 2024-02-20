# build/cryosparc/README.md

CryoSPARC requires registration providing a license key.
This key is required to attain the source code and needs to be kept secret per deployment.
The CryoSPARC images are also large compared to industry standard and are best handled being deployed via local repositories or similar local image deployments.

To deploy CryoSPARC a recipe has been formulated to generate an image and push to a local repository for the Kubernetes deployment to pull from.

## Setup

Passing local parameters for the build and deployment of CryoSPARC images is doe either via passing parameters to the `make` command directly or a local environment file.
The site specific environment file can be added to the same directory that houses the Makefile and will be used to apply parameter settings such as `LICENCE_ID` that was provided via the CryoSPARC registration request.

```.env
LICENSE_ID=######-####-####-####-###########
```

## Pre-requisits

The following software is required on the build system.

* Docker
  * Make uses the `docker buildx build ...` instruction to create the images and cache the build operation for future updates.
  * Ref. [Docker Build architecture](https://docs.docker.com/build/architecture/)

## Build and push CryoSPARC images

In the directory containing the Makefile run the following.

```bash
make
```
