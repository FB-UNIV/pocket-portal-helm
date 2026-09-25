# pocket-portal Helm chart

Kubernetes deployment for [pocket-portal](https://github.com/FB-UNIV/pocket-portal),
a self-hosted portal for PocketID users: reach your apps, request access to
the rest.

```bash
helm install portal oci://ghcr.io/fb-univ/charts/pocket-portal --version <chart version> -f my-values.yaml
```

The chart, its values and what it creates are documented in
[`charts/pocket-portal/README.md`](charts/pocket-portal/README.md). The
portal's deployment contract (configuration, health checks, migrations,
backups, upgrades) is in the portal's
[runbook](https://github.com/FB-UNIV/pocket-portal/blob/main/docs/RUNBOOK.md).

## Versions

The chart has its own [semantic version](https://semver.org/) (`version` in
`Chart.yaml`), bumped on every chart change. `appVersion` is the portal
release it deploys by default; override it with `image.tag`.

## Releasing

1. Bump `version` in `charts/pocket-portal/Chart.yaml` (and `appVersion`
   when moving to a new portal release) in a pull request.
2. After merge, tag it: `git tag vX.Y.Z && git push origin vX.Y.Z`, with
   `X.Y.Z` equal to the chart's `version`. The release workflow checks
   that, packages the chart and pushes it to
   `oci://ghcr.io/fb-univ/charts/pocket-portal`.

## License

[AGPL-3.0-or-later](LICENSE), like the portal.
