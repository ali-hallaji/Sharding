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
mongod --replSet shard3_1 --logpath "shard3_1_01.log" --dbpath /data/shard1/rs0 --port 37017 --fork --shardsvr
mongod --replSet shard3_1 --logpath "shard3_1_02.log" --dbpath /data/shard1/rs1 --port 37018 --fork --shardsvr
mongod --replSet shard3_1 --logpath "shard3_1_03.log" --dbpath /data/shard1/rs2 --port 37019 --fork --shardsvr

sleep 5
# connect to one server and initiate the set
mongo --port 37017 << 'EOF'
config = { _id: "shard3_1", members:[
          { _id : 0, host : "shard3:37017" },
          { _id : 1, host : "shard3:37018" },
          { _id : 2, host : "shard3:37019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard1
mkdir -p /data/shard2/rs0 /data/shard2/rs1 /data/shard2/rs2
mongod --replSet shard3_2 --logpath "shard3_2_01.log" --dbpath /data/shard2/rs0 --port 47017 --fork --shardsvr
mongod --replSet shard3_2 --logpath "shard3_2_02.log" --dbpath /data/shard2/rs1 --port 47018 --fork --shardsvr
mongod --replSet shard3_2 --logpath "shard3_2_03.log" --dbpath /data/shard2/rs2 --port 47019 --fork --shardsvr

sleep 5

mongo --port 47017 << 'EOF'
config = { _id: "shard3_2", members:[
          { _id : 0, host : "shard3:47017" },
          { _id : 1, host : "shard3:47018" },
          { _id : 2, host : "shard3:47019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard3_3
mkdir -p /data/shard3/rs0 /data/shard3/rs1 /data/shard3/rs2
mongod --replSet shard3_3 --logpath "shard3_3_01.log" --dbpath /data/shard3/rs0 --port 57017 --fork --shardsvr
mongod --replSet shard3_3 --logpath "shard3_3_02.log" --dbpath /data/shard3/rs1 --port 57018 --fork --shardsvr
mongod --replSet shard3_3 --logpath "shard3_3_03.log" --dbpath /data/shard3/rs2 --port 57019 --fork --shardsvr

sleep 5

mongo --port 57017 << 'EOF'
config = { _id: "shard3_3", members:[
          { _id : 0, host : "shard3:57017" },
          { _id : 1, host : "shard3:57018" },
          { _id : 2, host : "shard3:57019" }]};
rs.initiate(config)
EOF

# now start 3 config servers
mkdir -p /data/config/config_3_1 /data/config/config_3_2
mongod --configsvr --replSet configReplSet --port 57041 --logpath "cfg_3_1.log" --dbpath  /data/config/config_3_1 --fork
mongod --configsvr --replSet configReplSet --port 57042 --logpath "cfg_3_2.log" --dbpath  /data/config/config_3_2 --fork
# mongod --configsvr --replSet configReplSet3 --port 57043 --logpath "cfg-c.log" --dbpath  /data/config/config-c --fork

# sleep 10

