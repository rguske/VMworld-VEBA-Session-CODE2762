# VMworld {code} Session CODE2762 - DIY Deployment of Event-Driven Automation in vSphere Environments

This repository includes the demo script I used for my VMworld 2021 {code} session on project VMware Event Broker Appliance, in which I used the `knative_vmware_event_router_install.sh` script to automatically install the core componentes like e.g. Knative (Eventing and Serving) as well as the heart of project VEBA, the Event-Router.

## Clone the repository and change into the cloned directory

```
git clone git@github.com:rguske/VMworld-VEBA-Session-CODE2762.git && cd VMworld-VEBA-Session-CODE2762
```

## Execute the demo-script

Simply start the demo-script by executing `./knative_vmware_event_router_install.sh` and watch the progress with e.g. using `watch` or helpful tools like [k9s](https://github.com/derailed/k9s) or [Octant](https://github.com/vmware-tanzu/octant).

