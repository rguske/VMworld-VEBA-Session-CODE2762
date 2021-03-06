# VMworld {code} Session CODE2762 - DIY Deployment of Event-Driven Automation in vSphere Environments

This repository includes the demo script I used for my VMworld 2021 {code} session on project VMware Event Broker Appliance, in which I used the `knative_vmware_event_router_install.sh` script to automatically install the core componentes like e.g. Knative (Eventing and Serving) as well as the heart of project VEBA, the Event-Router.

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/ieUqfir5Oag/0.jpg)](https://www.youtube.com/watch?v=ieUqfir5Oag)



## CLI tools used with the script

`kubectl` - [Install](https://kubernetes.io/docs/tasks/tools/)

`figlet` - [Install](https://gist.github.com/zlorb/4a3eff8981fcec8ca1c7)

`lolcat` - [Install](https://gist.github.com/zlorb/4a3eff8981fcec8ca1c7)

## Clone the repository and change into the cloned directory

```
git clone git@github.com:rguske/VMworld-VEBA-Session-CODE2762.git && cd VMworld-VEBA-Session-CODE2762
```

## Adjust the secret as well as the override.yaml files

Adjust the values in the `override.yaml` to meet your environment specifications.

```yaml
eventrouter:
  config:
    logLevel: info
  vcenter:
    address: https://vcsa.jarvis.lab
    username: READ-ONLY-USER
    password: 'SECRETPASSWORD'
    insecure: true
  eventProcessor: knative
  knative:
    destination:
      ref:
        apiVersion: eventing.knative.dev/v1
        kind: Broker
        name: default
        namespace: vmware-functions
 ```
 
 Also, adjust the Slack webhook URL in the `slack_secret.json` file.
 
 ```json
 {
"SLACK_WEBHOOK_URL": "YOUR-SLACK-WEBHOOK-URL"
}
```

## Execute the demo-script

Simply start the demo-script by executing `./knative_vmware_event_router_install.sh` and watch the progress by using `watch` or helpful tools like [k9s](https://github.com/derailed/k9s) or [Octant](https://github.com/vmware-tanzu/octant) for example.

