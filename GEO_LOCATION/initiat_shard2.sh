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
mongod --replSet shard2_1 --logpath "shard2_1_01.log" --dbpath /data/shard1/rs0 --port 37017 --fork --shardsvr
mongod --replSet shard2_1 --logpath "shard2_1_02.log" --dbpath /data/shard1/rs1 --port 37018 --fork --shardsvr
mongod --replSet shard2_1 --logpath "shard2_1_03.log" --dbpath /data/shard1/rs2 --port 37019 --fork --shardsvr

sleep 5
# connect to one server and initiate the set
mongo --port 37017 << 'EOF'
config = { _id: "shard2_1", members:[
          { _id : 0, host : "shard2:37017" },
          { _id : 1, host : "shard2:37018" },
          { _id : 2, host : "shard2:37019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard1
mkdir -p /data/shard2/rs0 /data/shard2/rs1 /data/shard2/rs2
mongod --replSet shard2_2 --logpath "shard2_2_01.log" --dbpath /data/shard2/rs0 --port 47017 --fork --shardsvr
mongod --replSet shard2_2 --logpath "shard2_2_02.log" --dbpath /data/shard2/rs1 --port 47018 --fork --shardsvr
mongod --replSet shard2_2 --logpath "shard2_2_03.log" --dbpath /data/shard2/rs2 --port 47019 --fork --shardsvr

sleep 5

mongo --port 47017 << 'EOF'
config = { _id: "shard2_2", members:[
          { _id : 0, host : "shard2:47017" },
          { _id : 1, host : "shard2:47018" },
          { _id : 2, host : "shard2:47019" }]};
rs.initiate(config)
EOF

# start a replicate set and tell it that it will be a shard2_3
mkdir -p /data/shard3/rs0 /data/shard3/rs1 /data/shard3/rs2
mongod --replSet shard2_3 --logpath "shard2_3_01.log" --dbpath /data/shard3/rs0 --port 57017 --fork --shardsvr
mongod --replSet shard2_3 --logpath "shard2_3_02.log" --dbpath /data/shard3/rs1 --port 57018 --fork --shardsvr
mongod --replSet shard2_3 --logpath "shard2_3_03.log" --dbpath /data/shard3/rs2 --port 57019 --fork --shardsvr

sleep 5

mongo --port 57017 << 'EOF'
config = { _id: "shard2_3", members:[
          { _id : 0, host : "shard2:57017" },
          { _id : 1, host : "shard2:57018" },
          { _id : 2, host : "shard2:57019" }]};
rs.initiate(config)
EOF


# now start 3 config servers
rm cfg-b.log
mkdir -p /data/config/config_2_1 /data/config/config_2_2
mongod --configsvr --replSet configReplSet --port 47041 --logpath "cfg_2_1.log" --dbpath  /data/config/config_2_1 --fork
mongod --configsvr --replSet configReplSet --port 47042 --logpath "cfg_2_2.log" --dbpath  /data/config/config_2_2 --fork

# sleep 10

# mongo --port 47041 << 'EOF'
# rs.initiate( {
#    _id: "configReplSet2",
#    configsvr: true,
#    members: [
#       { _id: 0, host: "shard2:47041" },
#       { _id: 1, host: "shard2:47042" },
#       { _id: 2, host: "shard2:47043" }
#    ]
# } )
# EOF
