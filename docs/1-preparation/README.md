# Preparation Phase

This section covers all the necessary steps to prepare your environment for an OpenShift airgap deployment. Proper preparation ensures a smooth and successful installation process.

## Contents

- [Infrastructure Preparation](infrastructure-preparation.md): 
  - DNS, network, firewall, NTP, and host setup for all cluster nodes.
- [Helper Host Setup](helper-host-setup.md): 
  - Setting up any additional hosts needed for the deployment process (e.g., bastion, utility hosts).
- [Required Tools Installation](tools-installation.md): 
  - List of all required tools (OpenShift CLI, Butane, Podman, OpenSSL, jq, yq, curl, wget, git, etc.) and installation instructions for each host.
- [Internet Downloader Host Setup](internet-downloader-host-setup.md): 
  - Configure a host with internet access to download and transfer necessary files to the airgapped environment.
- [Mirror Registry Setup](mirror-registry-setup.md): 
  - Set up a local mirror registry and perform image mirroring.
- [Required Tools Installation](tools-installation.md): 
  - Summary of all required tools for deploying and managing openshift, with links to reference pages for installation:
    - [DNF Provided Tools](../99-references/dnf-tools.md)
    - [OpenShift Tools](../99-references/openshift-tools.md)
    - [FOSS Tools](../99-references/foss-tools.md)

## Overview

Before proceeding with the deployment, ensure you have:
- Access to all required installation media and software.
- Sufficient hardware resources for your OpenShift cluster.
- Network connectivity between your hosts and the local registry.
- All prerequisites documented in the [Required Tools Installation](tools-installation.md) section.

Continue to each step in order for best results.