#!/bin/sh

# Optional ENV variables:
# * SOURCE_BOOTSTRAP_SERVERS: A external sources to mirror delimited by comma, e.g. 10.0.1.2:9092
# * MIRROR_WHITELIST: A Whitelist of topics to mirror to kafka server

# Set the source host and port to mirror
if  [ ! -z "$SOURCE_BOOTSTRAP_SERVERS" ]; then
    echo "source bootstrap: $SOURCE_BOOTSTRAP_SERVERS"
    if grep -q "^bootstrap.servers" $KAFKA_HOME/config/consumer.properties; then
        sed -r -i "s/(bootstrap.servers)=(.*)/\1=$SOURCE_BOOTSTRAP_SERVERS/g" $KAFKA_HOME/config/consumer.properties
    else
        echo "bootstrap.servers=$SOURCE_BOOTSTRAP_SERVERS" >> $KAFKA_HOME/config/consumer.properties
    fi
fi

# Run mirrormaker
if [ ! -z "$MIRROR_WHITELIST" ]; then
    $KAFKA_HOME/bin/kafka-mirror-maker.sh --consumer.config $KAFKA_HOME/config/consumer.properties --producer.config $KAFKA_HOME/config/producer.properties --whitelist=$MIRROR_WHITELIST
else
    $KAFKA_HOME/bin/kafka-mirror-maker.sh --consumer.config $KAFKA_HOME/config/consumer.properties --producer.config $KAFKA_HOME/config/producer.properties --whitelist=".*"
fi



