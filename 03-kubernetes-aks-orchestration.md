# Project 3 — Kubernetes Cluster Setup and Application Orchestration

## SELISE-Oriented Technical Implementation Plan

## 1. Project Purpose

This project demonstrates operational ownership of Kubernetes workloads on Azure rather than merely deploying a sample container.

The supplied design includes AKS, system/user node pools, Azure CNI, identity integration, Helm, ConfigMaps, Secrets, PVC/Azure Disks, NGINX Ingress/TLS, HPA, Prometheus, Grafana, Azure Monitor, Fluentd, resource governance, Network Policies, multi-zone deployment, anti-affinity, probes, and backups. fileciteturn0file0L139-L171

This aligns with SELISE's public technology profile, which lists Docker, Kubernetes, Terraform, Ansible and Jenkins among its DevOps expertise. citeturn0search6

The current SELISE SysOps role also identifies Kubernetes and monitoring tools as useful infrastructure capabilities, alongside broader infrastructure operations and troubleshooting. citeturn0search0

## 2. Operational Goal

The cluster should answer:

- How are workloads deployed?
- How are they scaled?
- How are they secured?
- How are they monitored?
- How are failures detected?
- How are resources controlled?
- How is a failed workload recovered?
- How is production access governed?

## 3. Architecture

```text
                         Internet
                            |
                     Azure Load Balancer
                            |
                       NGINX Ingress
                            |
        +-------------------+-------------------+
        |                   |                   |
      Service A           Service B           Service C
        |                   |                   |
  +-----+-------------------------------------------+
  |                   AKS                           |
  |                                                 |
  | System Node Pool                                |
  | User Node Pool                                  |
  |                                                 |
  | dev | staging | prod | monitoring               |
  +-------------------------------------------------+
       |              |               |
   Prometheus       Grafana        Azure Monitor
       |
    Metrics
```

## 4. Cluster Design

The supplied project uses a three-node cluster with system/user node pools.

For a real production design, size the cluster according to:

- Workload CPU/memory.
- Availability requirements.
- Pod count.
- Traffic.
- Failure-domain requirements.
- Scaling behavior.

Do not present a three-node configuration as universally production-ready.

## 5. Node Pool Responsibilities

### System Pool

Kubernetes/system workloads.

### User Pool

Application workloads.

Benefits:

- Resource isolation.
- Independent scaling.
- Cleaner operations.
- Better failure containment.

## 6. Namespace Model

```text
dev
staging
prod
monitoring
```

Each environment gets:

- ResourceQuota.
- LimitRange.
- NetworkPolicy.
- RBAC.

The supplied project explicitly uses namespace-based environment isolation and quotas. fileciteturn0file0L160-L164

## 7. Helm Architecture

```text
kubernetes-aks-deployment/
├── charts/
│   ├── user-service/
│   ├── product-service/
│   ├── order-service/
│   ├── payment-service/
│   └── gateway/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── policies/
├── monitoring/
├── scripts/
└── docs/
```

Helm should encapsulate deployment configuration without hiding important Kubernetes behavior.

## 8. Deployment Configuration

Each application should define:

- Deployment.
- Service.
- ConfigMap.
- Secret references.
- ServiceAccount.
- Resource requests/limits.
- Probes.
- HPA.
- Security context.
- Pod disruption configuration where appropriate.

## 9. Resource Management

Every production workload should have explicit requests and limits.

Example:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "512Mi"
```

Use real workload measurements to establish values.

## 10. Health Probes

### Readiness

Controls whether traffic reaches the pod.

### Liveness

Detects an unhealthy process.

### Startup

Useful for applications with slow initialization.

Operational rule:

> Do not use a liveness probe to restart an application simply because a dependency is temporarily unavailable.

## 11. Ingress and TLS

NGINX Ingress routes:

```text
api.example.com/users
api.example.com/products
api.example.com/orders
```

Implement:

- HTTPS.
- TLS certificate management.
- HTTP-to-HTTPS redirect.
- Controlled external exposure.

## 12. Network Policies

Use default-deny where appropriate.

Then explicitly allow required paths:

```text
Ingress
  -> Gateway

Gateway
  -> Backend services

