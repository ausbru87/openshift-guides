# Airgapped Environment Infrastructure Preparation

This document outlines the steps to prepare your air-gapped infrastructure for deploying OpenShift 4.18, including physical server preparation, vSphere VM provisioning, and network configuration.

---

## 🧱 Physical Server Preparation

### Wipe Bare Metal Hosts

Ensure all physical disks are clean prior to installation.

For each host:

> **Warning:** This operation will irreversibly erase all data on the specified disks. Double-check disk identifiers before proceeding.

```bash
> This operation will irreversibly erase all data on the specified disks. Double-check disk identifiers before proceeding.

```bash
# Wipe OS disk (use the appropriate disk identifier)
sudo dd if=/dev/zero of=/dev/sda bs=1M count=1000
sudo wipefs -a /dev/sda

# If applicable, wipe data disk (use the appropriate disk identifier)
sudo dd if=/dev/zero of=/dev/sdb bs=1M count=1000
sudo wipefs -a /dev/sdb
```

### Collect Host Information
Collect the following information for each bare metal host to be used in the installation configuration during the OpenShift installation process.

| Hostname            | Role        | IP Address   | MAC Address          | Root Disk Device | 
| host01.ove.test.com | master/worker     | 192.168.1.21 | 00:11:22:33:44:55    | /dev/sda         |
| host02.ove.test.com | master/worker     | 192.168.1.22 | 00:11:22:33:44:56    | /dev/sda         |
| host03.ove.test.com | master/worker     | 192.168.1.23 | 00:11:22:33:44:57    | /dev/sda         |

> **NOTE:** All these MAC addresses and storage devices are examples. Replace them with the actual MAC addresses and storage devices of your hosts.

### Configure Network Interfaces

Assuming that there is a single network interface per host, configure the network interfaces with static IPs as per the environment map. 


> All these MAC addresses are examples. Replace them with the actual MAC addresses of your hosts.


Assign static IPs based on the Host table below:

| Hostname            | Role        | IP Address   |
| ------------------- | ----------- | ------------ |
| host01.ove.test.com | master      | 192.168.1.21 |
| host02.ove.test.com | master      | 192.168.1.22 |
| host03.ove.test.com | master      | 192.168.1.23 |
| bootstrap.ove.test.com | bootstrap   | 192.168.1.25 |
| nfs.test.com        | NFS Storage | 192.168.1.15 |
| dns.test.com      | DNS/NTP     | 192.168.1.12 |
| content.test.com    | Content Server | 192.168.1.13 |
| octools.test.com    | OpenShift Installer | 192.168.1.11 |
| tmpregistry.test.com | Mirror Registry | 192.168.1.10 |
---

## 🖥️ vSphere VM Provisioning

Create the following VMs on your vSphere environment.

| VM Name   | CPU | RAM  | Disk  | OS    | Notes                      |
| --------- | --- | ---- | ----- | ----- | -------------------------- |
| dns       | 4   | 4GB  | 100GB | RHEL9 | DNS + NTP                  |
| content   | 4   | 4GB  | 100GB | RHEL9 | HTTP content server        |
| octools   | 8   | 16GB | 200GB | RHEL9 | OpenShift installer (FIPS) |
| mirror    | 8   | 16GB | 1TB   | RHEL9 | Internal registry host     |
| bootstrap | 4   | 16GB | 120GB | RHCOS | Bootstrap node             |

> 📝 Tip: Label or tag these VMs in vSphere for easier tracking.

---

## 📡 Configure `dns.test.com` Host

This host will serve as the DNS and NTP server for the OpenShift cluster and other components on this network.

### DNS Configuration

```bash
# Install BIND DNS server
sudo dnf install -y bind bind-utils

# Backup the default config
sudo cp /etc/named.conf /etc/named.conf.bak

