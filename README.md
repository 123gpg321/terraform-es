# Description #
Streamline and automate the process of creating automated infrastructure from scratch. 

# Requirements #
 
* Ubuntu Linux Knowledge
* AWS, LoadBalancer, EC2 Instances, Security groups and SSH auth key certs
* Terraform provisioning tool
* ElasticSearch Configuration
* Oracle VirtualBox (optional)
* Chef (Optional)

## Step-By-Step Guide ##
Step 1

Install Terraform (https://www.terraform.io) and write configuration file `es-cluster-config.tf`.  

`terraform plan`
preview
`terraform apply`
action
`terraform destroy` 
destroy created AWS infrastructure and start from scratch

Step 2

Install and Configure ElasticSearch. 

`wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.1.noarch.rpm`

`sudo rpm -i elasticsearch-1.7.1.noarch.rpm`

`cd /usr/share/elasticsearch/`

`sudo bin/plugin install elasticsearch/elasticsearch-cloud-aws/2.7.0`

`sudo vim /etc/elasticsearch/elasticsearch.yml`

    cloud.aws.access_key: AKIAJ46Q---------
    cloud.aws.secret_key: BaFWAjBpb8+J61-------------------------
    cluster.name: georgis-cluster
    node.name: "georgis-ec2es-node-1"
    discovery.type: ec2
    discovery.ec2.host_type: public_ip
    discovery.ec2.groups: georgi-es-group
    discovery.ec2.ping_timeout: 5m
    cloud.aws.region: us-east-1
    path.conf: /etc/elasticsearch
    path.data: /var/lib/elasticsearch
    path.work: /tmp/elasticsearch
    path.logs: /var/log/elasticsearch
    
The security group option is important otherwise the plugin will cause Elasticsearch to try and discover all hosts within that region and fail if they do not have elasticsearch. Limiting the search to only instances with the specified security group will fix that! 


## Live Demo  ##

ElasticSearch Cluster Node 1
`curl -XGET http://ec2-52-3-153-248.compute-1.amazonaws.com:9200`

ElasticSearch Cluster Node 2
`curl -XGET http://ec2-52-6-31-9.compute-1.amazonaws.com:9200`

ElasticSearch Cluster Node 3
`curl -XGET http://ec2-52-20-144-30.compute-1.amazonaws.com:9200`



