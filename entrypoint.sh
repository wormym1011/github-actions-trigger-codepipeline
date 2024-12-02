#!/bin/sh -l

echo "Inputs and Environment Variables:"
env

PIPELINE_NAME=$1
BRANCH_OR_TAG=$2

echo "Pipeline Name: $PIPELINE_NAME"
echo "Branch or Tag: $BRANCH_OR_TAG"

if [ -z "$PIPELINE_NAME" ]; then
  echo "Pipeline name must be provided."
  exit 1
fi

if [ -z "$BRANCH_OR_TAG" ]; then
  echo "Branch or tag must be provided."
  exit 1
fi

# Trigger the AWS CodePipeline
aws codepipeline start-pipeline-execution \
  --name "$PIPELINE_NAME" \
  --query 'pipelineExecutionId' \
  --region "$AWS_REGION" \
  --output text

if [ $? -eq 0 ]; then
  echo "Successfully triggered pipeline. Execution ID: $EXECUTION_ID"
  echo "::set-output name=execution_id::$EXECUTION_ID"
else
  echo "Failed to trigger pipeline."
  exit 1
fi

