# Phase 3: Infrastructure Preparation (Bare Metal + vSphere)

This phase covers the provisioning and preparation of the bare metal servers and supporting virtual machines used in the air-gapped OpenShift 4.18 deployment.

---

## 🧱 Physical Server Preparation

### Wipe and Prep Bare Metal Hosts

Ensure all physical disks are clean prior to installation.

For each host:

```bash
# Wipe OS disk
sudo dd if=/dev/zero of=/dev/sda bs=1M count=1000
sudo wipefs -a /dev/sda

# If applicable, wipe data disk
sudo dd if=/dev/zero of=/dev/sdb bs=1M count=1000
sudo wipefs -a /dev/sdb
```

Assign static IPs based on the environment map (see Phase 1).

| Hostname            | Role        | IP Address   |
| ------------------- | ----------- | ------------ |
| host01.ove.test.com | master      | 192.168.1.21 |
| host02.ove.test.com | master      | 192.168.1.22 |
| host03.ove.test.com | master      | 192.168.1.23 |
| nfs.test.com        | NFS Storage | 192.168.1.15 |

---

## 🖥️ vSphere VM Provisioning

Create the following VMs on your vSphere environment. Use static IPs per the prereq section.

| VM Name   | CPU | RAM  | Disk  | OS    | Notes                      |
| --------- | --- | ---- | ----- | ----- | -------------------------- |
| dns       | 4   | 4GB  | 100GB | RHEL9 | DNS + NTP                  |
| content   | 4   | 4GB  | 100GB | RHEL9 | HTTP content server        |
| octools   | 8   | 16GB | 200GB | RHEL9 | OpenShift installer (FIPS) |
| mirror    | 8   | 16GB | 1TB   | RHEL9 | Internal registry host     |
| bootstrap | 4   | 16GB | 120GB | RHCOS | Bootstrap node             |

> 📝 Tip: Label or tag these VMs in vSphere for easier tracking.

---

## 🔐 Configure Static IPs and Hostnames

Ensure each VM has a consistent hostname and static IP assignment that matches internal DNS entries.

Example (`/etc/hostname` and `/etc/hosts`):

```bash
hostnamectl set-hostname dns.test.com

# /etc/hosts
192.168.1.13 dns.test.com
```

Ensure time is correctly synced using the future internal NTP server (`192.168.1.12`).

---

---

Next: Supporting Services Setup →

