# Kustomize setup

The following explains in depth the reasoning behind the structure of the `kustomize` directory.

## kustomize/base

The base directory contains all non-environment specific configuration. This could be:
 
-  Any manifests which are deployed to every environment (e.g. PSPs, Storage Classes, RBAC etc)
- `HelmRelease` manifests without the environment specific ingress host names.

### kustomize/base/cluster

This directory should contain all the default cluster resources, examples include:

- Default namespaces
- Priority classes
- Default Pod Security Policies
- Default RBAC permissions
- Storage classes

In this demo repository its only a subset of these things.

### kustomize/base/flux

This directory is a directory to contain additional flux instances you want to have deployed.

Any example of this is a flux instance used to reconcile [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets).

### kustomize/base/helm-operators

This directory is a directory to contain all Helm Operators you may want to deploy to a given cluster.

However, there is an important thing to note within their configuration.

The `HelmRelease` manifests themselves are deployed to the `flux` namespace to be reconciled by the default Helm Operator running within that namespace.

However, each of the Helm Operator pods are actually deployed to specific namespaces and are scoped to only reconcile `HelmRelease` resources in their namespace.

This is made possible by the following:

```
spec.targetNamespace: cert-manager
spec.values.allowNamespace: cert-manager
```

For more information on `targetNamespace` I would recommend reading [this](https://docs.fluxcd.io/projects/helm-operator/en/1.0.0-rc9/references/helmrelease-custom-resource.html#helmrelease-custom-resource).

This setup allows for faster reconciliation of `HelmRelease` manifests.`
