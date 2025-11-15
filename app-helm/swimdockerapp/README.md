Pre-reqs
Create a namespace
Create secret with default credentials root/root

1. Make sure the Secret exists in the namespace where App helm chart going to be deployed, if not created it
   kubectl -n mongo create secret generic mongo-db-credentials \
   --from-literal=username=root \
   --from-literal=password=root
2. Upgrade the helm chart
   helm upgrade --install swimdockerapp ./app-helm/swimdockerapp \
   -n <app-namespace>