#!/bin/bash
set -e

echo "Executing $0"
sudo touch /opt/slurm/etc/plugstack.conf.d/sed-mgiacomo-2
sudo chmod 000 /opt/slurm/etc/plugstack.conf.d/sed-mgiacomo-2