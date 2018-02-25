selection="{.items[?(.spec.containers[*].name==\"${1}\")].metadata.name}"
oc rsh $(oc get pods --output jsonpath=${selection})
