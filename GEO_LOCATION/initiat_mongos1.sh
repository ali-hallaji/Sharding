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
mongos --port 27018 --logpath mongos.log --configdb configReplSet/shard1:37041,shard1:37042,shard2:47041,shard2:47042,shard3:57041,shard3:57042,shard4:37041,shard4:37042,shard5:47041,shard5:47042,shard6:57041,shard6:57042 --fork

echo "Waiting 60 seconds for the replica sets to fully come online"
sleep 60
