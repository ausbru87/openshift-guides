# Generate Installation Configs

## Generate the installation configs

```bash
openshift-install create install-config --dir=install-configs
```
> 📝 This command generates the `install-config.yaml` file in the `install-configs` directory. You can customize this file as needed.

## Customize the Installation Config
You can edit the `install-config.yaml` file to adjust settings such as:
- Cluster name
- Base domain
- Pull secret
- SSH public keys
- Platform-specific settings (e.g., vSphere, bare metal)
- Networking configuration
- Additional images or operators
- FIPS settings
- ImageSource configuration

### Example of a custom `install-config.yaml` file:
```yaml
apiVersion: v1
baseDomain: test.com
metadata:
  name: ove
networking:
  networkType: OVNKubernetes
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  serviceNetwork:
  - 172.30.0.0/16
  machineNetwork:
  - cidr: 192.168.1.0/24
compute:
- name: worker
  replicas: 0
controlPlane:
  name: master
  replicas: 3
  platform:
    baremetal: {}
platform:
  baremetal:
    apiVIPs:
    - 192.168.1.30
    ingressVIPs:
    - 192.168.1.31
    hosts:
    - name: host01
      role: master
      bootMACAddress: "<mac_address_of_host01>"
      rootDeviceHints:
        deviceName: "<storage_device_name_of_host01>"
    - name: host02
      role: master
      bootMACAddress: "<mac_address_of_host02>"
      rootDeviceHints:
        deviceName: "<storage_device_name_of_host02>"
    - name: host03
      role: master
      bootMACAddress: "<mac_address_of_host03>"
      rootDeviceHints:
        deviceName: "<storage_device_name_of_host03>"
fips: true
pullSecret: |
  <your_pull_secret_with_internal_registry>
sshKey: |
  <openshift_user_public_ssh_key>
imageContentSources:
- mirrors:
  - tmpregistry.test.com:8443/openshift/release-images
  source: quay.io/openshift-release-dev/ocp-release
- mirrors:
  - tmpregistry.test.com:8443/openshift/release
  source: quay.io/openshift-release-dev/ocp-v4.0-art-dev
additionalTrustBundle: |
  -----BEGIN CERTIFICATE-----
  < content of /data/openshift/tmpregistry.crt>
  -----END CERTIFICATE-----
  # Add additional certificates if required
```

## Generate Manifests
```bash
openshift-install create manifests --dir=install-configs
```
> 📝 This command generates the manifests required for the installation, including the `cluster-scheduler-02-config.yaml` and `cluster-network-02-config.yaml` files.

## Generate Ignition Configs
```bash
openshift-install create ignition-configs --dir=install-configs
```
> 📝 This command generates the Ignition configuration files needed for the bootstrap and control plane nodes. These files are essential for bootstrapping the OpenShift cluster.

### Configure master Ignition Files


## Verify Generated Files
```bash
ls -l install-configs
```

> 📝 You should see the following files:
- `install-config.yaml`
- `manifests/`
- `ignition/`
- `bootstrap.ign`
- `master.ign`
- `worker.ign`
- `cluster-scheduler-02-config.yaml`
- `cluster-network-02-config.yaml`

## Customize Generated Manifests and Ignition Files
You can further customize the generated manifests and Ignition files as needed. For example, you may want to adjust the scheduler configuration or network settings based on your specific requirements.

### Customize Ignition Files
You can edit the Ignition files (`bootstrap.ign`, `master.ign`, `worker.ign`) to add additional configuration, such as:
- Additional systemd services
- Custom scripts or configurations
- Additional storage configurations

### Customize Manifests
You can edit the manifests in the `manifests/` directory to adjust cluster settings, such as:
- Scheduler configuration
- Network configuration
- Additional operators or custom resources

```bash
# Edit NTP configuration to use the internal NTP server


