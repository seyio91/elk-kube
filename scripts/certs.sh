#!/bin/bash
set -e

ELASTICSEARCH_IMAGE=docker.elastic.co/elasticsearch/elasticsearch:7.5.2



docker rm -f elastic-helm-charts-certs || true
rm -f elastic-certificates.p12 elastic-certificate.pem elastic-certificate.crt elastic-stack-ca.p12 || true
password=$([ ! -z "$ELASTIC_PASSWORD" ] && echo $ELASTIC_PASSWORD || echo $(docker run --rm busybox:1.31.1 /bin/sh -c "< /dev/urandom tr -cd '[:alnum:]' | head -c20")) && \
echo "Generating Elasticsearch Certificates" && \
docker run --name elastic-helm-charts-certs -i -w /tmp \
	docker.elastic.co/elasticsearch/elasticsearch:7.5.2 \
	/bin/sh -c " \
		elasticsearch-certutil ca --out /tmp/elastic-stack-ca.p12 --pass '' && \
        echo 'Generated elastic-stack-ca.p12 ...' && \
		elasticsearch-certutil cert --name elasticsearch --dns elasticsearch --ca /tmp/elastic-stack-ca.p12 --pass '' --ca-pass '' --out /tmp/elastic-certificates.p12 && \
        echo 'elastic-certificates.p12 ...' && \
        elasticsearch-certutil cert --pem --ca /tmp/elastic-stack-ca.p12 --ca-pass ''  --dns kibana --out /tmp/kibana-certs.zip" && \
echo 'Creating Kibana Certs ...' && \
mkdir certs || true && \
docker cp elastic-helm-charts-certs:/tmp/elastic-certificates.p12 ./certs/ && \
docker cp elastic-helm-charts-certs:/tmp/elastic-stack-ca.p12 ./certs && \
docker cp elastic-helm-charts-certs:/tmp/kibana-certs.zip ./certs && \
echo 'Cleaning Cert Gen Container ...' && \
docker rm -f elastic-helm-charts-certs && \
echo 'Signing Cert Key ..' && \
openssl pkcs12 -nodes -passin pass:'' -in certs/elastic-certificates.p12 -out certs/elastic-certificate.pem && \
echo 'Creating Elastic Search Certificate ...' && \
openssl x509 -outform der -in certs/elastic-certificate.pem -out certs/elastic-certificate.crt && \
echo 'Your Elasticsearch Password = '$password''
kubectl create secret generic elastic-certificates --from-file=certs/elastic-certificates.p12 -n kube-logging && \
kubectl create secret generic elastic-certificate-pem --from-file=certs/elastic-certificate.pem -n kube-logging && \
kubectl create secret generic elastic-certificate-crt --from-file=certs/elastic-certificate.crt -n kube-logging && \
kubectl create secret generic elastic-credentials  --from-literal=password=$password --from-literal=username=elastic -n kube-logging && \
rm -rf ./certs