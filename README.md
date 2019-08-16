# Data Lineage Orchestration

*Capstone project for Udacity's Cloud DevOps Nanodegree*

We are going to build a scalable, high-available and fault-tolerant **Data Lineage** tool for **Spark** with [Spline](https://absaoss.github.io/spline/) and Kubernetes. To do so, we are going to orchestrate not only the Spline UI tool, but also the underlying MongoDB with Kubernetes.

The purpose of the project is reaching full automation using CI/CD pipelines to ensure fast, continuous and safe delivery of a full containerized tool that lets the user keep track through a web UI of the Data Lineage of Spark jobs. We will use AWS services to create a **Cloud Native** application to that end.

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

</details>


<details>
<summary><b>Resources</b></summary>

* [Nirmata series on Kubernetes](https://www.nirmata.com/2018/03/03/kubernetes-for-developers-part-2-replica-sets-and-deployments/)

</details>
