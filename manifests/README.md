# README for Manifests Directory

This directory contains Kubernetes manifests that are essential for the OpenShift airgap deployment project. These manifests define the desired state of the various components that will be deployed in the OpenShift cluster.

## Overview

The manifests included in this directory are used to configure and manage the resources required for the deployment. They are crucial for ensuring that the deployment adheres to the specifications and requirements of the airgap environment.

## Getting Started

To utilize the manifests in this directory, follow these steps:

1. Review the provided manifests to understand the resources being defined.
2. Customize the manifests as necessary to fit your specific deployment needs.
3. Apply the manifests to your OpenShift cluster using the `oc apply -f <manifest-file>` command.

## Additional Information

For more detailed instructions on the deployment process, refer to the main project README and the other directories, such as `1-preparation`, `2-airgap-setup`, and `3-cluster-deployment`.