##
# Gocart
#
# @file
# @version 0.1
include .envrc
.DEFAULT_GOAL := build
.PHONY:vet run clean tidy db/migrations/new db/migrations/up db/psql

# ==================================================================================== #
# HELPERS
# ==================================================================================== #
## help: print this help message
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

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

## db/psql: connect to the database using psql
db/psql:
	psql ${GOCART_DB_DSN}

## db/migrations/new name=$1: create a new database migration
db/migrations/new:
	@echo 'Creating migrationfiles for ${name}'
	migrate create -seq -ext .sql -dir=./migrations ${name}

## db/migrations/up: apply all up database migrations
db/migrations/up: confirm
	@echo 'Running up migrations'
	migrate -path=./migrations -database=${GOCART_DB_DSN} up
##
## db/migrations/up: apply all up database migrations
db/migrations/down: confirm
	@echo 'Running down migrations'
	migrate -path=./migrations -database=${GOCART_DB_DSN} down

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## tidy: tidy and verify dependencies
tidy:
	@echo 'Tidying and verifying module dependencies...'
	go mod tidy
	go mod verify

# end
