.PHONY: build build-arm

build:
	go build -ldflags="-s -w" -o ~/repo/blocky/blocky github.com/0xERR0R/blocky

build-arm:
	GOOS=linux GOARCH=arm64 go build -ldflags="-s -w" -o ./blocky-arm github.com/0xERR0R/blocky
