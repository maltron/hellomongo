selection="{.items[?(.metadata.name==\"${1}\")].spec.host}"
curl -i -v -X GET -H "Accept: application/json" http://$(oc get routes --output jsonpath=${selection})/api/v1/customer/"${2}"
echo
