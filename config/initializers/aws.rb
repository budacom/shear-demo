aws_config = {
  region: ENV.fetch('BUCKETEER_AWS_REGION'),
  credentials: Aws::Credentials.new(
    ENV.fetch('BUCKETEER_AWS_ACCESS_KEY_ID'), ENV.fetch('BUCKETEER_AWS_SECRET_ACCESS_KEY')
  )
}

if Rails.env.development? || Rails.env.test?
  aws_config.update(
    endpoint: "http://#{ENV.fetch('MINIO_HOST')}:#{ENV.fetch('MINIO_PORT')}",
    force_path_style: true
  )
end

Aws.config.update aws_config
