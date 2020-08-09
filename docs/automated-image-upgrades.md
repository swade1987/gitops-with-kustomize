# Automated Image Upgrades

## Base

In the base directory we set the `podinfo` HelmRelease to have automatic image upgrades turned off.

This can be seen from the following annotations:

```
fluxcd.io/automated: "false"
```
 
## Environment specific

For us to enable automatic image upgrades we need to uncomment the following annotations from the `dev` specific configuration.

```
fluxcd.io/automated: "true"
filter.fluxcd.io/chart-image: semver:~4.0
```

Now when flux next reconciles it and looks for new images in the image registry it will find the latest one and upgrade the deployment.

An example of this can be seen below in the flux logs.

```
ts=2020-08-09T14:50:02.657447155Z caller=images.go:17 component=sync-loop msg="polling for new images for automated workloads"
ts=2020-08-09T14:50:02.780931146Z caller=images.go:111 component=sync-loop workload=podinfo:helmrelease/podinfo container=chart-image repo=stefanprodan/podinfo pattern=semver:~4.0 current=stefanprodan/podinfo:4.0.3 info="added update to automation run" new=stefanprodan/podinfo:4.0.6 reason="latest 4.0.6 (2020-06-26 10:47:57.011325031 +0000 UTC) > current 4.0.3 (2020-06-06 11:37:05.183233795 +0000 UTC)"
```

## Writing back to Git

After the upgrade has been successful you will see a new commit in GitHub showing the change.