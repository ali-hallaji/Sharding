mongo --port 37041 << 'EOF'
rs.initiate( {
   _id: "configReplSet",
   configsvr: true,
   members: [
      { _id: 0, host: "shard3:57041" },
      { _id: 1, host: "shard2:47041" },
      { _id: 2, host: "shard1:37041" },
      { _id: 3, host: "shard4:37041" },
      { _id: 4, host: "shard5:37041" },
      { _id: 5, host: "shard6:37041" },
      { _id: 6, host: "shard6:37042" },
      { _id: 7, host: "shard3:57042", votes:0 , priority:0 },
      { _id: 8, host: "shard2:47042", votes:0 , priority:0 },
      { _id: 9, host: "shard1:37042", votes:0 , priority:0 },
      { _id: 10, host: "shard4:37042", votes:0 , priority:0 },
      { _id: 11, host: "shard5:37042", votes:0 , priority:0 },
   ]
} )
EOF


