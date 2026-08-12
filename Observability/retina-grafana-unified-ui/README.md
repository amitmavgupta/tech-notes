# Retina Unified UI

A minimal, static single-page UI that provides tabbed access to Hubble UI (live flow topology) and Grafana (Prometheus dashboards used by Retina). The page embeds each application in an <iframe> and lets you set the target endpoints from the header "⚙ endpoints" panel — no build step, no backend.

This README follows the tech-notes repository conventions: concise overview, quick-start, manifests, important operational notes, and direct links to files in this workspace.

Quick links

- Page: [index.html](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/index.html)
- Manifests folder: [/Kubernetes/Observability/retina-grafana-unified-ui/k8s/](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/k8s/)

Quick start (local development)

Prerequisite: Retina installed with Hubble control plane and Prometheus/Grafana per the Retina docs: https://retina.sh/docs/Installation/Setup

1. Port-forward both services (each command in its own terminal):

```sh
kubectl port-forward -n kube-system svc/hubble-ui 8081:80
kubectl port-forward -n kube-system svc/prometheus-grafana 8080:80
```

2. Open the local page: double-click [index.html](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/index.html) or run `open index.html` / `xdg-open index.html`.

3. Defaults point to `http://localhost:8081` (Hubble UI) and `http://localhost:8080` (Grafana). Use the Overview tab or the two tabs to switch between apps.

Get Grafana credentials:

```sh
kubectl get secret -n kube-system prometheus-grafana \
  -o jsonpath="{.data.admin-user}" | base64 --decode; echo
kubectl get secret -n kube-system prometheus-grafana \
  -o jsonpath="{.data.admin-password}" | base64 --decode; echo
```

If your ports differ, open the "⚙ endpoints" panel in the header and update the URLs — they are stored in browser local storage.

Serving from the cluster

This repository includes Kubernetes manifests to run the static page in-cluster (nginx) so the team can use a shared URL instead of individual port-forwards.

Manifests (workspace links)

- [configmap.yaml](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/k8s/configmap.yaml) — index.html mounted into nginx
- [deployment.yaml](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/k8s/deployment.yaml) — nginx deployment
- [service.yaml](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/k8s/service.yaml)
- [ingress.yaml](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/k8s/ingress.yaml) — host-based routing example

Apply the manifests:

```sh
kubectl apply -f k8s/
```

Important: use host-based routing, not path-based

These manifests are designed to route by hostname (for example `observability.example.com`, `hubble.example.com`, and `grafana.example.com`) rather than by path. Hubble UI serves static assets with absolute root paths (`/static/js/...`) and does not support being hosted under a sub-path without fragile HTML rewriting. Host-based routing avoids these problems and lets each app be served from the root it expects.

Grafana supports sub-path serving via GF_SERVER_SERVE_FROM_SUB_PATH; if you prefer a single hostname you can configure Grafana accordingly (see the comment in the linked [ingress.yaml](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/k8s/ingress.yaml)).

Grafana: allow embedding in iframes

Grafana blocks being iframed by default. To allow embedding, set the following in your kube-prometheus-stack values (or grafana.ini):

```yaml
grafana:
  grafana.ini:
    security:
      allow_embedding: true
    # cookie_samesite: disabled   # if using SSO/OAuth and seeing cookie issues
```

Hubble UI does not set X-Frame-Options and embeds without extra configuration.

After deploying

- Update the endpoints in the page (⚙ endpoints) to the real hostnames (for example `https://hubble.example.com` and `https://grafana.example.com`), or edit the `DEFAULTS` object in [k8s/configmap.yaml](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/Kubernetes/Observability/retina-grafana-unified-ui/k8s/configmap.yaml) before applying for turnkey behavior.

Notes & operational considerations

- This approach intentionally keeps each application's origin separate and uses iframes rather than trying to proxy/merge two apps into one origin — merging breaks in practice due to cookies, CSP, and asset path expectations. Iframing two origins is simpler and more reliable.
- If corporate CSP, proxy, or browser policies block cross-origin framing, each pane includes an "open in new tab ↗" fallback.
- When exposing Grafana publicly, ensure proper authentication, TLS, and network controls are in place.

See also

- Retina: https://retina.sh/
- Hubble UI: check your cluster's hubble-ui service

License & attribution

Content in this folder is provided as-is for operational convenience. See the repository top-level [LICENSE](/Users/amit.gupta1/Downloads/tech-notes/tech-notes.worktrees/kubernetes-observability-grafana-retina/LICENSE) for licensing information.

---

Last updated: 2026-08-12
