require 'aws-sdk-s3'

class DemoController < ApplicationController
  skip_before_action :verify_authenticity_token
  GOOGLE_API_KEY = ENV.fetch("GOOGLE_API_KEY")
  MINIO_ACCESS_KEY = ENV.fetch("MINIO_ACCESS_KEY")
  MINIO_SECRET_KEY = ENV.fetch("MINIO_SECRET_KEY")
  MINIO_HOST = ENV.fetch("MINIO_HOST")
  MINIO_PORT = ENV.fetch("MINIO_PORT")
  MINIO_BUCKET = ENV.fetch("MINIO_BUCKET")

  def index
    @read_values = {}
    @error = nil
    if flash[:image_url]
      @displayed_image = flash[:image_url]
    else
      @displayed_image = default_image_url
    end
  end

  def process_image
    word_collection = Guillotine::WordCollection.build_from_url params[:image_url], GOOGLE_API_KEY
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

  def upload
    uploaded_file = params["image_input"].tempfile
    Aws.config.update(
      endpoint: "http://#{MINIO_HOST}:#{MINIO_PORT}",
      access_key_id: MINIO_ACCESS_KEY,
      secret_access_key: MINIO_SECRET_KEY,
      force_path_style: true,
      region: 'us-east-1'
    )
    bucket = Aws::S3::Bucket.new MINIO_BUCKET
    obj = bucket.object('image.png')
    obj.upload_file(uploaded_file)
    presigned_url = obj.presigned_url(:get, expires_in: 3000)

    respond_to do |format|
      format.json { render json: { url: presigned_url } }
    end
  end

  private

  def default_image_url
    "https://opcionis.cl/blog/wp-content/uploads/2017/02/licencia-de-conducir-chile.jpg"
  end
end
