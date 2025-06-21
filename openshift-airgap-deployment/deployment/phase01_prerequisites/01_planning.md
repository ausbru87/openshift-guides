# Planning

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
| NFS Server    | 1     | 3TB SSD storage, 3TB HDD, 1GbE NIC           |

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
| Octools (Install Host)      | octools.test.com         | 192.168.1.11     |
| DNS / NTP Server            | dns.test.com             | 192.168.1.12     |
| Content Server              | content.test.com         | 192.168.1.13     |
| NFS Server                  | nfs.test.com             | 192.168.1.15     |
| Master Node 1               | host01.ove.test.com      | 192.168.1.21     |
| Master Node 2               | host02.ove.test.com      | 192.168.1.22     |
| Master Node 3               | host03.ove.test.com      | 192.168.1.23     |
| Bootstrap Node              | bootstrap.ove.test.com   | 192.168.1.25     |
| OpenShift API               | api.ove.test.com         | 192.168.1.31     |
| OpenShift Ingress           | *.apps.ove.test.com      | 192.168.1.32     |

---

## 🔐 Credentials and Keys

- Red Hat Pull Secret
- SSH Public Key (for node access)
- Registry credentials (for internal Quay install)
- *.apps.ove.test.com wildcard Certificate (if using TLS)
- api.ove.test.com Certificate (if using TLS)
- tmpregistry.test.com Certificate (if using TLS)

---

## 🛠️ Software Requirements
- **RHEL 9** for all VMs and bare metal nodes
- **RHCOS 4.18** for bootstrap node
- **OpenShift 4.18** installer (octools)
- **oc-client** for OpenShift CLI operations
- **oc-mirror v2** for mirroring images
- **butane** for RHCOS configuration
- **helm3** for package management
- **Podman** for container management
- **NFS** for shared storage
- **BIND** for DNS
- **NTP** for time synchronization
- **HTTP server** for content delivery (Apache or Nginx)
- **mirror-registry** for temporary internal container registry (optional)
- **LVM** for disk management on bare metal nodes
- **firewalld** for firewall management (if applicable)
- **SELinux** in enforcing mode (default on RHEL)
- **FIPS** mode enabled on all systems
- **tar** for archiving and transferring images
- **curl**, **wget**, **jq** for various scripting tasks

## ✅ Pre-Deployment Checklist

- [ ] FIPS mode enabled on all RHEL systems
- [ ] All servers wiped and statically addressed
- [ ] Red Hat pull secret downloaded
- [ ] SSH key generated and accessible
- [ ] vSphere cluster resources allocated
- [ ] External mirror host built and connected
- [ ] DNS server configured with all required records
- [ ] NTP server configured and synchronized
- [ ] NFS server configured and accessible
- [ ] Content server populated with required OpenShift RHCOS image
- [ ] Internal registry (tmpregistry) set up and accessible
- [ ] OpenShift installer (octools) downloaded and configured
- [ ] Bootstrap node prepared with RHCOS image
- [ ] All VMs and bare metal nodes reachable via internal DNS
- [ ] All required certificates generated and distributed;
- [ ] Firewall rules configured to allow necessary traffic
- [ ] SELinux in enforcing mode
- [ ] LVM configured on bare metal nodes
- [ ] Podman and container registry configured
- [ ] OpenShift CLI (`oc`) installed on octools host
- [ ] OpenShift mirror tool (`oc-mirror`) installed on octools host
- [ ] Butane installed on octools host for RHCOS configuration
- [ ] Helm3 installed on octools host for package management
- [ ] All hosts updated to latest RHEL 9 patches
- [ ] All hosts rebooted after FIPS and updates
- [ ] Documentation for all steps and configurations completed
- [ ] Backup of all configurations and important files taken
- [ ] Final review of all prerequisites completed