# Configure named.conf for local zone support
sudo tee /etc/named.conf <<EOF
options {
    listen-on port 53 { any; };
    directory "/var/named";
    allow-query { any; };
    recursion no;
    dnssec-enable no;
    dnssec-validation no;
};

zone "test.com" IN {
    type master;
    file "test.com.zone";
};

zone "1.168.192.in-addr.arpa" IN {
    type master;
    file "1.168.192.zone";
};
EOF
```

### Create Zone Files

```bash
# Create forward lookup zone
sudo tee /var/named/test.com.zone <<EOF
\$TTL 86400
@   IN  SOA dns.test.com. admin.test.com. (
        2023100101 ; Serial
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        86400 )    ; Minimum TTL
@       IN  NS      dns.test.com.

dns             IN  A   192.168.1.12
octools         IN  A   192.168.1.11
tmpregistry     IN  A   192.168.1.10
content         IN  A   192.168.1.13
nfs             IN  A   192.168.1.15

host01.ove      IN  A   192.168.1.21
host02.ove      IN  A   192.168.1.22
host03.ove      IN  A   192.168.1.23
bootstrap.ove   IN  A   192.168.1.25

api.ove         IN  A   192.168.1.30
api-int.ove     IN  A   192.168.1.30
*.apps.ove        IN  A   192.168.1.31
EOF

# Create reverse zone
sudo tee /var/named/1.168.192.zone <<EOF
\$TTL 86400
@   IN  SOA dns.test.com. admin.test.com. (
        2023100101 ; Serial
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        86400 )    ; Minimum TTL
@       IN  NS      dns.test.com.

