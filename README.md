# re-register-rosetta

This script is used to re-register Rosetta in case it is not correctly registered to Docker Desktop for Mac. ([docker/for-mac#7058](https://github.com/docker/for-mac/issues/7058))

## Usage

```bash
docker run --platform=linux/arm64 --privileged --rm ghcr.io/norio-nomura/re-register-rosetta
```
