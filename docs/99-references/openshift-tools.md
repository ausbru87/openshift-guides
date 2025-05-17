# OpenShift Tools

Several tools are required or recommended for managing and deploying OpenShift clusters. These tools are typically not available via the default OS package manager and must be downloaded directly from Red Hat or their respective upstream sources. For security compliance, ensure you are downloading the **FIPS-enabled** versions where available.

Below are the most commonly used OpenShift tools:

- **oc (OpenShift CLI) [FIPS-enabled]**  
  The primary command-line tool for managing OpenShift clusters.  
  [Download FIPS-enabled version](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/)  
  *(Look for files with `-fips` in the name, e.g., `openshift-client-linux-fips.tar.gz`)*

- **openshift-install [FIPS-enabled]**  
  The OpenShift installer used to deploy new clusters.  
  [Download FIPS-enabled version](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/)  
  *(Look for files with `-fips` in the name, e.g., `openshift-install-linux-fips.tar.gz`)*

- **oc-mirror plugin**  
  Plugin for the `oc` CLI to assist with mirroring OpenShift images and catalogs.  
  [Download instructions](https://access.redhat.com/documentation/en-us/openshift_container_platform/latest/cli_reference/openshift_cli/oc-mirror-release-notes)

- **mirror-registry**  
  A lightweight, local container image registry for disconnected installs.  
  [Download and install instructions](https://access.redhat.com/articles/6986797)  
  *(Requires Red Hat login and entitlement)*

- **butane**  
  Utility for generating Ignition configs from Butane (YAML) files.  
  [Download and install instructions](https://github.com/coreos/butane/releases)

- **coreos-installer**  
  Tool for installing Fedora CoreOS and Red Hat CoreOS images.  
  [Download and install instructions](https://github.com/coreos/coreos-installer/releases)

> **Tip:**  
> Download these tools on a host with internet access and transfer them to your airgapped environment as needed.  
> Always verify you are using the FIPS-enabled versions for compliance if required in your environment.