# GitOps (using Kustomize)

An example repo structure for GitOps with [Kustomize](https://github.com/kubernetes-sigs/kustomize) and [Flux](https://github.com/fluxcd/flux).

## Pre-requisites

### k3d

The demo uses [rancher/k3d](https://github.com/rancher/k3d) to spin up a cluster locally.

The installation guide for `k3d` can be found [here](https://github.com/rancher/k3d#get).

### Kustomize

To validate that your Kustomization's are valid it is recommended to have `Kustomize` installed.

The installation guide for this can be found [here](https://github.com/kubernetes-sigs/kustomize).

### Helm 3

Flux is installed using [Helm 3](https://helm.sh/blog/helm-3-released/).

The installation guide for this can be found [here](https://helm.sh/docs/intro/install/). 

## Directory structure

```
kustomize
├── base                        # base kustomizations             
│   ├── cert-manager            # logical grouping of resources
│   │ └── helmreleases          # base Helmreleases (may be layered with kustomisations)
│   │ └── kustomization.yaml    # Kustomization file which pulls in releases and patches, etc
├── dev                         # Directory per env which pulls from base and extends/overrides helmreleases
```

Resources are organised per environment in the `kustomize` directory.

## Configuration

The configuration of Flux is handled in `scripts/flux-init.sh`.

There are two variables of interest, these are:

```
REPO_URL=${1:-git@github.com:swade1987/gitops-with-kustomize}
REPO_BRANCH=master
```

The above needs to be updated to point to your repository, and the branch you want Flux to reconcile against.

Finally, an important flag to note within the Flux installation is the following:

```
--set manifestGeneration=true \
```

The above is required to be used as we are using `Kustomize`.

## Setup

1. Create a cluster using `make cluster`

2. Install [Flux](https://github.com/fluxcd/flux) and the [Helm Operator](https://github.com/fluxcd/helm-operator) using `make install-flux`

3. After following the prompts, flux will establish a connection to your repository and start reconciling.

## Continuous Integration

### Local usage

There are a number of useful `Make` tasks available for you to validate your manifests and overall Kustomize setup.

These can be found within the `Makefile` in the root of this repository.

All tasks use the docker container from [https://github.com/swade1987/kubernetes-toolkit](https://github.com/swade1987/kubernetes-toolkit).

### check-duplicate-release-name

As the name of each `HelmRelease` resources needs to be unique in a cluster this makes sure this is the case.

### kubeval-environments

This runs [kubeval](https://github.com/instrumenta/kubeval) against each `HelmRelease` constructed during the output of `kustomize build` for each environment.

This makes sure that resources being deployed match strictly to the schemas for the version of Kubernetes specified by the toolkit container image.

At present a container image is only available for Kubernetes v1.17.2, if you would like a newer image please open a PR.

### deprek8-check

This uses [conftest](https://github.com/open-policy-agent/conftest) to make sure the resources being applied to the cluster are not using deprecated API versions.

This uses the policies located [here](https://github.com/swade1987/kubernetes-toolkit/tree/master/policies/deprecations).

### kustomization-yaml-fix

This simply makes sure each of your `kustomization.yaml` files are accurate against the `Kustomize` specification.

### Circle CI

The scripts available for execution locally can also be executed as part of CI.

The configuration for these can be seen within `.circle/config.yml`.

### kubeval-helmreleases-for-environment

This script (`bin/kubeval-helmreleases-for-environment`) is expected to only run within CI and not locally due to the way its execute.

It runs [hrval](https://github.com/stefanprodan/hrval-action) against each `HelmRelease` constructed during the output of `kustomize build` for a given environment.
 
The steps `hrval` executes for each `HelmRelease` are as follows:

- extracts the chart source with yq
- downloads the chart from the Helm or Git repository
- extracts the Helm Release values with yq
- runs `helm template` for the extracted values
- validates the YAMLs using [kubeval](https://github.com/instrumenta/kubeval) in strict mode