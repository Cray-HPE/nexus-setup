Create a _debug mode_ deployment:

```
# kubectl apply -f nexus-debug-mode.yaml
```

where `nexus-debug-mode.yaml` contains:

```yaml

```

```
# kubectl scale -n nexus deployment nexus-debug-mode --replicas=1
deployment.apps/nexus-debug-mode scaled
# kubectl wait --for=condition=available -n nexus deploy nexus-debug-mode
deployment.apps/nexus-debug-mode condition met
# kubectl exec -n nexus -ti nexus-debug-mode-7f8465c9d8-nf864 sh
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
Defaulting container name to nexus.
Use 'kubectl describe pod/nexus-debug-mode-7f8465c9d8-nf864 -n nexus' to see all of the containers in this pod.
sh-4.4$ 
```

Delete 0 sized WALs:

```
sh-4.4$ find /nexus-data/db -name '*.wal' -size 0 -exec rm -f {} \;
```

Repair OrientDB database `config`:

```
sh-4.4$ cd /nexus-data/
sh-4.4$ java -jar /opt/sonatype/nexus/lib/support/nexus-orient-console.jar

OrientDB console v.2.2.36 (build d3beb772c02098ceaea89779a7afd4b7305d3788, branch 2.2.x) https://www.orientdb.com
Type 'help' to display all the supported commands.
orientdb> connect plocal:/nexus-data/db/config admin admin

Connecting to database [plocal:/nexus-data/db/config] with user 'admin'...OK
orientdb {db=config}> repair database --fix-links

Repairing database...
- Removing broken links...
-- Done! Fixed links: 0, modified documents: 0
Repair database complete (0 errors)
orientdb {db=config}> rebuild index *


Rebuilding index(es)...
Rebuilt index(es). Found 188 link(s) in 1.824000 sec(s).


Index(es) rebuilt successfully
orientdb {db=config}> disconnect

Disconnecting from the database [config]...OK
orientdb> 
```

Repair OrientDB database `component`:

