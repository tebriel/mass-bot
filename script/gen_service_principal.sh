#!/usr/bin/env bash

set -euo pipefail

SUBSCRIPTION_ID=$(az account show --query id --output tsv)

az ad sp create-for-rbac --name "mass-bot-sp" --role contributor \
    --scopes /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/mass-bot \
    --sdk-auth