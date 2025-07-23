#!/bin/bash

user=$(stat -f "%Su" /dev/console)
userEmail=$(echo "$user""@domainhere.com")


/usr/local/bin/jamf recon -endUsername $userEmail