#!/usr/bin/env bash

project="$1"
region="us-central1"

if [ -z "$project" ]; then
	echo "usage:  $0 <gcp project>"
	exit 1;
fi

for cluster in $(gcloud container clusters list --project "$project" --format='value(name)'); do
	gcloud container clusters get-credentials "$cluster" --project "$project" --region "$region"
done
