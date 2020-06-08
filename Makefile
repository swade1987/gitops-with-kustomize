CURRENT_WORKING_DIR=$(shell pwd)
TOOLKIT_IMAGE := eu.gcr.io/swade1987/kubernetes-toolkit:1.17.2

init:
	brew install k3d

cluster:
	k3d create cluster --workers 4 --name gitops

destroy:
	k3d delete --name="gitops"

install-flux:
	./scripts/flux-init.sh

check-duplicate-release-name:
	clear
	docker run --rm --name check-duplicate-release-name -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/check-duplicate-release-name`"

kubeval-environments:
	clear
	docker run --rm --name kubeval-environments -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/kubeval-each-environment`"

hrval-environments:
	clear
	docker run --rm --name hrval-environments -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/kubeval-each-environment`"

deprek8-check:
	clear
	docker run --rm --name kubeval-charts -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/deprek8s-check`"

kustomization-yaml-fix:
	docker run --rm --name kustomization-yaml-fix -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) kustomization-yaml-fix /kustomize

test-%:
	mkdir -p _test
	kustomize build kustomize/$* > _test/$*.yaml
	@echo
	@echo The output can be found at _test/$*.yaml
