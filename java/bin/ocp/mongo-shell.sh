selection="{.items[?(.spec.containers[*].name==\"${1}\")].metadata.name}"
oc exec -ti $(oc get pods --output jsonpath=${selection}) -- bash -c 'mongo 127.0.0.1:27017/$MONGODB_DATABASE -u $MONGODB_USER -p $MONGODB_PASSWORD'
