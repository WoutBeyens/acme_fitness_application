#!/usr/bin/env bash
#
# Deployment of the acme fitness application 
#
# Author: Wout Beyens

set -o errexit # abort on nonzero exitstatus
set -o nounset # abort on unbound variable

#
# Usage
#

usage() {
cat << _EOF_
Usage: ${0} 
- Clone eerst het project met 'git clone https://github.com/WoutBeyens/acme_fitness_application.git'
- Check daarna of alle Pods in ready-status staan met: 'kubectl -n ${ACME_NAMESPACE} get pods'
- Check of de website bereikbaar is door naar het extern IP-address te surfen. Het extern IP-adres kan gevonden worden met volgend commando: 'kubectl -n ${ACME_NAMESPACE} get svc/frontend'
_EOF_
}

#
# Variables
#

ACME_SECRET=VMware1!
ACME_NAMESPACE=acme-fitness

#
# Script proper
#

kubectl create ns ${ACME_NAMESPACE}
kubectl -n ${ACME_NAMESPACE} create secret generic cart-redis-pass --from-literal=password=${ACME_SECRET}
kubectl -n ${ACME_NAMESPACE} apply -f cart-redis-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f cart-total.yaml
kubectl -n ${ACME_NAMESPACE} create secret generic catalog-mongo-pass --from-literal=password=${ACME_SECRET}
kubectl -n ${ACME_NAMESPACE} create -f catalog-db-initdb-configmap.yaml
kubectl -n ${ACME_NAMESPACE} apply -f catalog-db-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f catalog-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f payment-total.yaml
kubectl -n ${ACME_NAMESPACE} create secret generic order-postgres-pass --from-literal=password=${ACME_SECRET}
kubectl -n ${ACME_NAMESPACE} apply -f order-db-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f order-total.yaml
kubectl -n ${ACME_NAMESPACE} create secret generic users-mongo-pass --from-literal=password=${ACME_SECRET}
kubectl -n ${ACME_NAMESPACE} create secret generic users-redis-pass --from-literal=password=${ACME_SECRET}
kubectl -n ${ACME_NAMESPACE} create -f users-db-initdb-configmap.yaml
kubectl -n ${ACME_NAMESPACE} apply -f users-db-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f users-redis-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f users-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f frontend-total.yaml
kubectl -n ${ACME_NAMESPACE} apply -f point-of-sales-total.yaml