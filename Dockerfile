FROM --platform=linux/amd64 alpine:edge as BUILD
RUN apk update && apk add build-base
COPY cat.c ./
RUN cc -Wall -static cat.c -o /usr/bin/cat

FROM alpine:edge
COPY --from=BUILD /usr/bin/cat /usr/bin/cat
COPY re-register-rosetta.sh /usr/bin/re-register-rosetta.sh
ENTRYPOINT ["/usr/bin/re-register-rosetta.sh"]