```
orientdb> connect plocal:/nexus-data/db/component admin admin

Connecting to database [plocal:/nexus-data/db/component] with user 'admin'...
2021-02-04 20:53:31:885 SEVER {db=component} Magic number verification failed for page '219' of 'asset_bucket_component_name_idx.sbt'. [OWOWCache]OK
orientdb {db=component}> repair database --fix-links

Repairing database...
- Removing broken links...
-- Done! Fixed links: 0, modified documents: 0
Repair database complete (0 errors)
orientdb {db=component}> rebuild index * 


Rebuilding index(es)...$ANSI{green {db=component}} Error during index 'OUser.name' delete
com.orientechnologies.orient.core.exception.OPageIsBrokenException: Following files and pages are detected to be broken ['asset_bucket_component_name_idx.sbt' :219;], storage is switched to 'read only' mode. Any modification operations are prohibited. To restore database and make it fully operational you may export and import database to and from JSON.
	DB name="component"
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.checkLowDiskSpaceRequestsAndReadOnlyConditions(OAbstractPaginatedStorage.java:5144)
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.deleteIndexEngine(OAbstractPaginatedStorage.java:2114)
	at com.orientechnologies.orient.core.index.OIndexAbstract.rebuild(OIndexAbstract.java:471)
	at com.orientechnologies.orient.core.index.OIndexAbstract.rebuild(OIndexAbstract.java:403)
	at com.orientechnologies.orient.core.index.OIndexAbstractDelegate.rebuild(OIndexAbstractDelegate.java:167)
	at com.orientechnologies.orient.core.sql.OCommandExecutorSQLRebuildIndex.execute(OCommandExecutorSQLRebuildIndex.java:91)
	at com.orientechnologies.orient.core.sql.OCommandExecutorSQLDelegate.execute(OCommandExecutorSQLDelegate.java:70)
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.executeCommand(OAbstractPaginatedStorage.java:3400)
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.command(OAbstractPaginatedStorage.java:3318)
	at com.orientechnologies.orient.core.command.OCommandRequestTextAbstract.execute(OCommandRequestTextAbstract.java:69)
	at com.orientechnologies.orient.console.OConsoleDatabaseApp.sqlCommand(OConsoleDatabaseApp.java:3076)
	at com.orientechnologies.orient.console.OConsoleDatabaseApp.rebuildIndex(OConsoleDatabaseApp.java:1273)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at com.orientechnologies.common.console.OConsoleApplication.execute(OConsoleApplication.java:405)
	at com.orientechnologies.common.console.OConsoleApplication.executeCommands(OConsoleApplication.java:260)
	at com.orientechnologies.common.console.OConsoleApplication.run(OConsoleApplication.java:131)
	at com.orientechnologies.orient.console.OConsoleDatabaseApp.main(OConsoleDatabaseApp.java:145)
	at org.sonatype.nexus.orient.console.Main.main(Main.java:63)
$ANSI{green {db=component}} Error during index rebuild
com.orientechnologies.orient.core.exception.OPageIsBrokenException: Following files and pages are detected to be broken ['asset_bucket_component_name_idx.sbt' :219;], storage is switched to 'read only' mode. Any modification operations are prohibited. To restore database and make it fully operational you may export and import database to and from JSON.
	DB name="component"
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.checkLowDiskSpaceRequestsAndReadOnlyConditions(OAbstractPaginatedStorage.java:5144)
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.clearIndex(OAbstractPaginatedStorage.java:2232)
	at com.orientechnologies.orient.core.index.OIndexAbstract.rebuild(OIndexAbstract.java:486)
	at com.orientechnologies.orient.core.index.OIndexAbstract.rebuild(OIndexAbstract.java:403)
	at com.orientechnologies.orient.core.index.OIndexAbstractDelegate.rebuild(OIndexAbstractDelegate.java:167)
	at com.orientechnologies.orient.core.sql.OCommandExecutorSQLRebuildIndex.execute(OCommandExecutorSQLRebuildIndex.java:91)
	at com.orientechnologies.orient.core.sql.OCommandExecutorSQLDelegate.execute(OCommandExecutorSQLDelegate.java:70)
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.executeCommand(OAbstractPaginatedStorage.java:3400)
	at com.orientechnologies.orient.core.storage.impl.local.OAbstractPaginatedStorage.command(OAbstractPaginatedStorage.java:3318)
	at com.orientechnologies.orient.core.command.OCommandRequestTextAbstract.execute(OCommandRequestTextAbstract.java:69)
	at com.orientechnologies.orient.console.OConsoleDatabaseApp.sqlCommand(OConsoleDatabaseApp.java:3076)
	at com.orientechnologies.orient.console.OConsoleDatabaseApp.rebuildIndex(OConsoleDatabaseApp.java:1273)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at com.orientechnologies.common.console.OConsoleApplication.execute(OConsoleApplication.java:405)
	at com.orientechnologies.common.console.OConsoleApplication.executeCommands(OConsoleApplication.java:260)
	at com.orientechnologies.common.console.OConsoleApplication.run(OConsoleApplication.java:131)
	at com.orientechnologies.orient.console.OConsoleDatabaseApp.main(OConsoleDatabaseApp.java:145)
	at org.sonatype.nexus.orient.console.Main.main(Main.java:63)

Error: com.orientechnologies.orient.core.exception.OPageIsBrokenException: Following files and pages are detected to be broken ['asset_bucket_component_name_idx.sbt' :219;], storage is switched to 'read only' mode. Any modification operations are prohibited. To restore database and make it fully operational you may export and import database to and from JSON.
	DB name="component"
```

Since it’s read-only, we need to export, delete, then import the database to
fix the problems:

