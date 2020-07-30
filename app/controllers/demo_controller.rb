require 'aws-sdk-s3'

class DemoController < ApplicationController
  GOOGLE_API_KEY = ENV.fetch("GOOGLE_API_KEY")
  MINIO_ACCESS_KEY = ENV.fetch("MINIO_ACCESS_KEY")
  MINIO_SECRET_KEY = ENV.fetch("MINIO_SECRET_KEY")
  MINIO_HOST = ENV.fetch("MINIO_HOST")
  MINIO_PORT = ENV.fetch("MINIO_PORT")
  MINIO_BUCKET = ENV.fetch("MINIO_BUCKET")

  def index
    @read_values = {}
    @transform = [
      [1, 0, 0],
      [0, 1, 0],
      [0, 0, 1]
    ]
    @error = nil
    @image_url = image_url
  end

  def process_image
    word_collection = Guillotine::WordCollection.build_from_url image_url, GOOGLE_API_KEY
    stencil = DrivingLicenceStencil.match word_collection
    read_values = {
      license_class: stencil.license_class,
      number: stencil.number,
      municipality: stencil.municipality,
      names: stencil.names,
      surnames: stencil.surnames,
      adress: stencil.adress,
      issue_date: stencil.issue_date,
      expiration_date: stencil.expiration_date
    }
    transform = stencil.match.transform
    error = stencil.match.error
    answer = {
      read_values: read_values,
      transform: transform,
      error: error
    }
    respond_to do |format|
      format.json { render json: answer }
    end
  end

  def test_minio_bucket_access
    Aws.config.update(
      endpoint: "http://#{MINIO_HOST}:#{MINIO_PORT}",
      access_key_id: MINIO_ACCESS_KEY,
      secret_access_key: MINIO_SECRET_KEY,
      force_path_style: true,
      region: 'us-east-1'
    )

    bucket = Aws::S3::Bucket.new MINIO_BUCKET
    bucket.objects.each do |o|
      puts o.key
    end
  end

  private

  def image_url
    upload_image_url.presence || default_image_url
  end

  def upload_image_url
    nil
  end

  def default_image_url
    "https://opcionis.cl/blog/wp-content/uploads/2017/02/licencia-de-conducir-chile.jpg"
  end
end
