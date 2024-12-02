#!/bin/sh -l

PIPELINE_NAME=$1
BRANCH_OR_TAG=$2
TIMEOUT=900 # Timeout in seconds (15 minutes)

if [ -z "$PIPELINE_NAME" ]; then
  echo "Error: Pipeline name must be provided."
  exit 1
fi

if [ -z "$BRANCH_OR_TAG" ]; then
  echo "Error: Branch or tag must be provided."
  exit 1
fi

echo "Triggering AWS CodePipeline: $PIPELINE_NAME with branch/tag: $BRANCH_OR_TAG"

# Trigger AWS CodePipeline
EXECUTION_ID=$(aws codepipeline start-pipeline-execution \
  --name "$PIPELINE_NAME" \
  --query 'pipelineExecutionId' \
  --region "$AWS_REGION" \
  --output text 2>&1)

if [ $? -ne 0 ]; then
  echo "Error triggering CodePipeline: $EXECUTION_ID"
  exit 1
fi

echo "Pipeline triggered successfully. Execution ID: $EXECUTION_ID"

# Start polling for pipeline status
STATUS="InProgress"
START_TIME=$(date +%s)

while [ "$STATUS" = "InProgress" ]; do
  echo "Checking pipeline status..."
  STATUS=$(aws codepipeline get-pipeline-execution \
    --pipeline-name "$PIPELINE_NAME" \
    --pipeline-execution-id "$EXECUTION_ID" \
    --query 'pipelineExecution.status' \
    --region "$AWS_REGION" \
    --output text 2>&1)

  if [ $? -ne 0 ]; then
    echo "Error checking pipeline status: $STATUS"
    exit 1
  fi

  echo "Current status: $STATUS"

  if [ "$STATUS" = "Succeeded" ]; then
    echo "Pipeline execution succeeded."
    exit 0
  elif [ "$STATUS" = "Failed" ]; then
    echo "Pipeline execution failed."
    exit 1
  fi

  # Check if timeout has been reached
  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
  if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
    echo "Pipeline execution timed out after 15 minutes."
    exit 1
  fi

  sleep 30 # Wait before checking again
done