Backend
  -> Database

Monitoring
  -> Metrics endpoints
```

This prevents unrestricted lateral movement.

## 13. Secrets and Key Vault

Do not treat Kubernetes Secrets as the entire enterprise secret-management solution.

Integrate Project 5:

```text
Azure Key Vault
       |
Key Vault CSI Driver
       |
AKS workload
```

The supplied project specifically identifies Key Vault CSI integration in Project 5. fileciteturn0file0L301-L305

## 14. Persistent Storage

For stateful workloads:

```text
Pod
 |
PVC
 |
StorageClass
 |
Azure Disk
```

Document:

- Capacity.
- Performance.
- Access mode.
- Backup.
- Restore.
- Failure handling.

## 15. Autoscaling

The source specifies HPA using CPU/memory metrics.

Example:

```text
minReplicas: 2
maxReplicas: 10
target utilization: 70%
```

Test:

- Normal load.
- Sudden spike.
- Sustained load.
- Scale-down.
- Pod startup latency.

## 16. High Availability

Use:

- Multiple replicas.
- Multi-zone placement where supported.
- Pod anti-affinity.
- Readiness probes.
- Pod disruption controls.
- Appropriate node-pool capacity.

The supplied project explicitly includes multi-zone deployment and anti-affinity. fileciteturn0file0L167-L170

## 17. Monitoring

### Prometheus

Collect application/Kubernetes metrics.

### Grafana

Provide operational dashboards.

### Azure Monitor

Provide Azure/AKS visibility.

### Logs

Use centralized log collection as specified by the original project.

## 18. Incident Troubleshooting

A useful Kubernetes troubleshooting sequence:

```text
Service unavailable
       |
Ingress status
       |
Service endpoints
       |
Pod status
       |
Readiness probe
       |
Pod logs
       |
Events
       |
Resource pressure
       |
NetworkPolicy
       |
Dependency health
```

Useful commands:

```bash
kubectl get pods -A
kubectl describe pod <pod>
kubectl logs <pod>
kubectl get events -A
kubectl get svc
kubectl get ingress
kubectl top pods
kubectl top nodes
```

## 19. Security

Implement:

- RBAC.
- Workload identity/managed identity.
- Network Policies.
- Restricted service accounts.
- Container security contexts.
- Image scanning.
- Secrets externalization.
- Namespace isolation.

## 20. Implementation Plan

### Phase 1

- AKS.
- Node pools.
- Networking.
- Identity.

### Phase 2

- Namespaces.
- RBAC.
- Quotas.
- Policies.

### Phase 3

- Helm.
- Services.
- Ingress.
- TLS.

### Phase 4

- Storage.
- HPA.
- Probes.
- HA.

### Phase 5

- Prometheus.
- Grafana.
- Azure Monitor.
- Logs.

### Phase 6

- Load tests.
- Failure tests.
- Recovery tests.
- Operational documentation.

## 21. SELISE Alignment

This project demonstrates:

```text
Kubernetes operations
Container orchestration
Azure cloud
Helm
Networking
Identity
Monitoring
Troubleshooting
Availability
Security
Automation
```

It also complements the broader SELISE technology environment, which publicly includes cloud platforms, PostgreSQL/data systems, Docker, Kubernetes, Terraform and Ansible. citeturn0search6

## 22. Acceptance Criteria

```text
[ ] Applications deploy through Helm
[ ] Environments are isolated
[ ] Resource requests/limits exist
[ ] Probes are configured
[ ] Ingress/TLS works
[ ] HPA responds to load
[ ] Network policies restrict traffic
[ ] Secrets are externally managed
[ ] Metrics are visible
[ ] Logs are searchable
[ ] Failure scenarios are tested
[ ] Recovery procedures are documented
```

## 23. Interview Questions

1. Difference between readiness and liveness?
2. How does HPA work?
3. How would you troubleshoot CrashLoopBackOff?
4. How would you troubleshoot a service with no endpoints?
5. How do Network Policies affect traffic?
6. How do you manage secrets in AKS?
7. Why use separate system and user node pools?
8. How would you perform a zero-downtime deployment?
9. How do you investigate resource pressure?
10. How would you recover a failed production workload?
