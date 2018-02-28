oc new-project hellomongo
oc new-app -f https://raw.githubusercontent.com/latam-tech-office/testdrive-cicd/master/ocp/template/wildfly-mongo.yaml -p APPLICATION_NAME=hellomongo -p DB_USERNAME=mauricio -p DB_PASSWORD=maltron -p DB_DATABASE=sampledb -p BROKER_ADDRESS=broker-amq-tcp.broker -p BROKER_USERNAME=mauricio -p BROKER_PASSWORD=maltron -p BROKER_TOPICS=hellomongo
oc set probe dc/hellomongo-app --readiness --initial-delay-seconds=20 --period-seconds=15 --get-url=http://:8080/api/ping
