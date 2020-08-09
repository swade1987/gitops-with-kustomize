# GitOps (using Kustomize)

An example repo structure for GitOps with:

- [Flux](https://github.com/fluxcd/flux)
- [Helm Operator](https://github.com/fluxcd/helm-operator)
- [Kustomize](https://github.com/kubernetes-sigs/kustomize)

## Directory structure

```
kustomize
├── base                        # base kustomizations             
│   ├── cluster              # logical grouping of resources
├── dev                         # Directory per env which pulls from base and extends/overrides helmreleases
```

Resources are organised per environment in the `kustomize` directory.

## Pre-requisites

A list of pre-requisites can be found [here](docs/pre-reqs.md).

## Setup

1. To configure this to work with your repository first read the steps [here](docs/configuration.md).

2. Create a cluster using `make cluster`

3. Install [Flux](https://github.com/fluxcd/flux) and the [Helm Operator](https://github.com/fluxcd/helm-operator) using `make install-flux`

4. After following the prompts, flux will establish a connection to your repository and start reconciling.

## Continuous Integration

A deep-dive into running checks locally and the CircleCI configuration, read [here](docs/ci.md).

## Kustomize directory structure

A deep-dive into the kustomize setup can be found [here](docs/kustomize-setup.md).

## Automatic image upgrades 

An example of automated image upgrades with `HelmReleases` resources can be found [here](docs/automated-image-upgrades.md).