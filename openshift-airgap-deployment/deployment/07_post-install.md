# Phase 7: Post-Install Configuration

This phase ensures your OpenShift 4.18 cluster is operational, properly configured, and aligned with air-gapped and FIPS-mode requirements after the core installation is complete.

---

## 🔍 Validate Cluster Status

Ensure all nodes are Ready:

```bash
oc get nodes
```

Verify core components:

```bash
oc get clusteroperators
oc get co -o wide
```

Confirm all pods are running:

```bash
oc get pods -A
```

---

## 📦 Apply Cluster Resources from Mirror Output

Your `oc-mirror` run created manifests in the `cluster-resources/` directory. Apply them now:

```bash
oc apply -f /tmp/working-dir/oc-mirror-workspace/results-*/cluster-resources
```

This includes:

- `ImageDigestMirrorSet`
- `CatalogSource` objects for OperatorHub

---

## 🛡️ Enable FIPS Enforcement (Optional)

You may validate and/or enforce FIPS kernel args on master nodes with MachineConfigs if required:

```yaml
spec:
  kernelArguments:
    - fips=1
```

Confirm with:

```bash
oc debug node/<node-name>
chroot /host
fips-mode-setup --check
```

---

## 🕵️ Disable Telemetry and Insights (if required)

If your cluster is strictly air-gapped:

```bash
oc patch clusterversion version -p '{"spec":{"telemetry":{"enabled": false}}}' --type=merge
oc patch console.operator cluster -p '{"spec":{"plugins":[]}}' --type=merge
```

Disable Insights Operator:

```bash
oc scale deployment insights-operator -n openshift-insights --replicas=0
```

---

## 🎛️ Registry Route and Certificate Setup (if exposing internally)

Optionally expose the internal registry:

```bash
oc patch configs.imageregistry.operator.openshift.io cluster \
  --type=merge -p '{"spec":{"defaultRoute":true}}'
```

Then retrieve the hostname:

```bash
oc get route default-route -n openshift-image-registry
```

Apply internal certificates as needed to trust the route.

---

## ✅ Outcome

By the end of this phase:

- Cluster services are verified and operational
- Operator catalogs are available
- FIPS and telemetry are configured per policy
- Internal registry route is optionally exposed and trusted

Next: Platform Add-ons & Operators →

