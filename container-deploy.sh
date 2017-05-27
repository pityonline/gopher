#!/usr/bin/env bash

export GOOGLE_APPLICATION_CREDENTIALS=${HOME}/account-auth.json
export PATH=${PATH}:/opt/google-cloud-sdk/bin

echo ${GCLOUD_SERVICE_KEY} | base64 --decode -i > ${HOME}/account-auth.json
gcloud auth activate-service-account --key-file=${HOME}/account-auth.json

gcloud -q config set project ${PROJECT_NAME}
gcloud -q config set container/cluster ${CLUSTER_NAME}
gcloud -q config set container/use_client_certificate True
gcloud -q config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud -q container clusters get-credentials ${CLUSTER_NAME}

gcloud docker -- push eu.gcr.io/${PROJECT_NAME}/bot

kubectl --namespace=gopher-slack-bot set image deployment/gopher-slack-bot gopher-slack-bot=eu.gcr.io/gophers-slack-bot/bot:${CIRCLE_SHA1}
