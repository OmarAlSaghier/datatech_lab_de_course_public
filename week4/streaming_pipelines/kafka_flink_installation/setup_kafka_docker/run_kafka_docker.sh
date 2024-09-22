# local kafka:
docker run --platform linux/amd64 -d \
    -p 2181:2181 \
    --name=zookeeper \
    -e ZOOKEEPER_CLIENT_PORT=2181 \
    confluentinc/cp-zookeeper:7.0.1

docker run --platform linux/amd64 -d \
    --name=kafka \
    -p 9092:9092 \
    -e KAFKA_ZOOKEEPER_CONNECT=172.17.0.1:2181 \
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092 \
    -e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
    confluentinc/cp-kafka:7.0.1


docker exec -it <container_name> bash


docker exec kafka \
kafka-topics --bootstrap-server kafka:9092 \
             --create \
             --topic zaka-topic