```
orientdb {db=component}> export database component-export
Exporting current database to: database component-export in GZipped JSON format ...

Started export of database 'component' to component-export.json.gz...
Exporting database info...OK
Exporting clusters...OK (105 clusters)
Exporting schema...OK (16 classes)
Exporting records...
- Cluster 'internal' (id=0)...OK (records=3/3)
- Cluster 'index' (id=1)...OK (records=0/0)
- Cluster 'manindex' (id=2)...OK (records=0/0)
- Cluster 'default' (id=3)...OK (records=0/0)
- Cluster 'orole' (id=4)...OK (records=3/3)
- Cluster 'ouser' (id=5)...OK (records=3/3)
- Cluster 'ofunction' (id=6)...OK (records=0/0)
- Cluster 'osequence' (id=7)...OK (records=0/0)
- Cluster 'oschedule' (id=8)...OK (records=0/0)
- Cluster 'v' (id=9)...OK (records=0/0)
- Cluster 'v_1' (id=10)...OK (records=0/0)
- Cluster 'v_2' (id=11)...OK (records=0/0)
- Cluster 'v_3' (id=12)...OK (records=0/0)
- Cluster 'v_4' (id=13)...OK (records=0/0)
- Cluster 'v_5' (id=14)...OK (records=0/0)
- Cluster 'v_6' (id=15)...OK (records=0/0)
- Cluster 'v_7' (id=16)...OK (records=0/0)
- Cluster 'v_8' (id=17)...OK (records=0/0)
- Cluster 'v_9' (id=18)...OK (records=0/0)
- Cluster 'v_10' (id=19)...OK (records=0/0)
- Cluster 'v_11' (id=20)...OK (records=0/0)
- Cluster 'e' (id=21)...OK (records=0/0)
- Cluster 'e_1' (id=22)...OK (records=0/0)
- Cluster 'e_2' (id=23)...OK (records=0/0)
- Cluster 'e_3' (id=24)...OK (records=0/0)
- Cluster 'e_4' (id=25)...OK (records=0/0)
- Cluster 'e_5' (id=26)...OK (records=0/0)
- Cluster 'e_6' (id=27)...OK (records=0/0)
- Cluster 'e_7' (id=28)...OK (records=0/0)
- Cluster 'e_8' (id=29)...OK (records=0/0)
- Cluster 'e_9' (id=30)...OK (records=0/0)
- Cluster 'e_10' (id=31)...OK (records=0/0)
- Cluster 'e_11' (id=32)...OK (records=0/0)
- Cluster 'statushealthcheck' (id=33)...OK (records=1/1)
- Cluster 'statushealthcheck_1' (id=34)...OK (records=0/0)
- Cluster 'statushealthcheck_2' (id=35)...OK (records=0/0)
- Cluster 'statushealthcheck_3' (id=36)...OK (records=0/0)
- Cluster 'statushealthcheck_4' (id=37)...OK (records=0/0)
- Cluster 'statushealthcheck_5' (id=38)...OK (records=0/0)
- Cluster 'statushealthcheck_6' (id=39)...OK (records=0/0)
- Cluster 'statushealthcheck_7' (id=40)...OK (records=0/0)
- Cluster 'statushealthcheck_8' (id=41)...OK (records=0/0)
- Cluster 'statushealthcheck_9' (id=42)...OK (records=0/0)
- Cluster 'statushealthcheck_10' (id=43)...OK (records=0/0)
- Cluster 'statushealthcheck_11' (id=44)...OK (records=0/0)
- Cluster 'docker_foreign_layers' (id=45)...OK (records=0/0)
- Cluster 'docker_foreign_layers_1' (id=46)...OK (records=0/0)
- Cluster 'docker_foreign_layers_2' (id=47)...OK (records=0/0)
- Cluster 'docker_foreign_layers_3' (id=48)...OK (records=0/0)
- Cluster 'docker_foreign_layers_4' (id=49)...OK (records=0/0)
- Cluster 'docker_foreign_layers_5' (id=50)...OK (records=0/0)
- Cluster 'docker_foreign_layers_6' (id=51)...OK (records=0/0)
- Cluster 'docker_foreign_layers_7' (id=52)...OK (records=0/0)
- Cluster 'docker_foreign_layers_8' (id=53)...OK (records=0/0)
- Cluster 'docker_foreign_layers_9' (id=54)...OK (records=0/0)
- Cluster 'docker_foreign_layers_10' (id=55)...OK (records=0/0)
- Cluster 'docker_foreign_layers_11' (id=56)...OK (records=0/0)
- Cluster 'bucket' (id=57)................OK (records=13/13)
- Cluster 'bucket_1' (id=58)................OK (records=13/13)
- Cluster 'bucket_2' (id=59)...............OK (records=12/12)
- Cluster 'bucket_3' (id=60)...............OK (records=12/12)
- Cluster 'bucket_4' (id=61)...............OK (records=12/12)
- Cluster 'bucket_5' (id=62)...............OK (records=12/12)
- Cluster 'bucket_6' (id=63)...............OK (records=12/12)
- Cluster 'bucket_7' (id=64)................OK (records=13/13)
- Cluster 'bucket_8' (id=65)................OK (records=13/13)
- Cluster 'bucket_9' (id=66)................OK (records=13/13)
- Cluster 'bucket_10' (id=67)................OK (records=13/13)
- Cluster 'bucket_11' (id=68)................OK (records=13/13)
- Cluster 'component' (id=69).............OK (records=4519/4519)
- Cluster 'component_1' (id=70).............OK (records=4518/4518)
- Cluster 'component_2' (id=71).............OK (records=4546/4546)
- Cluster 'component_3' (id=72).............OK (records=4541/4541)
- Cluster 'component_4' (id=73).............OK (records=4539/4539)
- Cluster 'component_5' (id=74).............OK (records=4531/4531)
- Cluster 'component_6' (id=75).............OK (records=4523/4523)
- Cluster 'component_7' (id=76).............OK (records=4526/4526)
- Cluster 'component_8' (id=77).............OK (records=4545/4545)
- Cluster 'component_9' (id=78).............OK (records=4549/4549)
- Cluster 'component_10' (id=79).............OK (records=4527/4527)
- Cluster 'component_11' (id=80).............OK (records=4553/4553)
- Cluster 'asset' (id=81).............OK (records=4663/4663)
- Cluster 'asset_1' (id=82).............OK (records=4662/4662)
- Cluster 'asset_2' (id=83).............OK (records=4655/4655)
- Cluster 'asset_3' (id=84).............OK (records=4652/4652)
- Cluster 'asset_4' (id=85).............OK (records=4643/4643)
- Cluster 'asset_5' (id=86).............OK (records=4642/4642)
- Cluster 'asset_6' (id=87).............OK (records=4667/4667)
- Cluster 'asset_7' (id=88).............OK (records=4664/4664)
- Cluster 'asset_8' (id=89).............OK (records=4649/4649)
- Cluster 'asset_9' (id=90).............OK (records=4672/4672)
- Cluster 'asset_10' (id=91).............OK (records=4638/4638)
- Cluster 'asset_11' (id=92).............OK (records=4636/4636)
- Cluster 'browse_node' (id=93).............OK (records=4545/4545)
- Cluster 'browse_node_1' (id=94).............OK (records=4549/4549)
- Cluster 'browse_node_2' (id=95).............OK (records=4563/4563)
- Cluster 'browse_node_3' (id=96).............OK (records=4548/4548)
- Cluster 'browse_node_4' (id=97).............OK (records=4543/4543)
- Cluster 'browse_node_5' (id=98).............OK (records=4555/4555)
- Cluster 'browse_node_6' (id=99).............OK (records=4547/4547)
- Cluster 'browse_node_7' (id=100).............OK (records=4553/4553)
- Cluster 'browse_node_8' (id=101).............OK (records=4576/4576)
- Cluster 'browse_node_9' (id=102).............OK (records=4565/4565)
- Cluster 'browse_node_10' (id=103).............OK (records=4561/4561)
- Cluster 'browse_node_11' (id=104).............OK (records=4580/4580)

Done. Exported 165106 of total 165106 records. 0 records were detected as broken

Exporting index info...
- Index OUser.name...OK
- Index component_bucket_group_name_version_idx...OK
- Index asset_bucket_component_name_idx...OK
- Index browse_node_component_id_idx...OK
- Index asset_component_idx...OK
- Index asset_bucket_name_idx...OK
- Index component_group_name_version_ci_idx...OK
- Index asset_name_ci_idx...OK
- Index OFunction.name...OK
- Index statushealthcheck_node_id_idx...OK
- Index browse_node_asset_id_idx...OK
- Index docker_foreign_layers_digest_idx...OK
- Index dictionary...OK
- Index component_bucket_name_version_idx...OK
- Index browse_node_repository_name_parent_path_name_idx...OK
- Index bucket_repository_name_idx...OK
- Index component_ci_name_ci_idx...OK
- Index ORole.name...OK
OK (18 indexes)
Exporting manual indexes content...
- Exporting index dictionary ...OK (entries=0)
OK (1 manual indexes)

Database export completed in 11137ms
orientdb {db=component}> drop database


Database 'component' deleted successfully
orientdb> create database plocal:/nexus-data/db/component

Creating database [plocal:/nexus-data/db/component] using the storage type [plocal]...
Database created successfully.

Current database is: plocal:/nexus-data/db/component
orientdb {db=component}> import database component-export.json.gz -preserveClusterIDs=true

Importing database database component-export.json.gz -preserveClusterIDs=true...
Started import of database 'plocal:/nexus-data/db/component' from component-export.json.gz...
Non merge mode (-merge=false): removing all default non security classes
- Class E was removed.
- Class V was removed.
- Class ORestricted was removed.
- Class OTriggered was removed.
- Class OSchedule was removed.
- Class OSequence was removed.
- Class OFunction was removed.
Removed 7 classes.
Importing database info...OK
Importing clusters...
- Creating cluster 'internal'...OK, assigned id=0
- Creating cluster 'default'...OK, assigned id=3
- Creating cluster 'orole'...OK, assigned id=4
- Creating cluster 'ouser'...OK, assigned id=5
- Creating cluster 'ofunction'...OK, assigned id=6
- Creating cluster 'osequence'...OK, assigned id=7
- Creating cluster 'oschedule'...OK, assigned id=8
- Creating cluster 'v'...OK, assigned id=9
- Creating cluster 'v_1'...OK, assigned id=10
- Creating cluster 'v_2'...OK, assigned id=11
- Creating cluster 'v_3'...OK, assigned id=12
- Creating cluster 'v_4'...OK, assigned id=13
- Creating cluster 'v_5'...OK, assigned id=14
- Creating cluster 'v_6'...OK, assigned id=15
- Creating cluster 'v_7'...OK, assigned id=16
- Creating cluster 'v_8'...OK, assigned id=17
- Creating cluster 'v_9'...OK, assigned id=18
- Creating cluster 'v_10'...OK, assigned id=19
- Creating cluster 'v_11'...OK, assigned id=20
- Creating cluster 'e'...OK, assigned id=21
- Creating cluster 'e_1'...OK, assigned id=22
- Creating cluster 'e_2'...OK, assigned id=23
- Creating cluster 'e_3'...OK, assigned id=24
- Creating cluster 'e_4'...OK, assigned id=25
- Creating cluster 'e_5'...OK, assigned id=26
- Creating cluster 'e_6'...OK, assigned id=27
- Creating cluster 'e_7'...OK, assigned id=28
- Creating cluster 'e_8'...OK, assigned id=29
- Creating cluster 'e_9'...OK, assigned id=30
- Creating cluster 'e_10'...OK, assigned id=31
- Creating cluster 'e_11'...OK, assigned id=32
- Creating cluster 'statushealthcheck'...OK, assigned id=33
- Creating cluster 'statushealthcheck_1'...OK, assigned id=34
- Creating cluster 'statushealthcheck_2'...OK, assigned id=35
- Creating cluster 'statushealthcheck_3'...OK, assigned id=36
- Creating cluster 'statushealthcheck_4'...OK, assigned id=37
- Creating cluster 'statushealthcheck_5'...OK, assigned id=38
- Creating cluster 'statushealthcheck_6'...OK, assigned id=39
- Creating cluster 'statushealthcheck_7'...OK, assigned id=40
- Creating cluster 'statushealthcheck_8'...OK, assigned id=41
- Creating cluster 'statushealthcheck_9'...OK, assigned id=42
- Creating cluster 'statushealthcheck_10'...OK, assigned id=43
- Creating cluster 'statushealthcheck_11'...OK, assigned id=44
- Creating cluster 'docker_foreign_layers'...OK, assigned id=45
- Creating cluster 'docker_foreign_layers_1'...OK, assigned id=46
- Creating cluster 'docker_foreign_layers_2'...OK, assigned id=47
- Creating cluster 'docker_foreign_layers_3'...OK, assigned id=48
- Creating cluster 'docker_foreign_layers_4'...OK, assigned id=49
- Creating cluster 'docker_foreign_layers_5'...OK, assigned id=50
- Creating cluster 'docker_foreign_layers_6'...OK, assigned id=51
- Creating cluster 'docker_foreign_layers_7'...OK, assigned id=52
- Creating cluster 'docker_foreign_layers_8'...OK, assigned id=53
- Creating cluster 'docker_foreign_layers_9'...OK, assigned id=54
- Creating cluster 'docker_foreign_layers_10'...OK, assigned id=55
- Creating cluster 'docker_foreign_layers_11'...OK, assigned id=56
- Creating cluster 'bucket'...OK, assigned id=57
- Creating cluster 'bucket_1'...OK, assigned id=58
- Creating cluster 'bucket_2'...OK, assigned id=59
- Creating cluster 'bucket_3'...OK, assigned id=60
- Creating cluster 'bucket_4'...OK, assigned id=61
- Creating cluster 'bucket_5'...OK, assigned id=62
- Creating cluster 'bucket_6'...OK, assigned id=63
- Creating cluster 'bucket_7'...OK, assigned id=64
- Creating cluster 'bucket_8'...OK, assigned id=65
- Creating cluster 'bucket_9'...OK, assigned id=66
- Creating cluster 'bucket_10'...OK, assigned id=67
- Creating cluster 'bucket_11'...OK, assigned id=68
- Creating cluster 'component'...OK, assigned id=69
- Creating cluster 'component_1'...OK, assigned id=70
- Creating cluster 'component_2'...OK, assigned id=71
- Creating cluster 'component_3'...OK, assigned id=72
- Creating cluster 'component_4'...OK, assigned id=73
- Creating cluster 'component_5'...OK, assigned id=74
- Creating cluster 'component_6'...OK, assigned id=75
- Creating cluster 'component_7'...OK, assigned id=76
- Creating cluster 'component_8'...OK, assigned id=77
- Creating cluster 'component_9'...OK, assigned id=78
- Creating cluster 'component_10'...OK, assigned id=79
- Creating cluster 'component_11'...OK, assigned id=80
- Creating cluster 'asset'...OK, assigned id=81
- Creating cluster 'asset_1'...OK, assigned id=82
- Creating cluster 'asset_2'...OK, assigned id=83
- Creating cluster 'asset_3'...OK, assigned id=84
- Creating cluster 'asset_4'...OK, assigned id=85
- Creating cluster 'asset_5'...OK, assigned id=86
- Creating cluster 'asset_6'...OK, assigned id=87
- Creating cluster 'asset_7'...OK, assigned id=88
- Creating cluster 'asset_8'...OK, assigned id=89
- Creating cluster 'asset_9'...OK, assigned id=90
- Creating cluster 'asset_10'...OK, assigned id=91
- Creating cluster 'asset_11'...OK, assigned id=92
- Creating cluster 'browse_node'...OK, assigned id=93
- Creating cluster 'browse_node_1'...OK, assigned id=94
- Creating cluster 'browse_node_2'...OK, assigned id=95
- Creating cluster 'browse_node_3'...OK, assigned id=96
- Creating cluster 'browse_node_4'...OK, assigned id=97
- Creating cluster 'browse_node_5'...OK, assigned id=98
- Creating cluster 'browse_node_6'...OK, assigned id=99
- Creating cluster 'browse_node_7'...OK, assigned id=100
- Creating cluster 'browse_node_8'...OK, assigned id=101
- Creating cluster 'browse_node_9'...OK, assigned id=102
- Creating cluster 'browse_node_10'...OK, assigned id=103
- Creating cluster 'browse_node_11'...OK, assigned id=104
Rebuilding indexes of truncated clusters ...
- Cluster content was updated: rebuilding index 'ORole.name'... Index ORole.name was successfully rebuilt.
- Cluster content was updated: rebuilding index 'OUser.name'... Index OUser.name was successfully rebuilt.
Done 2 indexes were rebuilt.
Done. Imported 103 clusters
Importing database schema...OK (16 classes)

Importing records...
- Imported 41,902 records into clusters: [bucket, bucket_1, bucket_10, bucket_11, bucket_2, bucket_3, bucket_4, bucket_5, bucket_6, bucket_7, bucket_8, bucket_9, component, component_1, component_10, component_11, component_2, component_3, component_4, component_5, component_6, component_7, component_8, component_9, internal, orole, ouser, statushealthcheck]. Total records imported so far: 41,902 (8,380.40/sec)
- Imported 34,521 records into clusters: [asset, asset_1, asset_10, asset_11, asset_2, asset_3, asset_4, asset_5, asset_6, asset_7, asset_8, asset_9, component, component_1, component_10, component_11, component_2, component_3, component_4, component_5, component_6, component_7, component_8, component_9]. Total records imported so far: 76,423 (6,904.20/sec)
- Imported 32,468 records into clusters: [asset, asset_1, asset_10, asset_11, asset_2, asset_3, asset_4, asset_5, asset_6, asset_7, asset_8, asset_9]. Total records imported so far: 108,891 (6,493.60/sec)
- Imported 41,806 records into clusters: [asset, asset_1, asset_10, asset_11, asset_2, asset_3, asset_4, asset_5, asset_6, asset_7, asset_8, asset_9, browse_node, browse_node_1, browse_node_10, browse_node_11, browse_node_2, browse_node_3, browse_node_4, browse_node_5, browse_node_6, browse_node_7, browse_node_8, browse_node_9]. Total records imported so far: 150,697 (8,361.20/sec)Reading of set of RIDs of records which were detected as broken during database export
1 were detected as broken during database export, links on those records will be removed from result database

Started migration of links (-migrateLinks=true). Links are going to be updated according to new RIDs:
- Cluster browse_node_8... Completed migration of 4,557 records in current cluster
- Cluster browse_node_9... Completed migration of 4,557 records in current cluster
- Cluster statushealthcheck... Completed migration of 1 records in current cluster
- Cluster asset_11... Completed migration of 4,653 records in current cluster
- Cluster asset_10... Completed migration of 4,653 records in current cluster
- Cluster oschedule... Completed migration of 0 records in current cluster
- Cluster bucket_10... Completed migration of 12 records in current cluster
- Cluster e_11... Completed migration of 0 records in current cluster
- Cluster bucket_11... Completed migration of 12 records in current cluster
- Cluster e_10... Completed migration of 0 records in current cluster
- Cluster browse_node_6... Completed migration of 4,557 records in current cluster
- Cluster browse_node_7... Completed migration of 4,557 records in current cluster
- Cluster browse_node_4... Completed migration of 4,557 records in current cluster
- Cluster browse_node_5... Completed migration of 4,557 records in current cluster
- Cluster browse_node_2... Completed migration of 4,557 records in current cluster
- Cluster browse_node_3... Completed migration of 4,557 records in current cluster
- Cluster browse_node_1... Completed migration of 4,557 records in current cluster
- Cluster statushealthcheck_11... Completed migration of 0 records in current cluster
- Cluster statushealthcheck_10... Completed migration of 0 records in current cluster
- Cluster osequence... Completed migration of 0 records in current cluster
- Cluster bucket... Completed migration of 13 records in current cluster
- Cluster orole... Completed migration of 3 records in current cluster
- Cluster component_5... Completed migration of 4,535 records in current cluster
- Cluster component_4... Completed migration of 4,535 records in current cluster
- Cluster component_3... Completed migration of 4,535 records in current cluster
- Cluster bucket_9... Completed migration of 12 records in current cluster
- Cluster component_2...
--- Migrated 2,996 of 4,535 records (13,394.60/sec)
--- Completed migration of 4,535 records in current cluster
- Cluster bucket_8... Completed migration of 12 records in current cluster
- Cluster component_9... Completed migration of 4,534 records in current cluster
- Cluster bucket_7... Completed migration of 12 records in current cluster
- Cluster component_8... Completed migration of 4,535 records in current cluster
- Cluster bucket_6... Completed migration of 13 records in current cluster
- Cluster component_7... Completed migration of 4,535 records in current cluster
- Cluster bucket_5... Completed migration of 13 records in current cluster
- Cluster component_6... Completed migration of 4,535 records in current cluster
- Cluster default... Completed migration of 0 records in current cluster
- Cluster component_1... Completed migration of 4,535 records in current cluster
- Cluster asset_8... Completed migration of 4,653 records in current cluster
- Cluster asset_7... Completed migration of 4,653 records in current cluster
- Cluster asset_9... Completed migration of 4,653 records in current cluster
- Cluster asset_4... Completed migration of 4,654 records in current cluster
- Cluster asset_3... Completed migration of 4,654 records in current cluster
- Cluster asset_6... Completed migration of 4,654 records in current cluster
- Cluster browse_node... Completed migration of 4,558 records in current cluster
- Cluster asset_5... Completed migration of 4,654 records in current cluster
- Cluster asset_2...
--- Migrated 3,210 of 4,654 records (12,921.20/sec)
--- Completed migration of 4,654 records in current cluster
- Cluster asset_1... Completed migration of 4,654 records in current cluster
- Cluster e... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_10... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_11... Completed migration of 0 records in current cluster
- Cluster bucket_4... Completed migration of 13 records in current cluster
- Cluster bucket_3... Completed migration of 13 records in current cluster
- Cluster bucket_2... Completed migration of 13 records in current cluster
- Cluster component... Completed migration of 4,535 records in current cluster
- Cluster bucket_1... Completed migration of 13 records in current cluster
- Cluster v... Completed migration of 0 records in current cluster
- Cluster asset... Completed migration of 4,654 records in current cluster
- Cluster statushealthcheck_7... Completed migration of 0 records in current cluster
- Cluster statushealthcheck_8... Completed migration of 0 records in current cluster
- Cluster statushealthcheck_5... Completed migration of 0 records in current cluster
- Cluster statushealthcheck_6... Completed migration of 0 records in current cluster
- Cluster statushealthcheck_9... Completed migration of 0 records in current cluster
- Cluster statushealthcheck_3... Completed migration of 0 records in current cluster
- Cluster statushealthcheck_4... Completed migration of 0 records in current cluster
- Cluster component_11... Completed migration of 4,534 records in current cluster
- Cluster statushealthcheck_1... Completed migration of 0 records in current cluster
- Cluster component_10... Completed migration of 4,534 records in current cluster
- Cluster statushealthcheck_2... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_8... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_7... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_9... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_4... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_3... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_6... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_5... Completed migration of 0 records in current cluster
- Cluster v_2... Completed migration of 0 records in current cluster
- Cluster v_1... Completed migration of 0 records in current cluster
- Cluster v_4... Completed migration of 0 records in current cluster
- Cluster v_3... Completed migration of 0 records in current cluster
- Cluster v_6... Completed migration of 0 records in current cluster
- Cluster v_5... Completed migration of 0 records in current cluster
- Cluster v_8... Completed migration of 0 records in current cluster
- Cluster v_7... Completed migration of 0 records in current cluster
- Cluster v_9... Completed migration of 0 records in current cluster
- Cluster ofunction... Completed migration of 0 records in current cluster
- Cluster v_11... Completed migration of 0 records in current cluster
- Cluster v_10... Completed migration of 0 records in current cluster
- Cluster e_1... Completed migration of 0 records in current cluster
- Cluster e_3... Completed migration of 0 records in current cluster
- Cluster e_2... Completed migration of 0 records in current cluster
- Cluster e_5... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_2... Completed migration of 0 records in current cluster
- Cluster e_4... Completed migration of 0 records in current cluster
- Cluster docker_foreign_layers_1... Completed migration of 0 records in current cluster
- Cluster e_7... Completed migration of 0 records in current cluster
- Cluster e_6... Completed migration of 0 records in current cluster
- Cluster e_9... Completed migration of 0 records in current cluster
- Cluster e_8... Completed migration of 0 records in current cluster
- Cluster browse_node_11... Completed migration of 4,557 records in current cluster
- Cluster ouser... Completed migration of 3 records in current cluster
- Cluster browse_node_10... Completed migration of 4,557 records in current cluster
Total links updated: 165,103

Done. Imported 165,104 records in 33.58 secs


Importing indexes ...
- Index 'OUser.name'...OK
- Index 'component_bucket_group_name_version_idx'...OK
- Index 'asset_bucket_component_name_idx'...OK
- Index 'browse_node_component_id_idx'...OK
- Index 'asset_component_idx'...OK
- Index 'asset_bucket_name_idx'...OK
- Index 'component_group_name_version_ci_idx'...OK
- Index 'asset_name_ci_idx'...OK
- Index 'OFunction.name'...OK
- Index 'statushealthcheck_node_id_idx'...OK
- Index 'browse_node_asset_id_idx'...OK
- Index 'docker_foreign_layers_digest_idx'...OK
- Index 'dictionary'...OK
- Index 'component_bucket_name_version_idx'...OK
- Index 'browse_node_repository_name_parent_path_name_idx'...OK
- Index 'bucket_repository_name_idx'...OK
- Index 'component_ci_name_ci_idx'...OK
- Index 'ORole.name'...OK
Done. Created 18 indexes.
Importing manual index entries...
- Index 'dictionary'...OK (0 entries)
Done. Imported 1 indexes.
Rebuild of stale indexes...
Stale indexes were rebuilt...
Deleting RID Mapping table...OK


Database import completed in 84008 ms
orientdb {db=component}> rebuild index *


Rebuilding index(es)...
Rebuilt index(es). Found 601625 link(s) in 45.928001 sec(s).


Index(es) rebuilt successfully
orientdb {db=component}> disconnect

Disconnecting from the database [component]...OK
orientdb> exit
sh-4.4$ 
```
