selection="{.items[?(.metadata.name==\"${1}\")].spec.host}"
curl -i -v -X POST -H "Content-type: application/json" http://$(oc get routes --output jsonpath=${selection})/api/v1/customer -d "${2}"
echo
