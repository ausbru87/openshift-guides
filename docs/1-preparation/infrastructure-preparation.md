# Infrastructure Preparation

Proper infrastructure preparation is critical for a successful OpenShift airgap deployment. This section outlines the key requirements and steps for preparing your environment.

## 1. Networking

- **DNS:**  
  Ensure forward and reverse DNS records exist for all cluster nodes, including API, Ingress, and etcd endpoints.
- **Networking:**  
  - Assign static IP addresses to all nodes.
  - Configure required subnets, VLANs, and routing.
  - Verify connectivity between all nodes and the mirror registry.
- **Firewall:**  
  Open required ports between nodes, and between nodes and the mirror registry. Refer to the [OpenShift documentation](https://docs.openshift.com/container-platform/latest/installing/installing_platform_agnostic/installing-platform-agnostic.html#installation-network-user-infra_installing-platform-agnostic) for a list of required ports.

## 2. Time Synchronization

- **NTP:**  
  Configure all nodes to use a reliable NTP source to ensure time consistency across the cluster.

## 3. Host Preparation

- **Operating System:**  
  Use RHEL 9 or a compatible distribution. Ensure all hosts are updated to the latest patches.
- **Hostname:**  
  Set a unique, fully qualified domain name (FQDN) for each node.
- **SELinux:**  
  Set SELinux to enforcing mode.
- **Swap:**  
  Disable swap on all nodes.
- **Required Packages:**  
  Install all required tools as described in [Required Tools Installation](tools-installation.md).
- **User Accounts:**  
  Ensure you have a user with passwordless sudo privileges for installation and management tasks.

## 4. Storage

- **Local Storage:**  
  Ensure sufficient local storage is available for the OS, container images, and persistent volumes as needed.
- **Registry Storage:**  
  Plan for additional storage for the mirror registry, especially if mirroring multiple OpenShift releases or Operator catalogs.

## 5. Additional Recommendations

- **SSH Access:**  
  Set up SSH key-based authentication between your management host and all cluster nodes.
- **Backup:**  
  Take a backup or snapshot of your infrastructure before starting the deployment.

---

> **Tip:**  
> Document all IP addresses, hostnames, and network details for reference during the deployment process.