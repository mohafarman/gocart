##
# Gocart
#
# @file
# @version 0.1

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #
vet:
	go vet ./...

## run: run the cmd/api application
run: vet
	@go build ./cmd/api/ && ./api

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
