# Phase 4: Supporting Services Setup (DNS, NTP, NFS)

This phase sets up the foundational network and infrastructure services required for a disconnected OpenShift deployment, including DNS, NTP, and NFS.

---

## 🌐 Internal DNS Configuration

The internal DNS server provides name resolution for all OpenShift nodes and services.

### Install and Configure BIND

```bash
sudo dnf install -y bind bind-utils
```

### Configure `/etc/named.conf`

Define the zones and restrict access to the cluster subnet.

```bash
listen-on port 53 { 127.0.0.1; 192.168.1.12; };
allow-query { localhost; 192.168.1.0/24; };
recursion yes;
forwarders {
  8.8.8.8;
  8.8.4.4;
};
```

### Create DNS Zones

- Forward zone: `test.com`
- Reverse zone: `1.168.192.in-addr.arpa`

Use A and PTR records for each host and service. Include:

- All master nodes
- Bootstrap
- Mirror
- Octools
- Content
- NFS
- VIPs: `api.ove.test.com`, `api-int.ove.test.com`, `*.apps.ove.test.com`

### Enable DNS Service

```bash
sudo systemctl enable --now named
sudo firewall-cmd --permanent --add-service=dns
sudo firewall-cmd --reload
```

---

## 🕒 Internal NTP Server Setup

Use `chrony` to configure an internal NTP server to keep all cluster nodes in sync.

### Install chrony

```bash
sudo dnf install -y chrony
```

### Configure `/etc/chrony.conf`

```bash
allow 192.168.1.0/24
local stratum 3
makestep 1.0 3
rtcsync
logdir /var/log/chrony
```

> ⏱️ Sync the server's clock externally *before* isolating it from the internet.

### Enable NTP Service

```bash
sudo systemctl enable --now chronyd
sudo firewall-cmd --permanent --add-service=ntp
sudo firewall-cmd --reload
```

---

## 💾 NFS Storage Server Setup

The NFS server provides persistent volume storage for the OpenShift cluster.

### Install NFS Utilities

```bash
sudo dnf install -y nfs-utils
```

### Create LVM-backed Volumes

> ⚠️ Replace `/dev/sdb` with the correct block device based on your host's configuration. Use `lsblk` or `fdisk -l` to confirm.

```bash
sudo pvcreate /dev/sdb
sudo vgcreate storage-vg /dev/sdb
sudo lvcreate -L 1500G -n ssd-lv storage-vg
sudo lvcreate -L 1400G -n hdd-lv storage-vg
```

### Format and Mount

> ⚠️ Ensure the logical volumes reflect your disk names and logical volume setup.

```bash
sudo mkfs.xfs /dev/storage-vg/ssd-lv
sudo mkfs.xfs /dev/storage-vg/hdd-lv

sudo mkdir -p /exports/nfs-ssd /exports/nfs-hdd
```

### Configure `/etc/fstab`

```bash
/dev/storage-vg/ssd-lv /exports/nfs-ssd xfs defaults 0 0
/dev/storage-vg/hdd-lv /exports/nfs-hdd xfs defaults 0 0
```

### Configure Exports

```bash
/exports/nfs-ssd 192.168.1.0/24(rw,sync,no_root_squash,no_all_squash,security_label)
/exports/nfs-hdd 192.168.1.0/24(rw,sync,no_root_squash,no_all_squash,security_label)
```

### Start NFS Services

```bash
sudo systemctl enable --now rpcbind nfs-server
sudo exportfs -rv

sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=mountd
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --reload
```

---

## ✅ Outcome

By the end of this phase:

- All internal services (DNS, NTP, NFS) are online
- All cluster nodes will be able to resolve, synchronize time, and access storage

Next: [Image Transfer & Registry Setup →](05_image-transfer.md)

