#!/usr/bin/env bash
set -e

mkdir -p /data/rs0-1 /data/rs0-2 /data/rs0-3

mongod --replSet rs0 --port 27017 --dbpath /data/rs0-1 --bind_ip_all --fork --logpath /var/log/mongo1.log
mongod --replSet rs0 --port 27018 --dbpath /data/rs0-2 --bind_ip_all --fork --logpath /var/log/mongo2.log
mongod --replSet rs0 --port 27019 --dbpath /data/rs0-3 --bind_ip_all --fork --logpath /var/log/mongo3.log

sleep 3

mongosh --port 27017 --eval '
try { rs.status() } catch (e) {
  rs.initiate({
    _id: "rs0",
    members: [
      { _id: 0, host: "localhost:27017" },
      { _id: 1, host: "localhost:27018" },
      { _id: 2, host: "localhost:27019" }
    ]
  })
}
' || true

tail -f /var/log/mongo1.log /var/log/mongo2.log /var/log/mongo3.log
