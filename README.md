# charts

```bash
helm repo add restek https://sydneyresearchtech.github.io/charts/

helm repo update

helm search repo restek/

# E.g.,
helm show values restek/omero
```

# Contribute

Adherence to [Semantic Versioning](https://semver.org).

# Tagging strategy

Because this repository holds multiple tightly coupled resources, aligning product release version to repository
tags is not practical. This requires the release tagging to be incorporated at other locations of each product.

## Tagging Docker containers

Within each built template (Dockerfile) there is an argument `ARG DOCKER_IMAGE_TAG=0.1.0`. This argument is
responsible for providing the SemVer string for the Docker build process to supply the final image tag.

Documenting application version is provided by an argument `ARG <Application_Name>_VERSION=<Version_String>`.
This should then be translated as standard Docker image practice into an environment variable of the same
structure.

## Tagging Helm templates

The Helm template has a pre-existing metadata file responsible for providing both release tag as well as
documenting application version. This is adhered to and used when producing Helm template releases.

# Why a single repository?

The reasoning behind a single repository including both helm charts `/charts` and container build `/build` recipes
is based on the observation that there lies a close coupling between these two products. With the addition of
other outcomes such as documentation, by including into a single repository it consolidates historical changes
into a single versioning process. This encapsulated distinct states in time allowing for careful but rapid
progression of work with a clear recovery process.

There are a few disadvantages to this approach however. Delegation of work between subject matter experts
(or teams) becomes more difficult, the specific versioning of outcomes can not be aligned to release tags
as there are multiple products within the repository at varying release stages (see release tagging strategies).

If these design considerations prove to become too expensive, specific pieces of work can be migrated to
a separate repository and git sub-modules can be configured to keep the alignment within this particular
repository.
