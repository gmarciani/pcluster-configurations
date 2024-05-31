# AWS ParallelCluster -- Amazon file Cache

## Creating S3 objects with permissions

```
 aws s3api put-object \
 --bucket pcluster-test-fsx-file-cache \
 --key data/config2.yaml \
 --body /Users/mgiacomo/workplace/aws-parallelcluster-dev/MGIACOMO-AWSParallelCluster/cluster-config/storage/file-cache/config.yaml \
 --metadata '{"file-owner":"1000" , "file-permissions":"0100664","file-group":"1000"}'
```

## Importing files using HSM commands
```
sudo lfs hsm_restore /opt/shared/fsxcache/external/1/s3/pcluster-test-fsx-file-cache/config2.yaml
```

### Check status of import
```
sudo lfs hsm_action /opt/shared/fsxcache/external/1/s3/pcluster-test-fsx-file-cache/config2.yaml
```

## Exporting files using HSM commands

```
sudo lfs hsm_archive /opt/shared/fsxcache/external/1/s3/pcluster-test-fsx-file-cache/from-head-node.txt
```

### Check status of export
```
sudo lfs hsm_state /opt/shared/fsxcache/external/1/s3/pcluster-test-fsx-file-cache/from-head-node.txt
```
