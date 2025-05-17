# DNF Provided Tools

When using RHEL 9 (or compatible distributions), many of the prerequisite applications for an OpenShift airgap deployment can be installed easily using `dnf`. This simplifies the setup process and ensures you have the latest supported versions from your distribution's repositories.

Below is a command you can use to install the most common required tools:

```shell
sudo dnf install -y \
    podman \
    skopeo \
    jq \
    yq \
    curl \
    wget \
    git \
    openssl \
    tar \ 
    gzip
    tmux \
    vim \
    rsync \
    net-tools \
    binutils
```

> **Tip:**  
> Run this command on each host that requires these utilities.  
> Additional packages may be needed depending on your environment or specific deployment requirements.