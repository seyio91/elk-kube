#!/bin/bash

encryptionkey=$(docker run --rm busybox:1.31.1 /bin/sh -c "< /dev/urandom tr -dc _A-Za-z0-9 | head -c50") && \
kubectl create secret generic kibana --from-literal=encryptionkey=$encryptionkey -n kube-logging && \
echo "password for kibana is $encryptionkey"
# buxEWEWv79_pXe6jplhMr4eG1_3PsLXkbg2AS0yS4zszKlCjYb