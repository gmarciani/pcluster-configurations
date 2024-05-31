# Storage Commands

## FSxLustre

### Root Squash

To retrieve root squash configuration:

```
aws fsx describe-file-systems \
  --file-system-ids fs-123 \
  --region eu-west-1 | jq -c '.[][0] | .LustreConfiguration'
```


To enable root squash:

```
aws fsx update-file-system \
  --file-system-id fs-008f19a2d5b694563 \
  --lustre-configuration RootSquashConfiguration={RootSquash="0:0", NoSquashNids=[]} \
  --region eu-west-1
```

To enable root squash with some excluded Lustre Network Identifiers (NIDs):
```
aws fsx update-file-system \
  --file-system-id fs-008f19a2d5b694563 \
  --lustre-configuration RootSquashConfiguration={RootSquash="0:4294967294", NoSquashNids=["10.216.123.47@tcp", "10.216.12.176@tcp"]} \
  --region eu-west-1
```

To disable root squash:

```
aws fsx update-file-system \
  --file-system-id fs-008f19a2d5b694563 \
  --lustre-configuration RootSquashConfiguration={RootSquash="0:0", NoSquashNids=[]} \
  --region eu-west-1
```