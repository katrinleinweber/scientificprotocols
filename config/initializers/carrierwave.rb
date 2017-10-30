CarrierWave.configure do |config|
  config.cache_dir = "#{Rails.root}/tmp/"
  config.permissions = 0666
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: Rails.configuration.api_aws_access_key_id,
    aws_secret_access_key: Rails.configuration.api_aws_access_key,
  }
  config.fog_directory  = 'scientificprotocols'
  config.storage = :fog
end