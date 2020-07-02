### Vagrant Kube-Adm Kubernetes Deployment

Single Node Secured Elasticsearch, Kibana, Fluentd Template  

**Install ElasticSearch**
1. Create Namespace  

        kubectl create namespace kube-logging

        or

        kubectl create -f elasticsearch/namespace.yml

2. Generate and Secrets

        bash scripts/certs.sh  
        # copy generated password displayed on running script for accessing kibana and elasticsearch cluster

3. Create pvolume(local kubeadm install specific)

        kubectl create -f elasticsearch/pvolume.yml

4. Create Configmap

        kubectl create -f elasticsearch/efk-configmap

5. Create Service and Deployment

        kubectl create -f elasticsearch/elasticsearch.yml

  
# 

**Install Kibana**
1. Generate and Secrets

        bash scripts/kib-secrets.sh

2. Create Configmap

        kubectl create -f kibana/kib-configmap.yml

3. Create Service and Deployment

        kubectl create -f elasticsearch/kibana-deployment.yml

# 
**Install Fluented**  
1. Create Fluentd daemonset for nodes in cluster
        
        kubectl create -f fluentd/fluentd.yml

**Cleaning Up**
1. Delete Elasticsearch Resources

        bash script/clean-elk.sh

2. Delete Kibana Resources

        bash scripts/clean-kibana.sh

3. Delete Fluentd

        kubectl delete -f fluentd/fluentd.yml