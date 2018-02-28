oc new-project broker
oc new-app amq63-basic -p APPLICATION_NAME=broker -p MQ_TOPICS=hellomongo -p MQ_USERNAME=mauricio -p MQ_PASSWORD=maltron
oc patch dc/broker-amq --patch '{"spec":{"triggers":[{"imageChangeParams": {"automatic": true,"containerNames": ["broker-amq"],"from": {"kind": "ImageStreamTag","name": "jboss-amq-63:latest","namespace": "openshift"}},"type": "ImageChange"},{"type": "ConfigChange"}]}}'

