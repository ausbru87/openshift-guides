# Preparation Phase

This section covers all the necessary steps to prepare your environment for an OpenShift airgap deployment. Proper preparation ensures a smooth and successful installation process.

## Contents

- [Infrastructure Preparation](infrastructure-preparation.md): 
  - DNS, network, firewall, NTP, and host setup for all cluster nodes.
- [Helper Host Setup](helper-host-setup.md): 
  - Setting up any additional hosts needed for the deployment process (e.g., bastion, utility hosts).
- [Internet Downloader Host Setup](internet-downloader-host-setup.md): 
  - Configure a host with internet access to download and transfer necessary files to the airgapped environment.
- [Mirror Registry Setup](mirror-registry-setup.md): 
  - Set up a local mirror registry and perform image mirroring.
- [Reference Materials](../99-references/README.md): 
  - Additional reference materials and documentation for the deployment process.

## Overview

Before proceeding with the deployment, ensure you have:
- Access to all required installation media and software.
- Sufficient hardware resources for your OpenShift cluster.
- Network connectivity between your hosts and the local registry.
- All prerequisites documented in the [Required Tools Installation](tools-installation.md) section.

Continue to each step in order for best results.