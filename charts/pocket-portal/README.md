# pocket-portal Helm chart

Deploys the portal, and optionally a single Postgres for trying it out.
PocketID is not included: point `config.pocketid.baseUrl` at your own.

```bash
helm install portal oci://ghcr.io/fb-univ/charts/pocket-portal --version <chart version> -f my-values.yaml
# or from a checkout of this repository:
helm install portal ./charts/pocket-portal -f my-values.yaml
```

## What it creates

| Resource | Notes |
|---|---|
| Deployment | `replicaCount` pods (default 2). Stateless: every replica shares `AUTH_SECRET`. |
| Init container | Runs migrations before each pod starts (advisory-locked, so replicas can't collide). |
| ConfigMap | `config:` rendered into the portal's config file (`CONFIG_FILE`). |
| Secret | Created from `secrets:`, unless `secrets.existingSecret` names one. |
| Service | ClusterIP on port 80. |
| Ingress | Only with `ingress.enabled`. |
| PodDisruptionBudget | Only while `replicaCount > 1`. |
| Postgres StatefulSet | Only with `postgresql.enabled` (default). **No backups**: for production, run the database separately and set `secrets.databaseUrl`. Runs as its `postgres` user with a read-only root filesystem. |
| NetworkPolicies | Only with `networkPolicy.enabled`: Postgres accepts only the portal's pods; the portal accepts `networkPolicy.portalIngressFrom`, or anyone while that's empty. |

## Values

See [`values.yaml`](values.yaml), commented throughout. `values.schema.json`
makes `helm install` reject unknown or mistyped keys. The ones you must set:

| Value | |
|---|---|
| `config.pocketid.baseUrl`, `config.pocketid.oidcClientId` | Your PocketID and the portal's OIDC client |
| `config.auth.url` | The portal's public URL (recommended) |
| `secrets.pocketidApiKey`, `secrets.pocketidOidcClientSecret`, `secrets.authSecret` | Or put them in `secrets.existingSecret` |
| `postgresql.auth.password` | With the bundled Postgres, e.g. `openssl rand -hex 24` (encoded into `DATABASE_URL` for you) |
| `secrets.databaseUrl` | Instead, with `postgresql.enabled: false` |

`config:` takes the same keys as [`pocket-portal.example.yaml`](../../../pocket-portal.example.yaml).
Secrets are refused there, by the portal itself.

An `existingSecret` uses the portal's variable names as keys:
`POCKETID_API_KEY`, `POCKETID_OIDC_CLIENT_SECRET`, `AUTH_SECRET`,
`DATABASE_URL`, and optionally `METRICS_TOKEN`, `SMTP_PASSWORD`. With the
bundled Postgres it also needs `POSTGRES_PASSWORD`, matching `DATABASE_URL`.

## Probes

Liveness is `/api/health` (the process answers). Readiness is `/api/ready`,
which also needs Postgres and PocketID, so an outage takes pods out of the
Service without restarting them. Configuration problems are logged at
startup as `Configuration: ...`.