10      IN  PTR     tmpregistry.test.com.
11      IN  PTR     octools.test.com.
12      IN  PTR     dns.test.com.
13      IN  PTR     content.test.com.
15      IN  PTR     nfs.test.com.
21      IN  PTR     host01.ove.test.com.
22      IN  PTR     host02.ove.test.com.
23      IN  PTR     host03.ove.test.com.
25      IN  PTR     bootstrap.ove.test.com.
30      IN  PTR     api.ove.test.com.
31      IN  PTR     apps.ove.test.com.
EOF
```
### Finalize and Enable BIND

```bash
# Set file permissions
sudo chown named:named /var/named/*.zone
sudo chmod 644 /var/named/*.zone

# Enable and start named service
sudo systemctl enable --now named

# Configure firewall
sudo firewall-cmd --permanent --add-service=dns
sudo firewall-cmd --reload

```

### NTP Configuration

```bash
# Install Chrony
sudo dnf install -y chrony

# Backup default config
sudo cp /etc/chrony.conf /etc/chrony.conf.bak

# Configure chrony for LAN access
sudo tee /etc/chrony.conf <<EOF
server 0.rhel.pool.ntp.org iburst
server 1.rhel.pool.ntp.org iburst

allow 192.168.1.0/24
local stratum 10
makestep 1.0 3
driftfile /var/lib/chrony/drift
rtcsync
logdir /var/log/chrony
EOF

# Enable and start NTP
sudo systemctl enable --now chronyd

# Configure firewall
sudo firewall-cmd --permanent --add-service=ntp
sudo firewall-cmd --reload
```

---

## Configure `octools.test.com` Host

This host will serve as the OpenShift installer and management host.

### Enable FIPS Mode

Ensure that the host is running in FIPS mode. This is a requirement for OpenShift installations.

```bash
# Enable FIPS mode
sudo fips-mode-setup --enable
sudo reboot
```

### Verify FIPS Mode
```bash
# Check FIPS mode status
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled
```

### Install RPMs and Setup OpenShift User

Prepare the `octools.test.com` host by installing required packages, creating an OpenShift user.

```bash
# Install required packages
sudo dnf install -y podman curl wget jq tar

# Create OpenShift User
sudo useradd -m openshift

# Add OpenShift user to sudoers
echo "openshift ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/openshift

# Set ownership of OpenShift directory
sudo chown -R openshift:openshift /data/openshift
# Switch to OpenShift user
sudo su - openshift
```

### Mount USB Storage and Extract Downloaded Tools

In a previous phase, you should have prepared the OpenShift tools and software tarball on a USB drive or other removable media that you will now transfer to this host and extract.

> Note: Each of the OpenShift tools is versioned, so ensure you have the correct versions as per your planning document.

```bash

# Move Removable Media prepped in phase 01 to /data/openshift
sudo mkdir -p /data/openshift
sudo mount /dev/sdb1 /mnt/usbstorage
sudo cp -r /mnt/usbstorage/octools-software.tar.gz /data/openshift/
sudo umount /mnt/usbstorage

# Configure Ownership and Permissions
sudo chown -R openshift:openshift /data/openshift
sudo chmod -R 755 /data/openshift

# Create octools directory for OpenShift tools
mkdir -p /data/openshift/octools

# Create bin directory for OpenShift binaries
mkdir -p /data/openshift/bin

# Extract OpenShift tools
tar -zxf /data/openshift/octools-software.tar.gz -C /data/openshift/octools

# Extract OpenShift Client
tar -xzf /data/openshift/octools/openshift-client-linux-4.18.0.tar.gz -C /data/openshift/bin

# Extract OpenShift Installer
tar -xzf /data/openshift/octools/openshift-install-linux-4.18.0.tar.gz -C /data/openshift/bin

# Extract oc-mirror tool
tar -xzf /data/openshift/octools/oc-mirror-linux-4.18.0.tar.gz -C /data/openshift/bin

# Extract butane
tar -xzf /data/openshift/octools/butane-linux-4.18.0.tar.gz -C /data/openshift/bin

# Extract helm3
tar -xzf /data/openshift/octools/helm-v3.8.0-linux-amd64.tar.gz -C /data/openshift/bin --strip-components=1 linux-amd64/helm

# Extract mirror-registry tool
tar -xzf /data/openshift/octools/mirror-registry-linux-4.18.0.tar.gz -C /data/openshift/

# Ensure correct permissions
chmod +x /data/openshift/bin/*
```

### Configure octools Environment

Set up the OpenShift tools environment and add the binaries to the PATH allowing easy access to the OpenShift CLI and other tools.

```bash
# Add bin directory to PATH
echo 'export PATH=$PATH:/data/openshift/bin' >> ~/.bashrc
# Source .bashrc to update PATH
source ~/.bashrc

# Setup autocompletion for OpenShift CLI
oc completion bash > /etc/bash_completion.d/oc

# Setup autocompletion for Helm
helm completion bash > /etc/bash_completion.d/helm

# Generate SSH key for openshift user
ssh-keygen -t rsa -b 4096 -C "
```

### Copy tmpregistry.crt to `octools.test.com` Host

Note: This step assumes you have already set up the `tmpregistry.test.com` host and generated the self-signed certificate. This setup is described in the next section.

```bash
scp tmpregistry.test.com:/data/mirror-registry/tmpregistry.crt /data/openshift/tmpregistry.crt
# Add tmpregistry certificate to trusted certificates
sudo cp /data/openshift/tmpregistry.crt /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust extract

# Verify the certificate is added
openssl x509 -in /etc/pki/ca-trust/source/anchors/tmpregistry.crt -text -noout
```

### Configure tmpregistry.test.com pull-secret

Note: This step assumes you have already set up the `tmpregistry.test.com` host and started the mirror-registry. This setup is described in the next section.

Instead of manually creating the pull secret, you can use `podman login` to generate the authentication file, then copy it to the required location:

```bash

```bash
# Login to the registry (replace <generated_password> with your actual password)
podman login tmpregistry.test.com:8443 -u init -p <generated_password> --tls-verify=false

# Copy the generated auth file to the OpenShift pull secret location
cp ~/.config/containers/auth.json /data/openshift/pull-secret.json
```

> **Note:** The `auth.json` file generated by `podman login` contains the necessary credentials for the registry. Ensure you set the correct permissions on the pull secret file as described below.

```bash
# Ensure the pull secret file has correct permissions
sudo chown openshift:openshift /data/openshift/pull-secret.json
# Set permissions to secure the pull secret
sudo chmod 600 /data/openshift/pull-secret.json

# Verify the pull secret
cat /data/openshift/pull-secret.json
```
---

## Configure `tmpregistry.test.com` Host
This host will serve as the internal OpenShift registry for air-gapped deployments. It will run a minimal Quay registry as part of the mirror-registry tool available in the OpenShift tools.

### Enable FIPS Mode

Ensure that the host is running in FIPS mode. This is a requirement for OpenShift installations.

```bash
# Enable FIPS mode
sudo fips-mode-setup --enable
sudo reboot
```

### Verify FIPS Mode
```bash
# Check FIPS mode status
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled
```

### Install RPMs and Setup OpenShift User

```bash
# Install required packages
sudo dnf install -y podman curl wget jq tar
# Create OpenShift User
sudo useradd -m openshift
# Add OpenShift user to sudoers
echo "openshift ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/openshift
```

### Prepare Mirror Registry

```bash
# Create directories for mirror registry
sudo mkdir -p /data/mirror-registry
sudo chown -R openshift:openshift /data/mirror-registry
# Switch to OpenShift user
sudo su - openshift

# Copy the mirror-registry tool from octools
scp octools:/data/openshift/mirror-registry /data/mirror-registry/

# Install mirror registry with self-signed certificates
sudo ./mirror-registry install \
    --quayHostname tmpregistry.test.com \
    --quayRoot /data/mirror-registry/quay-install

# Configure firewall
sudo firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd --reload

# Test registry access
podman login -u init -p <generated_password> tmpregistry.test.com:8443 --tls-verify=false

# Extract the self-signed certificate
sudo podman cp tmpregistry.test.com:8443/ca.crt /data/mirror-registry/tmpregistry.crt
# Copy the certificate to octools host for later use
scp /data/mirror-registry/tmpregistry.crt octools:/data/openshift/tmpregistry.crt
```

> Note: Replace `<generated_password>` with the password generated during the mirror registry installation. And record this password securely for later use.

### Mount USB Storage and Transfer Mirror Registry Data

You will now use the USB storage to import the mirror registry data to the `tmpregistry.test.com` host.

```bash
# Mount USB storage
sudo mount /dev/sdb1 /mnt/usbstorage
# Copy mirror registry data to /data/mirror-registry/
sudo cp -r /mnt/usbstorage/openshift-4.18-mirror_*.tar.gz /data/mirror-registry/
```

# Extract the mirror registry data and Push content to the internal registry

```bash
# Extract the mirror registry data
cd /data/mirror-registry
sudo tar -xzf openshift-4.18-mirror_*.tar.gz
# Change ownership to openshift user
sudo chown -R openshift:openshift /data/mirror-registry/openshift-4.18-mirror

# Push the content to the internal registry
sudo ./mirror-registry push \
    --quayHostname tmpregistry.test.com \
    --quayRoot /data/mirror-registry/quay-install \
    --mirrorDir /data/mirror-registry/openshift-4.18-mirror

# Verify the content is available in the registry
podman search tmpregistry.test.com:8443/openshift4/ose
```

---
## Configure `content.test.com` Host
This host will serve as the content server for OpenShift images and RHCOS for bootstrapping the cluster.

### Enable FIPS Mode

Ensure that the host is running in FIPS mode. This is a requirement for OpenShift installations.

```bash
# Enable FIPS mode
sudo fips-mode-setup --enable
sudo reboot
```

### Verify FIPS Mode
```bash
# Check FIPS mode status
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled
```

### Install Required Packages for HTTP Server

```bash
# Install required packages
sudo dnf install -y httpd mod_ssl
# Create directories for RHCOS images
sudo mkdir -p /var/www/html/openshift/rhcos
# Create directories for OpenShift Virtualization images
sudo mkdir -p /var/www/html/openshift/virtualization-images
# Set ownership and permissions
sudo chown -R apache:apache /var/www/html/openshift
# Enable and start Apache HTTP server
sudo systemctl enable --now httpd
# Configure firewall
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### Prepare RHCOS and OpenShift Virtualization Images

Move the RHCOS and OpenShift Virtualization images from the `octools` host to the content server. This step assumes you have already downloaded the necessary images to the `octools` host.

```bash
# Copy RHCOS images to content server
scp octools:/data/openshift/rhcos/*.qcow2 /var/www/html/openshift/rhcos/
# Copy OpenShift Virtualization images to content server
scp octools:/data/openshift/virtualization-images/*.qcow2 /var/www/html/openshift/virtualization-images/
# Set permissions for the copied images
sudo chown -R apache:apache /var/www/html/openshift/rhcos
sudo chown -R apache:apache /var/www/html/openshift/virtualization-images
# Set appropriate permissions for the directories
sudo chmod -R 755 /var/www/html/openshift/rhcos
sudo chmod -R 755 /var/www/html/openshift/virtualization-images
```

---

## Configure `nfs.test.com` Host
This host will serve as the NFS server for shared storage across OpenShift nodes.

### Enable FIPS Mode

Ensure that the host is running in FIPS mode. This is a requirement for OpenShift installations.

```bash
# Enable FIPS mode
sudo fips-mode-setup --enable
sudo reboot
```

### Verify FIPS Mode
```bash
# Check FIPS mode status
fips-mode-setup --check
cat /proc/sys/crypto/fips_enabled
```

### Create NFS Storage Volumes

Craete the NFS storage volumes that will be used by OpenShift as nfs-ssd and nfs-hdd storage classes.

```bash
# Create Partitions for NFS storage SSD /dev/nvme0n1
sudo parted /dev/nvme0n1 mklabel gpt
sudo parted -a optimal /dev/nvme0n1 mkpart primary 0% 100%
# Format the partition as XFS
sudo mkfs.xfs -f /dev/nvme0n1p1
# Create mount point for NFS storage
sudo mkdir -p /data/nfs-ssd
# Mount the partition
sudo mount /dev/nvme0n1p1 /data/nfs-ssd
# Add to /etc/fstab for persistence
echo '/dev/nvme0n1p1 /data/nfs-ssd xfs defaults 0 0' | sudo tee -a /etc/fstab

# Create Partitions for NFS storage HDD /dev/sdb
sudo parted /dev/sdb mklabel gpt
sudo parted -a optimal /dev/sdb mkpart primary 0% 100%
# Format the partition as XFS
sudo mkfs.xfs -f /dev/sdb1
# Create mount point for NFS storage
sudo mkdir -p /data/nfs-hdd
# Mount the partition
sudo mount /dev/sdb1 /data/nfs-hdd
# Add to /etc/fstab for persistence
echo '/dev/sdb1 /data/nfs-hdd xfs defaults 0 0' | sudo tee -a /etc/fstab
```

### Install and Configure NFS Server

Expose the NFS storage directories to the OpenShift nodes.

```bash
# Install NFS server packages
sudo dnf install -y nfs-utils

# Update /etc/exports to share the directories
echo '/data/nfs-ssd *(rw,sync,no_root_squash)' | sudo tee -a /etc/exports
echo '/data/nfs-hdd *(rw,sync,no_root_squash)' | sudo tee -a /etc/exports

# Export the NFS shares
sudo exportfs -a
# Enable and start NFS server
sudo systemctl enable --now nfs-server
# Configure firewall for NFS
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload

# Verify NFS shares
showmount -e localhost
```

> Ensure the NFS server is accessible from all OpenShift nodes.

---