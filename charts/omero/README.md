# helm_chart/omero/README.md

## TL;TD

Minimal values.yaml file

```yaml
global:
  postgresql:
    auth:
      postgresPassword: "ADD_PASSWORD_HERE"
postgresql:
  enabled: true
```

Deploy OMERO

```bash
helm repo add restek ...
helm repo update
helm upgrade omero ./ --install --create-namespace --dependency-update --install --values ./values.yaml
```

Show OMERO chart setting values

```bash
helm show values REPO/omero
```

## Introduction

This chart bootstraps an OMERO deployment on a [Kubernetes](https://kubernetes.io) cluster using [Helm package manager](https://helm.sh).

## Prerequisites

* Kubernetes 1.19+
* Helm 3.2.0+
* PV provisioner support in the underlying infrastructure

## External Database configuration

```yaml
```

## Chart development

```bash
# Create values.yaml file

# Clone chart code repository
git clone ...

# Deploy OMERO
helm upgrade omerodev ./omero/ --install --create-namespace --dependency-update --install --values ./values.yaml --namespace omerodev

# verify Kubernetes templates
helm template omerodev ./omero/ --values ./values.yaml
```

Find out about PostgreSQL

```bash
# PostgreSQL configuration values
## Add and update Bitnami Helm chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
## Show PostgreSQL configuration values
helm show values bitnami/postgresql
```

Connect to database with local client

```bash
kubectl -nomerodev port-forward service/omero-postgresql 5432
export PGDATABASE=omero
export PGHOST=localhost
export PGUSER=omero
psql -c '\dt'
```
