selection="{.items[?(.metadata.name==\"${1}\")].spec.host}"
curl -i -v -X PUT -H "Content-type: application/json" http://$(oc get routes --output jsonpath=${selection})/api/v1/person/${2} -d "${3}"
echo
