# mkdir /data with root user
# chmod 777 -Rf to /data

# clean everything up
echo "killing mongod and mongos"
export LC_ALL=C
killall mongod
killall mongos


# For mac make sure rlimits are high enough to open all necessary connections
ulimit -n 2048

# start a replica set and tell it that it will be shard0
mongod --replSet shard6_1 --logpath "shard6_1_01.log" --dbpath /data/shard1/rs0 --port 37017 --fork --shardsvr
mongod --replSet shard6_1 --logpath "shard6_1_02.log" --dbpath /data/shard1/rs1 --port 37018 --fork --shardsvr
mongod --replSet shard6_1 --logpath "shard6_1_03.log" --dbpath /data/shard1/rs2 --port 37019 --fork --shardsvr


# start a replicate set and tell it that it will be a shard1
mongod --replSet shard6_2 --logpath "shard6_2_01.log" --dbpath /data/shard2/rs0 --port 47017 --fork --shardsvr
mongod --replSet shard6_2 --logpath "shard6_2_02.log" --dbpath /data/shard2/rs1 --port 47018 --fork --shardsvr
mongod --replSet shard6_2 --logpath "shard6_2_03.log" --dbpath /data/shard2/rs2 --port 47019 --fork --shardsvr

# start a replicate set and tell it that it will be a shard6_3
mongod --replSet shard6_3 --logpath "shard6_3_01.log" --dbpath /data/shard3/rs0 --port 57017 --fork --shardsvr
mongod --replSet shard6_3 --logpath "shard6_3_02.log" --dbpath /data/shard3/rs1 --port 57018 --fork --shardsvr
mongod --replSet shard6_3 --logpath "shard6_3_03.log" --dbpath /data/shard3/rs2 --port 57019 --fork --shardsvr

# now start 3 config servers
mongod --configsvr --replSet configReplSet --port 37041 --logpath "cfg_1_1.log" --dbpath  /data/config/config_1_1 --fork
mongod --configsvr --replSet configReplSet --port 37042 --logpath "cfg_1_2.log" --dbpath  /data/config/config_1_2 --fork
#mongod --configsvr --replSet configReplSet --port 37043 --logpath "cfg-c.log" --dbpath  /data/config/config-c --fork

sleep 10
