#!/bin/bash
#
# Sets up the kernel with the requirements for running Kubernetes
# Requires a reboot, which is carried out by the vagrant provisioner.
 
echo "source <(kubectl completion bash)" >> ~/.bashrc 
echo "alias k=kubectl" >> ~/.bashrc 
echo "complete -o default -F __start_kubectl k" >> ~/.bashrc
