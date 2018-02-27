

# CRUD (Create-Read-Update-Delete) operations using Java (JAX-RS) and MongoDB
This project it's a way to create simple examples of a Java application using 
JAX-RS in order to expose API's to create some content into MongoDB.

Ideally, this application should be used with Docker containers. However, if you
don't want to use containers, you may use locally as a simple application deployed
on top of WildFly (or JBoss).

Bellow, are some of the calls you can use in order to add names (more specifically
using first and last name).

This application can be run on [Red Hat OpenShift Container Platform](https://www.openshift.com).
Let's assume that your project has the following characteristics:

```
$ oc status
In project hellomongo on server https://openshift.nortlam.net:8443

http://hellomongo.cloudapps.nortlam.net to pod port 8080 (svc/hellomongo-app)
  dc/hellomongo-app deploys istag/hellomongo-app:latest <-
    bc/hellomongo-app source builds uploaded code on istag/wildfly-alpine:latest 
      not built yet
    deployment #2 deployed about an hour ago - 1 pod
    deployment #1 deployed 12 hours ago

svc/hellomongo-data - 172.30.75.21:27017
  dc/hellomongo-data deploys openshift/mongodb:latest 
    deployment #1 deployed 13 hours ago - 1 pod

View details with 'oc describe <resource>/<name>' or list everything with 'oc get all'.
```

So our project named is **hellomongo**. By getting the information of the pods, we shall have like so
```
$ oc get pods
NAME                      READY     STATUS    RESTARTS   AGE
hellomongo-app-2-2gn2s    1/1       Running   0          1h
hellomongo-data-1-j9r5q   1/1       Running   0          12h
```

In order to fetch the route used by this application, you can run the following command:
```
$ oc get routes --output jsonpath='{.items[?(.metadata.name=="hellomongo-app")].spec.host}'
hellomongo.cloudapps.nortlam.net
```
This will get a list of routes, select whoever has the **.metadata.name=="hellomongo-app"** and return the value of **.spec.host**
There are a few scripts which uses this technique to get the route information and submit content directly to the service using [curl command](http://www.mit.edu/afs.new/sipb/user/ssen/src/curl-7.11.1/docs/curl.html)

# PING
There is a simple endpoint, which helps to know if the application is up and running
```
$ curl -i -v -X GET http://<ROUTE>/api/ping
```
or running the following script, which gives your the same information
```
$ curl/ping.sh hellomongo-app
```

[Ansible version](https://www.ansible.com/)
```
$ ansible localhost -m uri -a 'method=GET url=http://<ROUTE>/api/ping status_code=200'
```
| HTTP Code Response | Description |
| -----------------| ------------|
| 200 - OK | The application is successfully running |

With that, you can set a [Readiness probe](https://docs.openshift.com/container-platform/3.7/dev_guide/application_health.html#container-health-checks-using-probes) into the Pod to make sure the application is alive and well
```
$ oc set probe dc/hellomongo-app --readiness --initial-delay-seconds=20 --period-seconds=15 --get-url=http://:8080/api/ping
```

## CREATE
In order to create a single person, you will be submitting like this:

```
curl -i -v -X POST -H "Content-type: application/json" http://<ROUTE>/api/v1/person -d '{"firstName":"Mauricio","lastName":"Leal"}'
```

Using a simple script to fetch all data using OpenShift's Client
```
curl/post.sh hellomongo-app '{"firstName":"Mauricio","lastName":"Leal"}'
```

[Ansible version](https://www.ansible.com/)
```
ansible localhost -m uri -a 'method=POST headers="Content-type=application/json" status_code=201 return_content=true url="http://<ROUTE>/api/v1/person" body="{\"firstName\":\"John\",\"lastName\":\"Doe\"}"'
```

| HTTP Code Response    | Description |
| -----------------| ------------|
| 201 - Created | The content was successfully created and returned a new _id for this person like: 5a9569080c07d8004bc177b7 |
| 503 - Service Unavailable | Unable to reach all the necessary services. A couple reasons could be: Something wrong with the database |

## READ 
If you just type submit straight to the service "/api/v1/person", you will get a list of all People from the database
```
curl -i -v -X GET http://<ROUTE>/api/v1/person
```
[Ansible Version](https://www.ansible.com/)
```
ansible localhost -m uri -a 'method=GET url=http://hellomongo.cloudapps.nortlam.net/api/v1/person'
```
Using a simple script to fetch all data using OpenShift's Client
```
curl/get_all.sh hellomongo-app
```

| HTTP Code Response | Description |
| -----------------| ------------|
| 200 - Ok         | Return a array of all people included in the database |
| 204 - No Content | There isn't any people in the database | 


You can always fetch for a particular person, given his _id as such
```
curl -i -v -X GET -H "Accept: application/json" http://hellomongo.cloudapps.nortlam.net/api/v1/person/5a95245670cd4f004b8aad3e
```
or running the following script, which gives your the same information
```
$ curl/get.sh hellomongo-app 5a95245670cd4f004b8aad3e
```
[Ansible Version](https://www.ansible.com/)
```
$ ansible localhost -m uri -a 'method=GET headers="Accept=application/json" url=http://hellomongo.cloudapps.nortlam.net/api/v1/person/5a95245670cd4f004b8aad3e status_code=200'
```


| HTTP Code Response | Description                                    |
| -----------------| -----------------------------------------------|
| 200 - Ok         | Found a specific _id and returned the contents |
| 404 - Not Found  | Unable to find a specific _id                  | 

## UPDATE

using curl
```
curl -i -v -X PUT -H "Content-type: application/json" http://<ROUTE>/api/v1/person/59d9ae6ed30f7d11dde34c59 -d '{"firstName":"Andre","lastName":"Silva"}'
```
or using the following script, helps to submit the content directly
```
$ curl/put.sh hellomongo-app 5a95245670cd4f004b8aad3e '{"firstName":"Mauricio", "lastName":"Leal"}'
```

[Ansible Version](https://www.ansible.com/)
```
ansible localhost -m uri -a 'method=PUT headers="Content-type=application/json" url=http://localhost:8080/api/v1/person/5a95245670cd4f004b8aad3e status_code=202 body="{\"firstName\":\"Mauricio\", \"lastName\":\"Leal\"}"'
```

| HTTP Code Response | Description                           |
| ------------------| -----------------------------------------------|
| 202 - Accepted    | Found a specific _id and updated its contents     |
| 400 - Bad Request | There was some missing information in the request | 
| 401 - Gone        | Nothing to update                                 | 
| 404 - Not Found   | Unable to find a specific _id                  | 


## DELETE
Delete a Person by indicating your _id (for example, using _id 59dccb04e2016e1f64685181)

```
$ curl -i -v -X DELETE http://<ROUTE>/api/v1/person/59dccb04e2016e1f64685181
```
or using the following script, helps to submit the content directly
```
$ curl/delete.sh hellomongo-app 59dccb04e2016e1f64685181
```

[Ansible Version](https://www.ansible.com/)
```
$ ansible localhost -m uri -a 'method="DELETE" headers="Content-type=application/json" url="http://<ROUTE>/api/v1/person/59dcd368e2016e1f64924705" status_code=202'
```

| HTTP Code Response | Description |
| ------------- | ------------- |
| 202 - Accepted  | Found the content and it was successfully deleted |
| 401 - Gone      | There is nothing to delete |
| 404 - Not Found | Unable to find this particular _id |
| 503 - Service Unavailable | Unable to perform a operation  |
