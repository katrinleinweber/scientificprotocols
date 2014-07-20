S3_ACCOUNT = AWS::S3.new(
  access_key_id: Rails.configuration.api_aws_access_key_id,
  secret_access_key: Rails.configuration.api_aws_access_key
)