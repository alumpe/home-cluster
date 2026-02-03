# AGENTS.md

## Project Overview

This is a **Kubernetes Home Cluster** - a GitOps-based infrastructure-as-code project for managing a production-ready Kubernetes cluster at home using Talos Linux and Flux CD.

**Key characteristics:**
- Uses Talos Linux (immutable, security-focused OS) on bare metal or VMs
- GitOps workflow with Flux CD for continuous deployment
- SOPS encryption for secrets management
- Cloudflare integration for external access and DNS

## Architecture

- **3 control plane nodes** (arrakis, caladan, giedi) - all can run workloads
- **GitOps:** Cluster state continuously synced from this repository

## Project Structure

| Directory | Purpose |
|-----------|---------|
| `kubernetes/` | Main K8s manifests organized by namespace (apps/, flux/, components/) |
| `talos/` | Talos Linux configuration files and generated cluster configs |
| `bootstrap/` | Bootstrap configurations (helmfile.d/, sops-age.sops.yaml) |
| `.taskfiles/` | Task automation configs (bootstrap/, talos/) |
| `scripts/` | Bootstrap and utility scripts |
| `.github/` | CI/CD workflows (flux-local, label-sync, labeler) |

## Tech Stack

- **Talos Linux** - Immutable OS for K8s nodes
- **Flux CD** - GitOps continuous delivery
- **Cilium** - eBPF-based CNI
- **Envoy Gateway** - Ingress gateway
- **cert-manager** - TLS certificate automation
- **Cloudflare** - DNS, tunneling, and external access
- **SOPS + Age** - Secret encryption

## Conventions

- **Secrets:** All `.sops.yaml` files are encrypted with Age keys
- **Apps:** Organized by namespace in `kubernetes/apps/<namespace>/`
- **Flux:** Uses HelmRelease and Kustomization resources
- **Tasks:** Use `task` command for all automation
- **Renovate:** Automated dependency updates via PRs

## Important Files

| File | Purpose |
|------|---------|
| `talos/talconfig.yaml` | Talos cluster node definitions |
| `talos/talenv.yaml` | Talos/K8s version definitions |
| `.sops.yaml` | SOPS encryption rules |
| `kubernetes/flux/cluster/ks.yaml` | Root Flux Kustomization |
| `Taskfile.yaml` | Task runner configuration |

## Security Notes

- All secrets must be encrypted with SOPS before committing
- Nodes run combined control plane + worker roles
- Uses split DNS: internal (`k8s-gateway`) and external (Cloudflare)

## Agent Guidelines

**IMPORTANT:** Never commit and push changes to git unless explicitly instructed to do so by the user. Always wait for explicit confirmation before committing or pushing any changes.
