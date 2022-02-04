#!/usr/bin/env bash

project="$1"
region="$2"

if [ -z "$project" ] || [ -z "$region" ]; then
	echo "usage:  $0 <gcp project> <gcp region>"
	exit 1;
fi

for cluster in $(gcloud container clusters list --project "$project" --region="$region" --format='value(name)'); do
	gcloud container clusters get-credentials "$cluster" --project "$project" --region "$region"
done
