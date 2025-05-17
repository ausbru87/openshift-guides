# Common FOSS Tools for Kubernetes Operations

In addition to distribution-provided packages, several open source tools are widely used for Kubernetes and OpenShift operations. These tools can help with cluster management, troubleshooting, manifest templating, and automation.

Below are some commonly used FOSS (Free and Open Source Software) tools:

- **kubectl**  
  The Kubernetes command-line tool for interacting with clusters.  
  [Install instructions](https://kubernetes.io/docs/tasks/tools/)

- **kustomize**  
  A tool for customizing Kubernetes YAML configurations.  
  [Install instructions](https://kubectl.docs.kubernetes.io/installation/kustomize/)

- **helm**  
  The package manager for Kubernetes, used to manage charts and deploy applications.  
  [Install instructions](https://helm.sh/docs/intro/install/)

- **stern**  
  Multi-pod and container log tailing for Kubernetes.  
  [Install instructions](https://github.com/stern/stern)

- **k9s**  
  Terminal UI to interact with your Kubernetes clusters.  
  [Install instructions](https://k9scli.io/topics/install/)

- **kubectx & kubens**  
  Tools for switching between clusters and namespaces.  
  [Install instructions](https://github.com/ahmetb/kubectx)

> **Tip:**  
> Download and install these tools on your management or utility hosts as needed for your workflow.