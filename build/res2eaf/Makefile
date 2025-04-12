#####################################################################################
dist_dir=$(CURDIR)/deploy
service=res2eaf
version=dev-liepa3
#####################################################################################
########### DOCKER ##################################################################
tag=$(service):$(version)


dbuild:
	# --no-cache --progress=plain 
	docker buildx build -t $(tag) --build-arg BUILD_VERSION=$(version) --build-arg TOOLS_VERSION=$(version) \
		-f Dockerfile ../../

dpush: dbuild
	docker push $(tag)

dscan: dbuild
	docker scan --accept-license $(tag)	
#####################################################################################
.PHONY:
	clean copy build dbuild dpush
