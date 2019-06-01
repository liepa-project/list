#!/bin/bash
###########################################################################################
# Helper script to upload models to kubernetes enviromnment
###########################################################################################
# first: run the script to volume helper container
# : kubectl apply -f helper.yml
# after: run the script to destroy volume helper container
# : kubectl delete deployment vh
###########################################################################################
# no slash at the end!
diarizationModels=/home/airenas/projects/list/volumes/models/diarization  
# slashes at the end required!
kaldiModels=/home/airenas/hdd/list/graph_w63g/
apps=/home/airenas/projects/list/volumes/apps/
###########################################################################################
podName=$(kubectl get po | grep -e '^vh' | head -n 1 | awk '{print $1}')
echo "Pod name = $podName"
if [ "$podName" == "" ] ; then
   echo -e "No pod found!!!\nDid you run: \n\nkubectl apply -f helper.yml ?\n"
   exit 1
fi

###########################################################################################
echo -e "\n\ncopy diarization models = $diarizationModels"
rsync -avurP --blocking-io --rsync-path=/dmodels --rsh="kubectl exec $podName -i -- " $diarizationModels rsync:/dmodels
###########################################################################################
echo -e "\n\ncopy apps = $apps"
rsync -avurP --blocking-io --rsync-path=/apps --rsh="kubectl exec $podName -i -- " $apps rsync:/apps
###########################################################################################
echo -e "\n\ncopy kaldi models = $kaldiModels"
rsync -avurP --blocking-io --rsync-path=/models --rsh="kubectl exec $podName -i -- " $kaldiModels rsync:/models
###########################################################################################
echo -e "\n\nDone.\n\nNow unload helper container:\nkubectl delete deployment vh\n"
###########################################################################################
