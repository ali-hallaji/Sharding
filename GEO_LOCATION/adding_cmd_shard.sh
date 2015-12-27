echo "Connnecting to mongos and enabling sharding"

# add shards and enable sharding on the test db
mongo --port 27018 << 'EOF'
db.adminCommand( { addshard : "shard1_1/"+"shard1:37017" } );
db.adminCommand( { addshard : "shard1_2/"+"shard1:47017" } );
db.adminCommand( { addshard : "shard1_3/"+"shard1:57017" } );
db.adminCommand( { addshard : "shard2_1/"+"shard2:37017" } );
db.adminCommand( { addshard : "shard2_2/"+"shard2:47017" } );
db.adminCommand( { addshard : "shard2_3/"+"shard2:57017" } );
db.adminCommand( { addshard : "shard3_1/"+"shard3:37017" } );
db.adminCommand( { addshard : "shard3_2/"+"shard3:47017" } );
db.adminCommand( { addshard : "shard3_3/"+"shard3:57017" } );
db.adminCommand( { addshard : "shard4_1/"+"shard4:37017" } );
db.adminCommand( { addshard : "shard4_2/"+"shard4:47017" } );
db.adminCommand( { addshard : "shard4_3/"+"shard4:57017" } );
db.adminCommand( { addshard : "shard5_1/"+"shard5:37017" } );
db.adminCommand( { addshard : "shard5_2/"+"shard5:47017" } );
db.adminCommand( { addshard : "shard5_3/"+"shard5:57017" } );
db.adminCommand( { addshard : "shard6_1/"+"shard6:37017" } );
db.adminCommand( { addshard : "shard6_2/"+"shard6:47017" } );
db.adminCommand( { addshard : "shard6_3/"+"shard6:57017" } );

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
sh.addShardTag("shard4_1",  'ZONE10');
sh.addShardTag("shard4_2",  'ZONE11');
sh.addShardTag("shard4_3",  'ZONE12');
sh.addShardTag("shard5_1",  'ZONE13');
sh.addShardTag("shard5_2",  'ZONE14');
sh.addShardTag("shard5_3",  'ZONE15');
sh.addShardTag("shard6_1",  'ZONE16');
sh.addShardTag("shard6_2",  'ZONE17');
sh.addShardTag("shard6_3",  'ZONE18');

sh.addTagRange("INN.origins", { origin_code: 0 }, { origin_code: 3 }, 'ZONE1');
sh.addTagRange("INN.origins", { origin_code: 3 }, { origin_code: 7 }, 'ZONE2');
sh.addTagRange("INN.origins", { origin_code: 7 }, { origin_code: 11 }, 'ZONE3');
sh.addTagRange("INN.origins", { origin_code: 11 }, { origin_code: 15 }, 'ZONE4');
sh.addTagRange("INN.origins", { origin_code: 15 }, { origin_code: 19 }, 'ZONE5');
sh.addTagRange("INN.origins", { origin_code: 19 }, { origin_code: 23 }, 'ZONE6');
sh.addTagRange("INN.origins", { origin_code: 23 }, { origin_code: 26 }, 'ZONE7');
sh.addTagRange("INN.origins", { origin_code: 26 }, { origin_code: 29 }, 'ZONE8');
sh.addTagRange("INN.origins", { origin_code: 29 }, { origin_code: 32 }, 'ZONE9');
sh.addTagRange("INN.origins", { origin_code: 32 }, { origin_code: 36 }, 'ZONE10');
sh.addTagRange("INN.origins", { origin_code: 36 }, { origin_code: 39 }, 'ZONE11');
sh.addTagRange("INN.origins", { origin_code: 39 }, { origin_code: 41 }, 'ZONE12');
sh.addTagRange("INN.origins", { origin_code: 41 }, { origin_code: 44 }, 'ZONE13');
sh.addTagRange("INN.origins", { origin_code: 44 }, { origin_code: 47 }, 'ZONE14');
sh.addTagRange("INN.origins", { origin_code: 47 }, { origin_code: 50 }, 'ZONE15');
sh.addTagRange("INN.origins", { origin_code: 50 }, { origin_code: 53 }, 'ZONE16');
sh.addTagRange("INN.origins", { origin_code: 53 }, { origin_code: 57 }, 'ZONE17');
sh.addTagRange("INN.origins", { origin_code: 57 }, { origin_code: 58 }, 'ZONE18');

sh.addTagRange("INN.destinations", { destination_code: 0 }, { destination_code: 3 }, 'ZONE1');
sh.addTagRange("INN.destinations", { destination_code: 3 }, { destination_code: 7 }, 'ZONE2');
sh.addTagRange("INN.destinations", { destination_code: 7 }, { destination_code: 11 }, 'ZONE3');
sh.addTagRange("INN.destinations", { destination_code: 11 }, { destination_code: 15 }, 'ZONE4');
sh.addTagRange("INN.destinations", { destination_code: 15 }, { destination_code: 19 }, 'ZONE5');
sh.addTagRange("INN.destinations", { destination_code: 19 }, { destination_code: 23 }, 'ZONE6');
sh.addTagRange("INN.destinations", { destination_code: 23 }, { destination_code: 26 }, 'ZONE7');
sh.addTagRange("INN.destinations", { destination_code: 26 }, { destination_code: 29 }, 'ZONE8');
sh.addTagRange("INN.destinations", { destination_code: 29 }, { destination_code: 32 }, 'ZONE9');
sh.addTagRange("INN.destinations", { destination_code: 32 }, { destination_code: 36 }, 'ZONE10');
sh.addTagRange("INN.destinations", { destination_code: 36 }, { destination_code: 39 }, 'ZONE11');
sh.addTagRange("INN.destinations", { destination_code: 39 }, { destination_code: 41 }, 'ZONE12');
sh.addTagRange("INN.destinations", { destination_code: 41 }, { destination_code: 44 }, 'ZONE13');
sh.addTagRange("INN.destinations", { destination_code: 44 }, { destination_code: 47 }, 'ZONE14');
sh.addTagRange("INN.destinations", { destination_code: 47 }, { destination_code: 50 }, 'ZONE15');
sh.addTagRange("INN.destinations", { destination_code: 50 }, { destination_code: 53 }, 'ZONE16');
sh.addTagRange("INN.destinations", { destination_code: 53 }, { destination_code: 57 }, 'ZONE17');
sh.addTagRange("INN.destinations", { destination_code: 57 }, { destination_code: 58 }, 'ZONE18');


EOF
sleep 5
