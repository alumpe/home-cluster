# Simplified DNS Architecture - Implementation Complete

## Summary of Changes

### ✅ Removed
- `adguard-dns` deployment (entire directory deleted)
- `adguard-dns/ks.yaml` reference from network kustomization
- `adguard/app/httproute.yaml` (not needed for DNS management)

### ✅ Updated
1. **cloudflare-dns HelmRelease**
   - Now watches both gateways: `envoy-external,envoy-internal`
   - Will create DNS records in Cloudflare for all HTTPRoutes

2. **envoy-internal Gateway**
   - Restored target annotation: `external-dns.alpha.kubernetes.io/target: internal.alumpe.de`
   - This causes external-dns to create CNAME records pointing to `internal.alumpe.de`

## New Architecture

```
┌────────────────────────────────────────────────────────────┐
│  Single external-dns (cloudflare-dns)                      │
│  Watches: envoy-external AND envoy-internal               │
└──────────────────────┬─────────────────────────────────────┘
                       │
                       ▼
              Cloudflare DNS (public)
              ├─ external.alumpe.de → CNAME → tunnel
              ├─ adguard.alumpe.de → CNAME → internal.alumpe.de
              ├─ longhorn.alumpe.de → CNAME → internal.alumpe.de
              └─ internal.alumpe.de → A → 192.168.178.142
                       │
                       ▼
              AdGuard (192.168.178.144)
              ├─ Blocklists/Filtering
              └─ internal.alumpe.de → Local A record → 192.168.178.142
```

## Manual Step Required

**Configure AdGuard Dashboard:**

1. Go to `http://192.168.168.144`
2. Navigate to **Filters** → **DNS rewrites**
3. Add one rewrite rule:
   - Domain: `internal.alumpe.de`
   - Answer: `192.168.178.142`
   - Type: A
4. Delete any old rules created by external-dns (adguard.alumpe.de, longhorn.alumpe.de CNAMEs)

## Testing

Once configured, test with PowerShell:

```powershell
# Test internal services
Resolve-DnsName -Name "adguard.alumpe.de" -Server "192.168.178.144" -Type A
Resolve-DnsName -Name "longhorn.alumpe.de" -Server "192.168.178.144" -Type A

# Should resolve to: 192.168.178.142
```

## Benefits

- ✅ Single external-dns instance to manage
- ✅ All DNS in Cloudflare (single source of truth)
- ✅ Simplified architecture
- ✅ AdGuard just needs 1 manual rewrite rule

## Notes

- Internal DNS requires internet connectivity (queries Cloudflare)
- If Cloudflare is down, internal DNS will fail
- Latency slightly higher (round-trip to Cloudflare)
