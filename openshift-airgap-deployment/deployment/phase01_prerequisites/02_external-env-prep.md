# External Environment Preparation and Mirroring for OpenShift 4.18

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

# Create workspace (use a location with sufficient disk space)
mkdir -p /data/openshift-mirror
cd /data/openshift-mirror

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
# Example imageset-config.yaml for OpenShift 4.18
apiVersion: mirror.openshift.io/v2alpha1
kind: ImageSetConfiguration
mirror:
  platform:
    channels:
      - name: stable-4.18
        type: ocp
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
```

> 📝 Tailor `additionalImages` and `operators` to your deployment environment and needs.

---

## 🔐 Authenticate to Registries

```bash
podman login registry.redhat.io
podman login quay.io
```

> 📝 Use your Red Hat Pull Secret to authenticate. If you don't have it, download from the Red Hat Customer Portal.

---

## 📤 Run oc-mirror v2 to Local Disk

```bash
mkdir -p /data/openshift-mirror/mirror-workspace_$(date +%Y%m%d%H%M%S)
export MIRROR_WORKSPACE=/data/openshift-mirror/mirror-workspace_$(date +%Y%m%d%H%M%S)

oc-mirror --config imageset-config.yaml file://${MIRROR_WORKSPACE} --v2
```

Validate:

```bash
ls -lh ${MIRROR_WORKSPACE}
```

Create a tarball:

```bash
cd /data/openshift-mirror

export MIRROR_TAR=openshift-4.18-mirror_$(date +%Y%m%d%H%M%S).tar.gz

tar -czf ${MIRROR_TAR} ${MIRROR_WORKSPACE}
```

---

## 📦 Prepare Software for octools

This section prepares the necessary software tools for OpenShift deployment in an air-gapped environment.

```bash
# Create a directory for the octools software
mkdir -p /data/octools
# download the OpenShift pull secret (use the appropriate URL for your environment)
wget -O /data/octools/pull-secret.json https://console.redhat.com/openshift/downloads/pull-secret
# download the OpenShift Client
curl -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.18.0/openshift-client-linux-4.18.0.tar.gz -o /data/octools/openshift-client-linux-4.18.0.tar.gz
# download the OpenShift Installer
curl -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.18.0/openshift-install-linux-4.18.0.tar.gz -o /data/octools/openshift-install-linux-4.18.0.tar.gz
# download the oc-mirror tool
curl -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/4.18.0/oc-mirror-linux-4.18.0.tar.gz -o /data/octools/oc-mirror-linux-4.18.0.tar.gz
# download butane for RHCOS configuration
curl -L https://mirror.openshift.com/pub/openshift-v4/clients/rhcos/4.18.0/butane-linux-4.18.0.tar.gz -o /data/octools/butane-linux-4.18.0.tar.gz
# download helm3 for package management
curl -L https://get.helm.sh/helm-v3.8.0-linux-amd64.tar.gz -o /data/octools/helm-v3.8.0-linux-amd64.tar.gz
# download the OpenShift RHCOS image
curl -L https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/4.18/latest/rhcos-4.18.0-x86_64-metal.x86_64.raw.gz -o /data/octools/rhcos-4.18.0-x86_64-metal.x86_64.raw.gz

# Create a tarball of the octools software
tar -czf /data/octools/octools-software.tar.gz -C /data/octools .
```


---

## 🚚 Prepare Transfer to Air-Gapped Environment

Copy these artifacts:

- `${MIRROR_TAR}` (the tarball containing all mirrored images)
- `octools-software.tar.gz` (the software tools for OpenShift deployment)
- `imageset-config.yaml` (specific to this environment)
- `pull-secret.json`

Transfer via:

- ✅ USB or removable storage (sneakernet)
- ✅ Secure file transfer (Low to High security environments)

---

## ✅ Summary

You now have a complete set of OpenShift 4.18 images and operators mirrored and ready for deployment in an air-gapped environment. The next steps will involve deploying the OpenShift cluster using the mirrored images and the prepared software tools.

---
## 📝 Notes
- Ensure the `imageset-config.yaml` is kept up-to-date with any new operators or images required for your environment.
- Regularly update the mirror archive to include the latest security patches and updates.
- Test the mirror process in a staging environment before deploying to production.