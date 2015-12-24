# mkdir /data with root user
# chmod 777 -Rf to /data

# clean everything up
echo "killing mongod and mongos"
export LC_ALL=C
killall mongod
killall mongos
sleep 30
echo "removing data files"


# For mac make sure rlimits are high enough to open all necessary connections
ulimit -n 2048

# now start the mongos on port 27018

mongos --port 27018 --logpath mongos.log --configdb configReplSet/192.168.0.50:37041,192.168.0.50:37042,192.168.0.51:47041,192.168.0.51:47042,192.168.0.52:57041,192.168.0.52:57042 --fork

