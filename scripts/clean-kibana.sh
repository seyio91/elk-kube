#!/bin/bash

kubectl delete service kibana -n kube-logging || true
kubectl delete secrets kibana -n kube-logging || true
kubectl delete cm kibana-config -n kube-logging || true
kubectl delete deploy kibana -n kube-logging || true

