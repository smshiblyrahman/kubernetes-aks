# Kubernetes AKS Orchestration & Workload Architecture

Enterprise Kubernetes orchestration stack for Azure Kubernetes Service (AKS).

## Repository Overview
- `charts/`: Production Helm charts for 5 microservices (`gateway`, `user-service`, `product-service`, `order-service`, `payment-service`) with HPA, PDB, 3 probes, multi-zone topology spread, and non-root security contexts.
- `environments/`: Namespace isolation manifests (`dev`, `staging`, `prod`, `monitoring`) and `ResourceQuota` / `LimitRange` definitions.
- `policies/`: Zero-trust default-deny `NetworkPolicy` objects and RBAC roles.
- `storage/`: PersistentVolumeClaim manifests for Azure Disk (`managed-csi-premium`).
- `security/`: Azure Key Vault CSI driver `SecretProviderClass` manifests.
- `ingress/`: NGINX Ingress rules with TLS configuration.
- `monitoring/`: Prometheus alerting rules and observability configs.
- `scripts/`: Automated deployment and validation scripts.
