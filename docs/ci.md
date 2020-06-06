# Continuous Integration

All tasks use the docker container from [https://github.com/swade1987/kubernetes-toolkit](https://github.com/swade1987/kubernetes-toolkit).

If you would like changes made to the above image please feel free to open an issue or pull request.

## 1. Local usage

There are a number of useful `Make` tasks available for you to validate your manifests and overall Kustomize setup.

These can be found within the `Makefile` in the root of this repository.

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

## 2. Circle CI

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