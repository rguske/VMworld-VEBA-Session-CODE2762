#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${GREEN}\W "

# hide the evidence
clear

# # show kubernetes cluster nodes
# pei "kubectl get nodes -o wide"

# print out kn serving
pei "figlet Knative Serving  | lolcat"

# export knative serving and kn-contour release versions
pei "export KN_SERVING='v0.26.0'"
pei "export KN_CONTOUR='v0.26.0'"

# install knative serving crds and core
pe "kubectl apply -f https://github.com/knative/serving/releases/download/$KN_SERVING/serving-crds.yaml \
    && kubectl apply -f https://github.com/knative/serving/releases/download/$KN_SERVING/serving-core.yaml \
    && kubectl wait deployment --all --timeout=-1s --for=condition=Available -n knative-serving"

# hide the evidence
pe clear

# install contour ingress controller and patch configmap config-network
pe "kubectl apply -f https://github.com/knative/net-contour/releases/download/$KN_CONTOUR/release.yaml"
pe "kubectl patch configmap/config-network --namespace knative-serving --type merge --patch '{\"data\":{\"ingress.class\":\"contour.ingress.networking.knative.dev\"}}' \
    && kubectl wait deployment --all --timeout=-1s --for=condition=Available -n contour-external \
    && kubectl wait deployment --all --timeout=-1s --for=condition=Available -n contour-internal"

# hide the evidence
pe clear

# export necessary variables for the config-domain configmap patch
pe "kubectl get service envoy -n contour-external --output 'jsonpath={.status.loadBalancer.ingress[0].ip}'"
pei "export EXTERNAL_IP=$(kubectl get service envoy -n contour-external --output 'jsonpath={.status.loadBalancer.ingress[0].ip}')"
pei "export KNATIVE_DOMAIN=$EXTERNAL_IP.nip.io"
# pei "dig $KNATIVE_DOMAIN"

# hide the evidence
pe clear

# patch configmap config-domain
pe "kubectl patch configmap -n knative-serving config-domain -p '{\"data\": {\"$KNATIVE_DOMAIN\": \"\"}}'"

# hide the evidence
pe clear

# print out kn-eventing
pei "figlet Knative Eventing  | lolcat"

# export knative eventing release version
pei "export KN_EVENTING=v0.26.0"

# deploy knative eventing core and crds
pe "kubectl apply --filename https://github.com/knative/eventing/releases/download/$KN_EVENTING/eventing-crds.yaml \
    && kubectl apply --filename https://github.com/knative/eventing/releases/download/$KN_EVENTING/eventing-core.yaml \
    && kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing"

# hide the evidence
pe clear

# deploy knative in-memory broker
pe "kubectl apply --filename https://github.com/knative/eventing/releases/download/$KN_EVENTING/in-memory-channel.yaml \
    && kubectl apply --filename https://github.com/knative/eventing/releases/download/$KN_EVENTING/mt-channel-broker.yaml \
    && kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing"

# hide the evidence
pe clear

# create namespace for function
pe "kubectl create ns vmware-functions"

# hide the evidence
pe clear

# create a broker in namespace vmware-functions
pe "kubectl create -f - <<EOF
apiVersion: eventing.knative.dev/v1
kind: Broker
metadata:
  annotations:
    eventing.knative.dev/broker.class: MTChannelBasedBroker
  name: default
  namespace: vmware-functions
spec:
  config:
    apiVersion: v1
    kind: ConfigMap
    name: config-br-default-channel
    namespace: knative-eventing
EOF"

# hide the evidence
pe clear

# print out event-router
pei "figlet Event-Router  | lolcat"

# create the override.yaml file for the vmware event router deployment
pe "cat << EOF > override.yaml
eventrouter:
  config:
    logLevel: info
  vcenter:
    address: https://vcsa.jarvis.lab
    username: veba-ro@jarvis.lab
    password: 'VMware1!'
    insecure: true
  eventProcessor: knative
  knative:
    destination:
      ref:
        apiVersion: eventing.knative.dev/v1
        kind: Broker
        name: default
        namespace: vmware-functions
EOF"

# hide the evidence
pe clear

# helm search; for available vmware-veba versions
pe "helm search repo vmware-veba -l"

# install the vmware event router via helm
pe "helm install -n vmware-system --create-namespace veba-knative vmware-veba/event-router -f override.yaml --wait"

# hide the evidence
pe clear

# print out function example
pei "figlet Slack Function  | lolcat"

# create kn-ps-slack function secret
pe "kubectl -n vmware-functions create secret generic slack-secret --from-file=SLACK_SECRET=slack_secret.json"

# take a look at the trigger config
pe "cat function.yaml"

# hide the evidence
pe clear

# create the kn-ps-slack function
pe "kubectl -n vmware-functions apply -f function.yaml"

# hide the evidence
pe clear

# ensure a VM is running
p "VM is running?"

# stop the running VM
p "Show function log and powerOff the running VM"

# hide the evidence
clear

# end demo
pei "figlet event-driven rockzz  | lolcat"

# wait max 3 seconds until user presses
PROMPT_TIMEOUT=3
wait