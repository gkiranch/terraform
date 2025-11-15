# MongoDB manifests with Kustomize

This folder contains a base set of MongoDB Kubernetes manifests plus environment-specific Kustomize overlays (dev, prod).

## Structure
- base
  - Reuses the headless Service and StatefulSet manifests in this repo
- overlays
  - dev: namespace `mongo`, replicas=2, PVC size 10Gi
  - prod: namespace `mongo`, replicas=3, PVC size 50Gi

## Why StatefulSet with per‑pod PVCs
MongoDB pods should not share a single EBS volume. The base StatefulSet uses `volumeClaimTemplates` so each pod gets its own `ReadWriteOnce` EBS volume via the `gp3` StorageClass.

## Prerequisites
- EKS cluster with the AWS EBS CSI driver addon Active
- A `gp3` StorageClass using provisioner `ebs.csi.aws.com` (set as default or referenced explicitly)

## Apply (dev)
```bash
kubectl apply -k mongodb/kustomize/overlays/dev
```

## Apply (prod)
```bash
kubectl apply -k mongodb/kustomize/overlays/prod
```

## Preview
```bash
kubectl kustomize mongodb/kustomize/overlays/dev
```

## Notes
- The headless Service (`clusterIP: None`) provides stable DNS identities for the StatefulSet pods.
- If you previously used a single PVC (e.g., `mongodb-pvc`) for multiple pods, switch to the StatefulSet here; each replica will get its own PVC like `data-mongo-db-0`, `data-mongo-db-1`.
- Customize overlays to change image tags, resources, node selectors, tolerations, etc.
