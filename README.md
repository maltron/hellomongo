

# CRUD (Create-Read-Update-Delete) operations using Java (JAX-RS) and MongoDB
This project it's a way to create simple examples of a Java application using 
JAX-RS in order to expose API's to create some content into MongoDB.

Ideally, this application should be used with Docker containers. However, if you
don't want to use containers, you may use locally as a simple application deployed
on top of WildFly (or JBoss).

Bellow, are some of the calls you can use in order to add names (more specifically
using first and last name).

## CREATE
In order to create a single person, you will be submitting like this:

```
curl -i -v -X POST -H "Content-type: application/json" http://localhost:8080/helloworld/api/person -d '{"firstName":"Mauricio","lastName":"Leal"}'
```

using [Ansible](https://www.ansible.com/)
```
ansible localhost -m uri -a 'method=POST headers="Content-type=application/json" status_code=201 return_content=true url="http://localhost:8080/helloworld/api/person" body="{\"firstName\":\"John\",\"lastName\":\"Doe\"}"'
```

## READ 
If you just type submit straight to the service "/person", 
you will get a list of all People in the database
```
curl -i -v -X GET http://<ROUTE>/api/v1/person
```
[Ansible Version](https://www.ansible.com/)
```
ansible localhost -m uri -a 'method=GET url=http://hellomongo.cloudapps.nortlam.net/api/v1/person'
```


There is a simple using OpenShift's Client Command to fetch the content. You can try by running:
```
curl/get_all.sh hell
```


| HTTP Code        | Description |
| -----------------| ------------|
| 200 - Ok         | Return a array of all people included in the database |
| 204 - No Content | There any anybody in the database | 


However, if you indicated a specific ID, you will get the a specific information
from a person
```
curl -i -v -X GET http://localhost:8080/helloworld/api/person/59dd2435e2016e1f644e8404
```


## UPDATE

using curl
```
curl -i -v -X PUT -H "Content-type: application/json" http://localhost:8080/helloworld/api/person/59d9ae6ed30f7d11dde34c59 -d '{"firstName":"Andre","lastName":"Silva"}'
```
using Ansible
```
```


## DELETE
Delete a Person by indicating your ID (for example, using ID 59dccb04e2016e1f64685181)

```
curl -i -v -X DELETE http://<server>:<port>/helloworld/api/person/59dccb04e2016e1f64685181
```
using Ansible
```
ansible localhost -m uri -a 'method="DELETE" headers="Content-type=application/json" url="http://<server>:<port>/helloworld/api/person/59dcd368e2016e1f64924705" status_code=202'
```

| HTTP CODE  | Description |
| ------------- | ------------- |
| 500: Internal Server Error | There were some internal server error that prevented the service to be delivered such as database failure. Contact your administrator. |
