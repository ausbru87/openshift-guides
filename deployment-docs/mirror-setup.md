# OpenShift Air-Gapped OC Mirror Setup

## Infrastructure Prereqs


## Virtual Machines to Build
| hostname | network | vCPU | MEM | DISK | Ingress FW Ports | PKGS | Purpse/Notes |
| -------- | ------- | ------| ----| ---- | ------ | ----- | -----------|
| oc-downloader | connected to internet | 4-8c | 8-16GB | 1.5-2.0TB | NA | podman, oc-mirror, vim, tmux | This host is the one that will pull all of the images down from the internet and then we will tar them up to migrate to the airgapped network |
| oc-tools | air-gap | 4c | 8GB | 100GB | NA | oc, oc-mirror, openshift-install, kubectl, helm, curl, tmux | This will be the host that we use to install openshift on the nodes and unpack and import the images to the disconnected registry |
| oc-mirror | air-gap | 8c | 16GB | 1.5-2.0TB | TCP/500, TCP/443 | mirror-registry, podman |This host will act as our temporary air-gapped container image registry that will be used to bootstrap the cluster install |

