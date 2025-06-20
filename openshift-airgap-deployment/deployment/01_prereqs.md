# Phase 1: Prerequisites and Planning

This document outlines the infrastructure, network, and software prerequisites for deploying OpenShift 4.18 in an air-gapped, FIPS-compliant environment.

---

## 🔐 Security & Compliance

- **FIPS Mode** must be enabled on all relevant hosts _before_ any OpenShift operations.
- This includes:
  - The installation tools host (`octools`)
  - All RHEL-based VMs
  - OpenShift bare metal nodes

To enable FIPS:
```bash
sudo fips-mode-setup --enable
sudo reboot
```

Verify FIPS:
```bash
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled
```

---

## 🧠 Required Skills

- OpenShift 4.18 administration
- RHEL system administration and FIPS management
- DNS / BIND / NTP configuration
- Podman and container registry operations
- LVM and NFS storage management

---

## 💾 Infrastructure Requirements

### Bare Metal Servers

| Role          | Count | Specs                                        |
|---------------|-------|----------------------------------------------|
| Master Nodes  | 3     | 500GB OS disk, 1TB data disk, 1GbE NIC       |
| NFS Server    | 1     | 3TB SSD storage, 1GbE NIC                    |

### vSphere VM Resources

| VM Name       | vCPU | RAM   | Disk   | OS      | Purpose               |
|---------------|------|-------|--------|---------|------------------------|
| `dns`         | 4    | 4GB   | 100GB  | RHEL9   | DNS/NTP server         |
| `content`     | 4    | 4GB   | 100GB  | RHEL9   | HTTP server (images)   |
| `octools`     | 8    | 16GB  | 200GB  | RHEL9   | FIPS-enabled installer |
| `mirror`      | 8    | 16GB  | 1TB    | RHEL9   | Internal registry      |
| `bootstrap`   | 4    | 16GB  | 120GB  | RHCOS   | Bootstrap node         |

---

## 🌐 Network Requirements

- Single flat network: `192.168.1.0/24`
- Static IP assignments required
- All components must be resolvable via internal DNS
- Internet access required **only** on external mirror host (outside air-gap)

### IP Address Map

| Role                        | Hostname                | IP Address       |
|-----------------------------|--------------------------|------------------|
| Mirror Registry             | tmpregistry.test.com     | 192.168.1.10     |
| DNS / NTP Server            | dns.test.com             | 192.168.1.12*    |
| Content Server              | content.test.com         | 192.168.1.13     |
| Octools (Install Host)      | octools.test.com         | 192.168.1.11     |
| NFS Server                  | nfs.test.com             | 192.168.1.15     |
| Master Node 1               | host01.ove.test.com      | 192.168.1.21     |
| Master Node 2               | host02.ove.test.com      | 192.168.1.22     |
| Master Node 3               | host03.ove.test.com      | 192.168.1.23     |
| Bootstrap Node              | bootstrap.ove.test.com   | 192.168.1.25     |
| API / Internal API / Apps   | VIPs                     | 192.168.1.30-31  |

📌 *Note: DNS originally listed as `.13` in doc, but Lou clarified it's actually `.12`.

---

## 🔐 Credentials and Keys

- Red Hat Pull Secret
- SSH Public Key (for node access)
- Registry credentials (for internal Quay install)

---

## ✅ Pre-Deployment Checklist

- [ ] FIPS mode enabled on all RHEL systems
- [ ] All servers wiped and statically addressed
- [ ] Red Hat pull secret downloaded
- [ ] SSH key generated and accessible
- [ ] vSphere cluster resources allocated
- [ ] External mirror host built and connected

---

Prepared by One Technology Corp

