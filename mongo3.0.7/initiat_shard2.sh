# mkdir /data with root user
# chmod 777 -Rf to /data

# clean everything up
echo "killing mongod and mongos"
export LC_ALL=C
killall mongod
killall mongos
sleep 30
echo "removing data files"
rm -rf /data/*

# For mac make sure rlimits are high enough to open all necessary connections
ulimit -n 2048

# start a replica set and tell it that it will be shard0
mkdir -p /data/shard1/rs0 /data/shard1/rs1 /data/shard1/rs2
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_1 --logpath "shard2_1_01.log" --dbpath /data/shard1/rs0 --port 37017 --fork --shardsvr --smallfiles
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_1 --logpath "shard2_1_02.log" --dbpath /data/shard1/rs1 --port 37018 --fork --shardsvr --smallfiles
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_1 --logpath "shard2_1_03.log" --dbpath /data/shard1/rs2 --port 37019 --fork --shardsvr --smallfiles

sleep 5
# connect to one server and initiate the set
mongo --port 37017 << 'EOF'
config = { _id: "shard2_1", members:[
          { _id : 0, host : "192.168.0.51:37017" },
          { _id : 1, host : "192.168.0.51:37018" },
          { _id : 2, host : "192.168.0.51:37019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard1
mkdir -p /data/shard2/rs0 /data/shard2/rs1 /data/shard2/rs2
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_2 --logpath "shard2_2_01.log" --dbpath /data/shard2/rs0 --port 47017 --fork --shardsvr --smallfiles
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_2 --logpath "shard2_2_02.log" --dbpath /data/shard2/rs1 --port 47018 --fork --shardsvr --smallfiles
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_2 --logpath "shard2_2_03.log" --dbpath /data/shard2/rs2 --port 47019 --fork --shardsvr --smallfiles

sleep 5

mongo --port 47017 << 'EOF'
config = { _id: "shard2_2", members:[
          { _id : 0, host : "192.168.0.51:47017" },
          { _id : 1, host : "192.168.0.51:47018" },
          { _id : 2, host : "192.168.0.51:47019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard2_3
mkdir -p /data/shard3/rs0 /data/shard3/rs1 /data/shard3/rs2
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_3 --logpath "shard2_3_01.log" --dbpath /data/shard3/rs0 --port 57017 --fork --shardsvr --smallfiles
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_3 --logpath "shard2_3_02.log" --dbpath /data/shard3/rs1 --port 57018 --fork --shardsvr --smallfiles
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --replSet shard2_3 --logpath "shard2_3_03.log" --dbpath /data/shard3/rs2 --port 57019 --fork --shardsvr --smallfiles

sleep 5

mongo --port 57017 << 'EOF'
config = { _id: "shard2_3", members:[
          { _id : 0, host : "192.168.0.51:57017" },
          { _id : 1, host : "192.168.0.51:57018" },
          { _id : 2, host : "192.168.0.51:57019" }]};
rs.initiate(config)
EOF


# now start 3 config servers
rm cfg-b.log
mkdir -p /data/config/config-b
mongod --storageEngine=wiredTiger --wiredTigerCollectionBlockCompressor=zlib --wiredTigerDirectoryForIndexes --logpath "cfg-b.log" --dbpath /data/config/config-b --port 57041 --fork --configsvr --smallfiles
