# Trigger AWS CodePipeline

This GitHub Action triggers an AWS CodePipeline execution with a specific branch or tag.

## Inputs

- `pipeline_name` (Required): The name of the AWS CodePipeline to trigger.
- `branch_or_tag` (Required): The branch or tag to use for the pipeline source.

## Outputs

- `execution_id`: The execution ID of the triggered pipeline.

## Example Usage

```yaml
jobs:
  trigger-pipeline:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger AWS CodePipeline
        uses: your-username/trigger-codepipeline-action@v1
        with:
          pipeline_name: 'your-pipeline-name'
          branch_or_tag: 'main' # Required input
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: 'ap-southeast-1'

