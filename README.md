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

Test the app:
* Run docker Postgres: `docker run -p 5432:5432 --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres`

---

## Resources

* [Nirmata series on Kubernetes](https://www.nirmata.com/2018/03/03/kubernetes-for-developers-part-2-replica-sets-and-deployments/)
* [Testdriven: Flask + Vue + Kubernetes](https://github.com/testdrivenio/flask-vue-kubernetes)
* [Flask Postgres Kubernetes Workshop](https://github.com/lihan/flask-postgres-kubernetes-workshop)

