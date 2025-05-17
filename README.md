# OpenShift Airgap Deployment Project

This project provides a comprehensive guide and resources for deploying OpenShift in an airgap environment. An airgap deployment is essential for scenarios where direct internet access is not available, ensuring that all necessary components are available locally.

## Project Structure

- **[assets/](assets/)**: Project assets.
  - [README.md](assets/README.md)
- **[configs/](configs/)**: Configuration files.
  - [README.md](configs/README.md)
- **[docs/](docs/)**: Main documentation directory.
  - **[1 reparation/](docs/1-preparation/)**: Preparation phase documentation.
  - **[2-mirror-setup/](docs/2-mirror-setup/)**: Mirror registry and image mirroring setup.
  - **[3-cluster-deployment/](docs/3-cluster-deployment/)**: Cluster deployment process.
  - **[4-post-installation/](docs/4-post-installation/)**: Post-installation steps.
  - **[5-maintenance/](docs/5-maintenance/)**: Maintenance tasks.
  - **[99-references/](docs/99-references/)**: Reference materials.
    - [netapp/](docs/99-references/netapp/)
    - [redhat/](docs/99-references/redhat/)
      - [OpenShift_Container_Platform-4.18-Disconnected_environments-en-US.pdf](docs/99-references/redhat/OpenShift_Container_Platform-4.18-Disconnected_environments-en-US.pdf)
    - [veritas/](docs/99-references/veritas/)
  - [README.md](docs/README.md)
- **[manifests/](manifests/)**: Kubernetes/OpenShift manifests.
  - [README.md](manifests/README.md)
- **[scripts/](scripts/)**: Automation and helper scripts.
  - [README.md](scripts/README.md)

## Getting Started

To get started with the OpenShift airgap deployment, follow the instructions in the [docs/1-preparation/](docs/1-preparation/) directory to ensure you have all the necessary tools and configurations in place. Each subsequent directory will guide you through mirror setup, cluster deployment, and post-installation processes.

For any issues encountered during the deployment, refer to the relevant documentation or the [docs/99-references/](docs/99-references/) directory for guidance and reference materials.