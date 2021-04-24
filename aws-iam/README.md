# AWS IAM

```bash
# extract access key id + secret from state
tf show -json | jq '{ aws_access_key_id: .values.outputs.access_key_id.value, aws_secret_access_key: .values.outputs.access_key_secret.value }'

# Copy secret to clipboard
tf show -json | jq .values.outputs.access_key_secret.value | tr -d '"' | xclip -selection clipboard
```
