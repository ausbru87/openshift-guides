# Helper Host Setup

This section describes how to prepare and configure the helper VMs and hosts required for an OpenShift airgap deployment.

---

## 1. Free Up OCP Servers

- **Build the ESXi hosts and migrate workloads off of the target OCP servers.**
- **Reminder:** You need **three bare-metal servers** available to deploy OpenShift.

---

## 2. Create Helper VMs (on vSphere)

Provision the following VMs with the specified resources and roles:

| Host Name             | Network            | vCPU | RAM   | Disk   | Ports         | OS       | Tools/Packages Installed                                                                                                                                         | Purpose                                                                                      |
|-----------------------|--------------------|------|-------|--------|---------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|
| `oc-tools`            | air-gap            | 4    | 8GB   | 100GB  | N/A           | RHEL 9   | [openshift-tools](../99-references/openshift-tools.md), [dnf-tools](../99-references/dnf-tools.md), [foss-tools](../99-references/foss-tools.md)                 | Main management host for installing OpenShift, running CLI tools, and managing cluster assets.|
| `mirror-registry`     | air-gap            | 4    | 8GB   | 1TB    | TCP443   | RHEL 9   | [openshift-tools](../99-references/openshift-tools.md), [dnf-tools](../99-references/dnf-tools.md)                                                               | Hosts the temporary, air-gapped container image registry for mirroring and cluster bootstrap. |
| `internet-downloader` | internet-connected | 4    | 8GB   | 1TB    | N/A           | RHEL 8/9 | [openshift-tools](../99-references/openshift-tools.md), [dnf-tools](../99-references/dnf-tools.md)                                                               | Downloads images, tools, and content from the internet for transfer into the airgapped zone.  |
| `bootstrap`           | air-gap            | 8    | 16GB  | 120GB  | N/A           | RHCOS    | N/A                                                                                                                                                              | Temporary node required for UPI installs; runs bootstrap services during cluster deployment.  |

---

## 3. Setup `mirror-registry` VM

- **Install packages:**  
  `openssl`, `podman`
- **Set a FQDN:**  
  e.g. `mirror-registry.domain.com` (must resolve via your DNS server)
- **Download and install CLI tool:**  
  [mirror-registry CLI](https://mirror.openshift.com/pub/cgw/mirror-registry/latest/mirror-registry-amd64.tar.gz)
- **Install/setup mirror registry:**  
  Follow the [official documentation](https://access.redhat.com/articles/6986797) for installation and configuration.

---

## 4. Setup `oc-tools` VM

- **Install required tools:**  
  - [OpenShift tools](../99-references/openshift-tools.md)
  - [DNF provided tools](../99-references/dnf-tools.md)
  - [FOSS tools](../99-references/foss-tools.md)

---

## 5. Setup `internet-downloader` VM

- **Install required tools:**  
  - [OpenShift tools](../99-references/openshift-tools.md)
  - [DNF provided tools](../99-references/dnf-tools.md)
- **Storage:**  
  At least **1TB** (recommend 2TB) mounted, e.g., `/data/ocmirror`
- **Purpose:**  
  Used to download images, tools, and content from the internet and transfer them to the airgapped environment.

---

## 6. Setup `bootstrap` VM

- **Provision a VM with:**  
  - **vCPU:** 8  
  - **RAM:** 16GB  
  - **Disk:** 120GB  
  - **OS:** RHCOS (Red Hat CoreOS)
- **Purpose:**  
  The bootstrap node is required for UPI installs. It runs temporary services to bootstrap the OpenShift cluster and can be decommissioned after the control plane is fully up.

---

> **Note:**  
> - The **oc-tools** host is your main management and orchestration node for OpenShift installation and ongoing operations.
> - The **mirror-registry** host is dedicated to running the local image registry required for disconnected installs.
> - The **internet-downloader** host bridges the gap between the internet and your airgapped environment, staging all required content for import.
> - The **bootstrap** host is required for UPI deployments and is only needed during the initial cluster installation process.
