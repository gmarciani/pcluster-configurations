```
for n in {1..500}; do echo "Job Round: $n";sbatch -N 2 -p "queue-1" --exclusive --wrap "srun hostname;sleep 30000"; done
```

```
sbatch -p "queue-1" --array [1-1000] --exclusive --wrap "srun hostname;sleep 30000"
```

```
sbatch -N 2 -p "queue-0" -w queue-0-dy-compute-resource-0-[1-1000] --exclusive --wrap "srun hostname;sleep 30000"
```


```
scancel {1..500}
```

````
/opt/parallelcluster/pyenv/versions/cookbook_virtualenv/bin/supervisorctl status
/opt/parallelcluster/pyenv/versions/cookbook_virtualenv/bin/supervisorctl restart clustermgtd
````

```
aws ec2 modify-launch-template --launch-template-id "lt-02d56dde862307561" --default-version "7" --region "eu-west-1"
aws ec2 modify-launch-template --launch-template-id "lt-03918baf2c4390290" --default-version "7" --region "eu-west-1"
aws ec2 modify-launch-template --launch-template-id "lt-09fffd55d9c977955" --default-version "7" --region "eu-west-1"
```

```
echo "COOKBOOK-FAILURE"
aws ec2 describe-instances --region eu-west-1 --filter "Name=tag:QUARANTINE-REASON,Values=COOKBOOK-FAILURE" --query "Reservations[].Instances[].InstanceId" --output text

echo "COOKBOOK-TIMEOUT"
aws ec2 describe-instances --region eu-west-1 --filter "Name=tag:QUARANTINE-REASON,Values=COOKBOOK-TIMEOUT" --query "Reservations[].Instances[].InstanceId" --output text

echo "TerminatedBySlurm:_terminate_orphaned_instances"
aws ec2 describe-instances --region eu-west-1 --filter "Name=tag:QUARANTINE-REASON,Values=TerminatedBySlurm:_terminate_orphaned_instances" --query "Reservations[].Instances[].InstanceId" --output text

echo "TerminatedBySlurm:_handle_powering_down_nodes"
aws ec2 describe-instances --region eu-west-1 --filter "Name=tag:QUARANTINE-REASON,Values=TerminatedBySlurm:_handle_powering_down_nodes" --query "Reservations[].Instances[].InstanceId" --output text

echo "TerminatedBySlurm:_handle_unhealthy_dynamic_nodes"
aws ec2 describe-instances --region eu-west-1 --filter "Name=tag:QUARANTINE-REASON,Values=TerminatedBySlurm:_handle_unhealthy_dynamic_nodes" --query "Reservations[].Instances[].InstanceId" --output text
```

```
sudo ethtool -S eth0 | grep "linklocal_allowance_exceeded" | cut -d ':' -f 2
```

instances=( $(aws ec2 describe-instances --region eu-west-1 --filter "Name=instance-state-name,Values=stopped" --query "Reservations[].Instances[].InstanceId" --output text) )
for instance in $instances; do
echo "Processing: $instance"
aws ec2 modify-instance-attribute --region eu-west-1 --instance-id $instance --no-disable-api-termination
aws ec2 terminate-instances --region eu-west-1 --instance-ids $instance
done


sudo yum install amazon-cloudwatch-agent
vim /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status
tail -f /var/log/amazon/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log

nping -c 10000  --delay 0.01ms 169.254.169.254



From clustermgtd

```
tail -f /var/log/parallelcluster/clustermgtd | grep "Found the following bootstrap failure nodes"
```

```
2023-08-03 16:19:45,799 - [slurm_plugin.clustermgtd:_handle_bootstrap_failure_nodes] - WARNING - Found the following bootstrap failure nodes

2023-08-03 16:20:37,730 - [slurm_plugin.clustermgtd:_maintain_nodes] - INFO - Following nodes are currently in replacement: (x1) ['queue-0-st-compute-resource-0-375']

```

mkdir -p third-party/selinux 
wget -O third-party/selinux.tar.gz https://github.com/sous-chefs/selinux/archive/refs/tags/6.1.12.tar.gz
tar xzf third-party/selinux.tar.gz -C third-party/selinux --strip-components 1
rm third-party/selinux.tar.gz


curl -sSL https://get.rvm.io | bash
source /etc/profile.d/rvm.sh
rvm --version
rvm install 3.2.2
gem install chef-bin:17.2.29 --clear-sources -s https://packagecloud.io/cinc-project/stable -s https://rubygems.org
gem install berkshelf:7.2.0
cd /etc/chef
cinc-client --local-mode --config /etc/chef/client.rb --log_level info --logfile /var/log/chef-client.log --force-formatter --no-color --chef-zero-port 8889 --json-attributes /etc/chef/dna.json --override-runlist aws-parallelcluster-entrypoints::init