#!/bin/bash

rm -rf certs/elastic*
rm -rf certs/*.zip

kubectl delete ss es-cluster || true
kubectl delete service elasticsearch || true
kubectl delete secrets elastic-certificate-crt -n kube-logging || true
kubectl delete secrets elastic-certificate-pem -n kube-logging || true
kubectl delete secrets elastic-certificates -n kube-logging || true
kubectl delete secrets elastic-credentials -n kube-logging || true
kubectl delete pvc data-es-cluster-0 -n kube-logging || true
kubectl delete pv example-local-pv || true
kubectl delete cm elasticsearch-master-config -n kube-logging|| true
