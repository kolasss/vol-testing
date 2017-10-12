CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

CarrierWave.configure do |config|

  if Rails.env.test? or Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
  elsif Rails.env.production?
    config.fog_provider = 'fog/aws' # required
    config.fog_credentials = {
      provider:              'AWS', # required
      aws_access_key_id:     ENV['S3_KEY'], # required
      aws_secret_access_key: ENV['S3_SECRET'],  # required
      region:                'eu-central-1',  # optional, defaults to 'us-east-1'
      # host:                  's3.example.com',  # optional, defaults to nil
      # endpoint:              'http://volt-test1.s3-website.eu-central-1.amazonaws.com' # optional, defaults to nil
    }
    config.fog_directory  = ENV['S3_BUCKET']  # required
    # config.fog_public     = false # optional, defaults to true
    # config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" } # optional, defaults to {}
    config.storage = :fog
  else
    config.storage = :file
  end
end
