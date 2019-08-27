# Cloud Native Orchestration

*Capstone project for Udacity's Cloud DevOps Nanodegree*

We will prepare a small API that behaves as a database client. While our DB is completely secure inside the cluster, we can POST queries to the API that will be executed agains the database and give back the results.

---

## Technology Background

<details>
<summary><b>Kubernetes</b></summary>

### Pods

The smallest unit available in Kubernetes is the **Pod**, the basic building block:

> Pods are the smallest deployable units of computing that can be created and managed in Kubernetes.

In other words, Pods are units that encapsulate the elements of the application that must work together. Therefore, when scaling the application - increasing / decreasing the number of Pods - , all the elements inside the Pod will equally scale. Moreover, containers inside the same Pod can easily communicate between them, being isolated from anything else that could be placed outside of their *world*.

However, by definition Pods are not meant to be reliable units. Yes, they have their own IP addresses and we could directly communicate to any of them, but this is discouraged in a production environment as they are ephemeral. Depending on the application load, new Pods may appear or others may crash, so we instead want to communicate to our application in a greater level of abstraction. In order to achieve this, Kubernetes brings us two resources: Workload API Objects and Services.

### Replica Sets

This is an API Object that helps to manage the scaling of Pods.

> Replica Sets ensure that a specified number of pod replicas are running at any given time.

Based on a given **template** and *specs* - such as `specs.replicas = 3`, Replica Sets create Pods to manage. However, a Replica Set may also manage Pods that were not created by it, by specifying a **Selector**, that will be used to match any pod with that given label.

However, this API lacks the ability to perform updates. That's why we need **Deployments**.

### Deployment

Deployment encapsulate both Replica Sets and Pods, providing a declarative method of update their state: `kubectl`. This adds another layer of abstraction to managing Kubernetes:

`User [interface] -> Deployment -> Replica Set -> Pod`

Through the `kubectl` interface, the Deployment will check the current status of the cluster and make it match the desired state specified by the user.

### Stateful Set

Finally, we will introduce another Kubernetes framewoek called **Stateful Set**, used to manage *stateful applications* such as databases. In this [link](http://pauldone.blogspot.com/2017/06/deploying-mongodb-on-kubernetes-gke25.html) I found the best definition of them:

> StatefulSets provides the capabilities of stable unique network hostnames and stable dedicated network storage volume mappings, essential for a database cluster to function properly and for data to exist and outlive the lifetime of inherently ephemeral containers.

### Persistent Volumes

As explained in the [docs](https://kubernetes.io/docs/concepts/storage/persistent-volumes/), `PersistentVolume`s are pieces of storage that will be requested through `PersistentVolumeClaim`s.

</details>

For any quick modifications to `app.py`, we can test locally by running a postgres Docker container:
1. Run docker Postgres: `docker run -p 5432:5432 --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres`
1. Test to run a query with `sh post_query.sh "<my_query>"`

* Configuration file for the application and scripts, can be found in `scripts/config.sh`.
* Scripts are prepared to be run from the main repo directory.

> Note that disabled `ignore-modules=flask_sqlalchemy` on `pylintrc` to disable `E1101` errors due to methods only being available at runtime. Those can't be picked up by pylint and thus it throws ghost errors.

To test the application in Kubernetes:

* `sh scripts/deploy.sh`
* `sh scripts/post_query.sh 192.168.99.100 31234 "create table account (id_user serial PRIMARY KEY, username VARCHAR(50) NOT NULL)"` should return `OK`.
* `sh scripts/post_query.sh 192.168.99.100 31234 "insert into account (username) values ('pmbrull')"` should return `OK`.
* `sh scripts/post_query.sh 192.168.99.100 31234 "select * from account"` should return
```
{
  "result": [
    {
      "id_user": 1, 
      "username": "pmbrull"
    }
  ]
}
```

We enabled a rolling update on the flask app deployment.

## AWS

To work with Kubernetes on AWS, we need the following:

In the Jenkins EC2 instance we need to install:
* [awscli] and configure with the `kops` user.
```
export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
```
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [kops](https://github.com/kubernetes/kops/blob/master/docs/install.md)
  These tools will be used to create the cluster and deploy our app.

* Register a domain in **Route 53**. For that, I registered `pmbrull-k8.com` so that I can reach my cluster by name.
* Create an S3 bucket to store the cluster state & enable versioning.
* Export cluster variables 
```
export NAME=pmbrull-k8.com
export KOPS_STATE_STORE=s3://pmbrull-k8-com-state-store
```
* Create ssh key for the server if we don't have one: `ssh-keygen`.
* SSH public key must be specified when running with AWS (create with `kops create secret --name pmbrull-k8.com sshpublickey admin -i ~/.ssh/id_rsa.pub`)
* Then, create the kubernetes cluster with `kops`:
```
kops create cluster \
    --zones us-west-2a \
    ${NAME}
```
* Now we can review the cluster configuration.
* Finally, build the cluster: `kops update cluster ${NAME} --yes`
* It will need a few minutes to validate the DNS from the created Route53 domain. Then, we can validate the cluster: `kops validate cluster`.
* Handshake Jenkins server with the cluster:
```
sudo mkdir -p /var/lib/jenkins/.kube
sudo cp ~/.kube/config /var/lib/jenkins/.kube/
cd /var/lib/jenkins/.kube/
sudo chown jenkins:jenkins config
sudo chmod 750 config
```

* In Jenkins, store the Docker Hub password as `Secret text` to upload the image.

TODO: Create Jenkinsfile:
fer tot això al Makefile
        lint app & Dockerfile
        build docker
        
        configurar credencials
        stage('login to dockerhub') {
            withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerhubpwd')]) {
            sh 'docker login -u pmbrull -p ${dockerhubpwd}'
            }
        }

        upload to Hub
        deploy to k8s
TODO: Create cluster
TODO: handshake between Jenkins and the cloud infrastructure


* Finally, delete the cluster `kops delete cluster --name=${NAME} --state=${KOPS_STATE_STORE} --yes`

> Fix docker agent in Jenkinsfile permission error: `sudo chown root:jenkins /run/docker.sock`

---

## Resources

* [Nirmata series on Kubernetes](https://www.nirmata.com/2018/03/03/kubernetes-for-developers-part-2-replica-sets-and-deployments/)
* [Testdriven: Flask + Vue + Kubernetes](https://github.com/testdrivenio/flask-vue-kubernetes)
* [Flask Postgres Kubernetes Workshop](https://github.com/lihan/flask-postgres-kubernetes-workshop)
* [Kops](https://github.com/kubernetes/kops/blob/master/docs/aws.md)
* [How to Create a Kubernetes Cluster on AWS in Few Minutes](https://medium.com/containermind/how-to-create-a-kubernetes-cluster-on-aws-in-few-minutes-89dda10354f4)
* [CI/CD with Jenkins, Docker and Kubernetes on AWS](https://medium.com/@Thegaijin/ci-cd-with-jenkins-docker-and-kubernetes-26932c3a1ea)

