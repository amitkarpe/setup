#!/bin/bash

sudo /opt/splunkforwarder/bin/splunk --version | grep build
sudo /opt/nessus_agent/bin/nasl -v | grep Agent
rpm -qa | grep -E 'splunk|nessus|ds_agent|amazon-cloudwatch-agent'


