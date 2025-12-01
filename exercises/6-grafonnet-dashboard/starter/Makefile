# Makefile for Grafana dashboard management

JSONNET := /usr/local/bin/jsonnet
GRAFANA_URL := http://localhost:3000
VENDOR_DIR := vendor

# Command line options
# Usage: make build DASHBOARD_SRC=my-dashboard.jsonnet
DASHBOARD_SRC ?= workshop-dashboard.jsonnet
DASHBOARD_OUT := $(DASHBOARD_SRC:.jsonnet=.json)
GRAFANA_PASSWORD ?= 

.PHONY: all build deploy clean help

all: build

## Build the dashboard JSON from jsonnet source
build:
	$(JSONNET) -J $(VENDOR_DIR) $(DASHBOARD_SRC) -o $(DASHBOARD_OUT)

## Deploy dashboard to Grafana (requires GRAFANA_PASSWORD)
deploy: build
ifndef GRAFANA_PASSWORD
	$(error GRAFANA_PASSWORD is not set. Usage: make deploy GRAFANA_PASSWORD=yourpassword)
endif
	@curl -s -X POST \
		-H 'Content-Type: application/json' \
		-d '{"dashboard": $(shell jq . $(DASHBOARD_OUT)), "overwrite": true}' \
		"http://admin:$(GRAFANA_PASSWORD)@localhost:3000/api/dashboards/db" | jq .

## Remove generated files
clean:
	rm -f *.json

## Show available targets
help:
	@echo "Available targets:"
	@echo "  build   - Compile jsonnet to JSON"
	@echo "  deploy  - Push dashboard to Grafana (requires GRAFANA_PASSWORD)"
	@echo "  clean   - Remove generated files"
	@echo ""
	@echo "Options:"
	@echo "  DASHBOARD_SRC    - Source jsonnet file (default: workshop-dashboard.jsonnet)"
	@echo "  GRAFANA_PASSWORD - Grafana admin password (required for deploy)"
	@echo ""
	@echo "Usage examples:"
	@echo "  make build"
	@echo "  make build DASHBOARD_SRC=other-dashboard.jsonnet"
	@echo "  make deploy DASHBOARD_SRC=my-dashboard.jsonnet GRAFANA_PASSWORD=secret"