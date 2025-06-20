# Phase 2: External Image Mirroring with oc-mirror v2

This section describes how to use Red Hat's `oc-mirror` v2 tool to prepare OpenShift 4.18 platform images, operators, and supplemental content for use in a disconnected, air-gapped deployment.

Reference: Red Hat oc-mirror plugin v2 documentation

---

## 🎯 Objective

Mirror all required OpenShift and Platform Plus container images to a compressed archive for transfer into an air-gapped environment using the `oc-mirror --v2` workflow.

---

## 🧰 Requirements

- Internet-connected RHEL9 host with:
  - 4 vCPU / 16GB RAM / 1TB storage
  - `podman`, `curl`, `jq`, `wget`, `tar` installed
- Red Hat Pull Secret
- `oc`, `oc-mirror`, and `openshift-install` CLIs downloaded

---

## 🔧 Setup the Mirror Host

```bash
# Install dependencies
sudo dnf install -y podman curl wget jq tar

# Create workspace
mkdir -p ~/mirror-workspace
cd ~/mirror-workspace

# Download oc-mirror v2
curl -L https://console.redhat.com/openshift/downloads/tool-mirror-registry -o oc-mirror.tar.gz
tar xvf oc-mirror.tar.gz
sudo mv oc-mirror /usr/local/bin/
sudo chmod +x /usr/local/bin/oc-mirror

# Verify oc-mirror v2 support
oc-mirror --v2 --help
```

---

## 📦 Create ImageSet Configuration

Save the following to `imageset-config.yaml`. This file will be environment-specific and maintained in your environment's deployment repository (e.g. `env/cluster-x/imageset-config.yaml`).

```yaml
apiVersion: mirror.openshift.io/v2alpha1
kind: ImageSetConfiguration
mirror:
  platform:
    channels:
      - name: stable-4.18
        type: ocp
        minVersion: 4.18.0
        maxVersion: 4.18.20
    graph: true
    kubeVirtContainer: true
  additionalImages:
    - name: registry.redhat.io/ubi9/ubi:latest
    - name: registry.redhat.io/rhel9/rhel-guest-image:latest
    - name: registry.redhat.io/rhel9/support-tools:latest
    - name: registry.redhat.io/openshift4/ose-must-gather:latest
  operators:
    - catalog: registry.redhat.io/redhat/redhat-operator-index:v4.18
      packages:
        - name: kubevirt-hyperconverged
        - name: advanced-cluster-management
        - name: odf-operator
```

> 📝 Tailor `additionalImages` and `operators` to your deployment environment and needs.

---

## 🔐 Authenticate to Registries

```bash
podman login registry.redhat.io
podman login quay.io
```

---

## 📤 Run oc-mirror v2 to Local Disk

```bash
mkdir -p /tmp/openshift-mirror

oc-mirror --config imageset-config.yaml file:///tmp/openshift-mirror --v2
```

Validate:

```bash
ls -lh /tmp/openshift-mirror/working-dir/
```

Create a tarball:

```bash
cd /tmp/openshift-mirror

# Optional: confirm integrity before compression
find working-dir -type f | wc -l

tar -czf openshift-4.18-mirror.tar.gz working-dir/
```

---

## 🚚 Prepare Transfer to Air-Gapped Environment

Copy these artifacts:

- `/tmp/openshift-mirror/openshift-4.18-mirror.tar.gz`
- `imageset-config.yaml` (specific to this environment)
- `pull-secret.json`

Transfer via:

- ✅ USB or removable storage
- ✅ Temporary SFTP (if allowed by policy)

---

## ✅ Summary

You now have a portable mirror archive containing OpenShift core and operator content, ready for deployment in a disconnected environment.

Next: Infrastructure Prep →

