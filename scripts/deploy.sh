#!/usr/bin/env bash
set -euo pipefail

ENV="${1:-prod}"
echo "Deploying Kubernetes AKS Orchestration stack for environment: ${ENV}..."

# 1. Namespaces
echo "Applying namespaces..."
kubectl apply -f environments/base/namespaces.yaml

# 2. Resource Quotas & Limits
echo "Applying governance policies..."
kubectl apply -f environments/prod/resource-governance.yaml -n "${ENV}"

# 3. Network Policies
echo "Applying zero-trust network policies..."
kubectl apply -f policies/network-policies/prod-network-policies.yaml -n "${ENV}"

# 4. RBAC
echo "Applying RBAC policies..."
kubectl apply -f policies/rbac/app-operator-rbac.yaml -n "${ENV}"

# 5. Storage & Secrets
echo "Applying storage & keyvault provider manifests..."
kubectl apply -f storage/azure-disk-pvc.yaml -n "${ENV}" || true
kubectl apply -f security/keyvault-secret-provider.yaml -n "${ENV}" || true

# 6. Ingress
echo "Applying Ingress and TLS routing..."
kubectl apply -f ingress/ingress-routes.yaml -n "${ENV}"

echo "Deployment complete for ${ENV}."
