# Phase 5: Image Transfer & Registry Setup

This phase covers how to bring the mirrored OpenShift image content into the air-gapped environment and configure the internal registry to serve it.

---

## 🚚 Transfer Mirror Archive to Air-Gapped Environment

From the external mirror host:

```bash
# Example: copy to USB storage
cp /tmp/openshift-mirror/openshift-4.18-mirror.tar.gz /media/usb/
cp ~/mirror-workspace/imageset-config.yaml /media/usb/
cp ~/mirror-workspace/pull-secret.json /media/usb/
```

Then, on the FIPS-enabled tools host (`octools`) in the air-gapped environment:

```bash
# Example: copy from USB
cp /media/usb/openshift-4.18-mirror.tar.gz /tmp/
cp /media/usb/imageset-config.yaml /tmp/
cp /media/usb/pull-secret.json /tmp/

# Extract archive
cd /tmp
mkdir working-dir
tar -xzf openshift-4.18-mirror.tar.gz -C working-dir
```

---

## 🛠️ Configure Registry Trust and Authentication

Ensure the internal registry's TLS certificate is trusted:

```bash
openssl s_client -connect tmpregistry.test.com:8443 -showcerts \
  | awk '/BEGIN/,/END/{print $0}' | \
  sudo tee /etc/pki/ca-trust/source/anchors/tmpregistry.crt

sudo update-ca-trust extract
```

Create Docker config file for authentication:

```bash
mkdir -p ~/.docker
cat <<EOF > ~/.docker/config.json
{
  "auths": {
    "tmpregistry.test.com:8443": {
      "auth": "<base64-encoded-auth>",
      "email": "admin@test.com"
    }
  }
}
EOF
```

> 🔐 Replace `<base64-encoded-auth>` with the actual base64 of `init:<password>`.

---

## 🏭 Mirror to Internal Registry

Push content to the mirror registry:

```bash
oc-mirror --config /tmp/imageset-config.yaml \
  --from file:///tmp/working-dir \
  docker://tmpregistry.test.com:8443 --v2
```

Validate:

```bash
ls -lh /tmp/working-dir/cluster-resources/
```

---

## ✅ Outcome

At the end of this phase:

- The internal registry contains all required OpenShift and operator images
- The cluster-resources output is ready to be applied after cluster install

Next: OpenShift Cluster Installation →

