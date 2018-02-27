selection="{.items[?(.metadata.name==\"${1}\")].spec.host}"
curl -i -v -X GET http://$(oc get routes --output jsonpath=${selection})/api/ping
echo
