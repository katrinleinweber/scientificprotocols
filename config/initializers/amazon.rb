credentials = Aws::Credentials.new(
  Rails.configuration.api_aws_access_key_id,
  Rails.configuration.api_aws_access_key
)
S3_ACCOUNT = Aws::S3::Client.new(
  credentials: credentials,
  region: 'us-west-2'
)
