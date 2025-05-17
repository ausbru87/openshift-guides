# OpenShift Airgap Deployment Project

This project provides a comprehensive guide and resources for deploying OpenShift in an airgap environment. An airgap deployment is essential for scenarios where direct internet access is not available, ensuring that all necessary components are available locally.

## Project Structure

The project is organized into several key directories, each serving a specific purpose:

- **[images/](images/)**: Contains diagrams and screenshots related to the project.
  
- **[1-preparation/](1-preparation/)**: 
  - [README.md](1-preparation/README.md): Introduces the preparation phase and outlines its importance.
  - [1.1-tools-installation.md](1-preparation/1.1-tools-installation.md): Details the tools required for the deployment and instructions for their installation.
  - [1.2-mirror-registry.md](1-preparation/1.2-mirror-registry.md): Explains how to set up a mirror registry for the deployment.
  - [1.3-image-mirroring.md](1-preparation/1.3-image-mirroring.md): Describes the process of mirroring images for airgap deployment.

- **[2-airgap-setup/](2-airgap-setup/)**: 
  - [README.md](2-airgap-setup/README.md): Provides an overview of the airgap setup process.

- **[3-cluster-deployment/](3-cluster-deployment/)**: 
  - [README.md](3-cluster-deployment/README.md): Provides an overview of the cluster deployment process.

- **[4-post-installation/](4-post-installation/)**: 
  - [README.md](4-post-installation/README.md): Provides an overview of the post-installation process.

- **[5-maintenance/](5-maintenance/)**: 
  - [README.md](5-maintenance/README.md): Provides an overview of maintenance tasks.

- **[troubleshooting/](troubleshooting/)**: 
  - [README.md](troubleshooting/README.md): Provides guidance on common issues and their resolutions.

- **[sample-configs/](sample-configs/)**: Contains example YAML configuration files for the deployment.
  - [install-config.yaml](sample-configs/install-config.yaml): Installation configuration for the OpenShift cluster.
  - [agent-config.yaml](sample-configs/agent-config.yaml): Configuration for agents used in the deployment.
  - [imageset-config.yaml](sample-configs/imageset-config.yaml): Configuration for image sets used in the deployment.

- **[manifests/](manifests/)**: 
  - [README.md](manifests/README.md): Provides an overview of the manifests used in the project.

- **[scripts/](scripts/)**: 
  - [README.md](scripts/README.md): Provides an overview of the scripts available in the project.

- **[docs/](docs/)**: 
  - [README.md](docs/README.md): Provides an overview of the documentation available.

- **[config/](config/)**: 
  - [README.md](config/README.md): Provides an overview of the configuration files available.

- **[assets/](assets/)**: 
  - [README.md](assets/README.md): Provides an overview of the assets available.

## Getting Started

To get started with the OpenShift airgap deployment, follow the instructions in the [1-preparation/](1-preparation/) directory to ensure you have all the necessary tools and configurations in place. Each subsequent directory will guide you through the airgap setup, cluster deployment, and post-installation processes.

For any issues encountered during the deployment, refer to the [troubleshooting/](troubleshooting/) directory for guidance.