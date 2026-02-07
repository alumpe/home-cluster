# AdGuard DNS Test - PowerShell Commands

## Test with Full Resolution (Follow CNAME Chain)

```powershell
# Test with NoRecursion to see the direct response from AdGuard
Resolve-DnsName -Name "adguard.alumpe.de" -Server "192.168.178.144" -Type A -DnsOnly

# Test longhorn dashboard
Resolve-DnsName -Name "longhorn.alumpe.de" -Server "192.168.178.144" -Type A -DnsOnly
```

## Alternative: Test with nslookup

```powershell
# Interactive nslookup
nslookup
server 192.168.178.144
adguard.alumpe.de
set type=a
adguard.alumpe.de
exit
```

## One-liner Test Commands

```powershell
# Direct A record query
[System.Net.Dns]::GetHostAddresses("adguard.alumpe.de") | Where-Object { $_.AddressFamily -eq 'InterNetwork' }

# Or use Test-Connection to resolve and ping
Test-Connection -ComputerName "adguard.alumpe.de" -Count 1 -ErrorAction SilentlyContinue | Select-Object Address, Status
```

## Verify the CNAME Chain

```powershell
# Step-by-step resolution
Write-Host "=== Testing AdGuard DNS Resolution ===" -ForegroundColor Cyan

# 1. Query AdGuard directly
Write-Host "`n1. Direct query to AdGuard:" -ForegroundColor Yellow
Resolve-DnsName -Name "adguard.alumpe.de" -Server "192.168.178.144" | Format-Table Name, Type, IPAddress, NameHost

# 2. Check if internal.alumpe.de resolves
Write-Host "`n2. Checking if internal.alumpe.de resolves:" -ForegroundColor Yellow
Resolve-DnsName -Name "internal.alumpe.de" -Server "192.168.178.144" | Format-Table Name, Type, IPAddress

# 3. Check against your router/gateway DNS
Write-Host "`n3. Check against router DNS:" -ForegroundColor Yellow
Resolve-DnsName -Name "adguard.alumpe.de" -Server "192.168.178.1" -ErrorAction SilentlyContinue | Format-Table Name, Type, IPAddress, NameHost
```

## Check AdGuard Configuration

```powershell
# View AdGuard web interface
Start-Process "http://192.168.178.144"

# Check what DNS server your system is using
Get-DnsClientServerAddress | Where-Object {$_.AddressFamily -eq 'IPv4'} | Format-Table InterfaceAlias, ServerAddresses
```
