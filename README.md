

# CRUD (Create-Read-Update-Delete) operations using Java (JAX-RS) and MongoDB
This project it's a way to create simple examples of a Java application using 
JAX-RS in order to expose API's to create some content into MongoDB.

Ideally, this application should be used with Docker containers. However, if you
don't want to use containers, you may use locally as a simple application deployed
on top of WildFly (or JBoss).

Bellow, are some of the calls you can use in order to add names (more specifically
using first and last name).

## CREATE

## READ 

## UPDATE

## DELETE
Delete a Person by indicating your ID:

```
curl -i -v -X DELETE http://<server>:<port>/helloworld/api/person/59dccb04e2016e1f64685181
```
using Ansible
```ansible
ansible localhost -m uri -a 'method="DELETE" headers="Content-type=application/json" url="http://localhost:8080/helloworld/api/person/59dcd368e2016e1f64924705" status_code=202'
```

| HTTP CODE  | Description |
| ------------- | ------------- |
| 202: Accepted  | The person was successfully deleted   |
| 404: Not Found  | Unable to find Person's ID in the database  |
| 410: Gone  | A person was found but then, it ceases to exist and nothing was deleted (weird)  |
| 503: Service Unavailable  | There was a problem in writing the contents into the database  |
