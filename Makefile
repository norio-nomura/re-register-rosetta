TAG:=re-register-rosetta

default: build run

build:
	docker build --platform=linux/arm64 -t ${TAG} .

run:
	docker run --platform=linux/arm64 --privileged --rm ${TAG}
