# Cluster Administration Configuration

## Update Node Roles/Labels

Properly labeling and configuring node roles is essential for efficient cluster operation. By assigning the `worker` role to all nodes, we enable them to run application workloads. Additionally, removing restrictive taints ensures that workloads can be scheduled on any node, maximizing resource utilization and cluster flexibility.

```bash
# Label all nodes with the worker role
oc label node --all node-role.kubernetes.io/worker=worker
# Remove any taints that would prevent scheduling of workloads
oc adm taint nodes --all node-role.kubernetes.io/master-
```