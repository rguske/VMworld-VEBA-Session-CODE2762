kn broker delete default -n vmware-functions && helm uninstall veba-knative -n vmware-system

export KN_CONTOUR='v0.26.0' \
export KN_SERVING='v0.26.0' \
export KN_EVENTING=v0.26.0

kubectl delete -f https://github.com/knative/serving/releases/download/$KN_SERVING/serving-crds.yaml && kubectl delete -f https://github.com/knative/serving/releases/download/$KN_SERVING/serving-core.yaml && kubectl delete -f https://github.com/knative/net-contour/releases/download/$KN_CONTOUR/release.yaml && kubectl delete --filename https://github.com/knative/eventing/releases/download/$KN_EVENTING/eventing-crds.yaml && kubectl delete --filename https://github.com/knative/eventing/releases/download/$KN_EVENTING/mt-channel-broker.yaml && kubectl delete --filename https://github.com/knative/eventing/releases/download/$KN_EVENTING/in-memory-channel.yaml && kubectl delete ns vmware-functions