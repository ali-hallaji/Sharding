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

# now start the mongos on port 27018
rm mongos-1.log
sleep 5
mongos --port 27018 --logpath mongos.log --configdb configReplSet/192.168.0.50:37041,192.168.0.50:37042,192.168.0.51:47041,192.168.0.51:47042,192.168.0.52:57041,192.168.0.52:57042 --fork
echo "Waiting 60 seconds for the replica sets to fully come online"
sleep 60
echo "Connnecting to mongos and enabling sharding"

# add shards and enable sharding on the test db
mongo --port 27018 << 'EOF'
db.adminCommand( { addshard : "shard1_1/"+"192.168.0.50:37017" } );
db.adminCommand( { addshard : "shard1_2/"+"192.168.0.50:47017" } );
db.adminCommand( { addshard : "shard1_3/"+"192.168.0.50:57017" } );
db.adminCommand( { addshard : "shard2_1/"+"192.168.0.51:37017" } );
db.adminCommand( { addshard : "shard2_2/"+"192.168.0.51:47017" } );
db.adminCommand( { addshard : "shard2_3/"+"192.168.0.51:57017" } );
db.adminCommand( { addshard : "shard3_1/"+"192.168.0.52:37017" } );
db.adminCommand( { addshard : "shard3_2/"+"192.168.0.52:47017" } );
db.adminCommand( { addshard : "shard3_3/"+"192.168.0.52:57017" } );
db.adminCommand({enableSharding: "INN"});
sh.shardCollection("INN.origins", {"origin_code": 1});
sh.shardCollection("INN.destinations", {"destination_code": 1});

sh.addShardTag("shard1_1",  'ZONE1');
sh.addShardTag("shard1_2",  'ZONE2');
sh.addShardTag("shard1_3",  'ZONE3');
sh.addShardTag("shard2_1",  'ZONE4');
sh.addShardTag("shard2_2",  'ZONE5');
sh.addShardTag("shard2_3",  'ZONE6');
sh.addShardTag("shard3_1",  'ZONE7');
sh.addShardTag("shard3_2",  'ZONE8');
sh.addShardTag("shard3_3",  'ZONE9');

sh.addTagRange("INN.origins", { origin_code: 0 }, { origin_code: 7 }, 'ZONE1');
sh.addTagRange("INN.origins", { origin_code: 7 }, { origin_code: 14 }, 'ZONE2');
sh.addTagRange("INN.origins", { origin_code: 14 }, { origin_code: 21 }, 'ZONE3');
sh.addTagRange("INN.origins", { origin_code: 21 }, { origin_code: 28 }, 'ZONE4');
sh.addTagRange("INN.origins", { origin_code: 28 }, { origin_code: 35 }, 'ZONE5');
sh.addTagRange("INN.origins", { origin_code: 35 }, { origin_code: 42 }, 'ZONE6');
sh.addTagRange("INN.origins", { origin_code: 42 }, { origin_code: 49 }, 'ZONE7');
sh.addTagRange("INN.origins", { origin_code: 49 }, { origin_code: 53 }, 'ZONE8');
sh.addTagRange("INN.origins", { origin_code: 53 }, { origin_code: 58 }, 'ZONE9');

sh.addTagRange("INN.destinations", { destination_code: 0 }, { destination_code: 7 }, 'ZONE1');
sh.addTagRange("INN.destinations", { destination_code: 7 }, { destination_code: 14 }, 'ZONE2');
sh.addTagRange("INN.destinations", { destination_code: 14 }, { destination_code: 21 }, 'ZONE3');
sh.addTagRange("INN.destinations", { destination_code: 21 }, { destination_code: 28 }, 'ZONE4');
sh.addTagRange("INN.destinations", { destination_code: 28 }, { destination_code: 35 }, 'ZONE5');
sh.addTagRange("INN.destinations", { destination_code: 35 }, { destination_code: 42 }, 'ZONE6');
sh.addTagRange("INN.destinations", { destination_code: 42 }, { destination_code: 49 }, 'ZONE7');
sh.addTagRange("INN.destinations", { destination_code: 49 }, { destination_code: 53 }, 'ZONE8');
sh.addTagRange("INN.destinations", { destination_code: 53 }, { destination_code: 58 }, 'ZONE9');

EOF
sleep 5
