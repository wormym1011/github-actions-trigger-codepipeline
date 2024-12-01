#!/bin/sh -l

set -e

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_REGION" ]; then
  echo "AWS credentials and region must be set as environment variables."
  exit 1
fi

export AWS_REGION=$AWS_REGION
export AWS_DEFAULT_REGION=$AWS_REGION

PIPELINE_NAME=$1
BRANCH_OR_TAG=$2

if [ -z "$PIPELINE_NAME" ]; then
  echo "Pipeline name must be provided."
  exit 1
fi

if [ -z "$BRANCH_OR_TAG" ]; then
  echo "Branch or tag must be provided."
  exit 1
fi

# Trigger AWS CodePipeline with parameter overrides
echo "Triggering AWS CodePipeline: $PIPELINE_NAME with branch/tag: $BRANCH_OR_TAG"
EXECUTION_ID=$(aws codepipeline start-pipeline-execution \
  --name "$PIPELINE_NAME" \
  --region "$AWS_REGION" \
  --query 'pipelineExecutionId' --output text)

if [ $? -eq 0 ]; then
  echo "Successfully triggered pipeline. Execution ID: $EXECUTION_ID"
  echo "::set-output name=execution_id::$EXECUTION_ID"
else
  echo "Failed to trigger pipeline."
  exit 1
fi

