# OpenShift Airgap Deployment Ansible Playbooks

This directory contains Ansible playbooks and roles to automate and streamline the OpenShift airgap deployment process. These playbooks help ensure consistency and efficiency across all deployment steps.

## Available Playbooks

- **`site.yml`**: Main entry point to run the full deployment workflow.
- **`prep-hosts.yml`**: Prepares all target hosts (installs required packages, configures networking, etc.).
- **`mirror-registry.yml`**: Automates the setup and configuration of the mirror registry.
- **`ocp-install.yml`**: Handles the OpenShift cluster installation process.
- **`post-install.yml`**: Performs post-installation tasks and validations.

## Usage

To use the playbooks, navigate to this directory and run the desired playbook with Ansible:

```bash
ansible-playbook -i inventory.ini <playbook-name>.yml
```

Ensure you have the necessary permissions, dependencies, and a properly configured inventory file.

## Contribution

If you wish to contribute, please follow the guidelines outlined in the main project README at the root of this repository.