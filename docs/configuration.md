# Configuration

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