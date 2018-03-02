oc new-project broker
oc new-app amq63-basic -p APPLICATION_NAME=broker -p MQ_TOPICS=hellomongo -p MQ_USERNAME=mauricio -p MQ_PASSWORD=maltron
