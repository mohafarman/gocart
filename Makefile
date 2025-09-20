##
# Gocart
#
# @file
# @version 0.1
include .envrc
.DEFAULT_GOAL := build
.PHONY:vet run clean tidy

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #
vet:
	go vet ./...

## run: run the cmd/api application
run: vet
	@go build -o out ./cmd/api/ && ./out -db-dsn=${GOCART_DB_DSN}

clean:
	go clean -x

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## tidy: tidy and verify dependencies
tidy:
	@echo 'Tidying and verifying module dependencies...'
	go mod tidy
	go mod verify

# end
