selection="{.items[?(.spec.containers[*].name==\"${1}\")].metadata.name}"
oc logs --follow $(oc get pods --output jsonpath=${selection})
