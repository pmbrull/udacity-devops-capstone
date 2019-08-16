# MongoDB Deployment Demo for Kubernetes on Minikube (i.e. running on local workstation)

> For the full information, refer the original [repo](https://github.com/pkdone/minikube-mongodb-demo).


Start minikube

```bash
$ minikube start
$ kubectl get nodes
$ kubectl describe nodes
$ kubectl get services
```

Main deployment steps:

```bash
$ cd scripts
$ ./generate.sh
```

Once everything is in running state in `kubectl get all`, execute the next script:

```bash
$ ./configure_repset_auth.sh <pwd>
```

Now, lets test that the replication is working correctly, where we have mongod-0 as the PRIMARY node and mongod-1 / 2 as SECONDARY:

```bash
$ kubectl exec -it mongod-0 -c mongod-container bash
$ mongo
> db.getSiblingDB('admin').auth("main_admin", "<pwd>");
> use test;
> db.testcoll.insert({a:1});
> db.testcoll.insert({b:2});
> db.testcoll.find();
```

After creating some data on the primary node, we should be able to access that from the rest of nodes:

```bash
$ kubectl exec -it mongod-1 -c mongod-container bash
$ mongo
> rs.slaveOk();
> db.getSiblingDB('admin').auth("main_admin", "<pwd>");
> use test;
> db.testcoll.find();
```

Once everything is configured correctly, we will create a database for the Data Lineage `lineage` by running `use lineage;` in the mongo shell.

`kubectl port-forward svc/mongodb-service 27017:27017`