require 'aws-sdk-s3'

class DemoController < ApplicationController
  skip_before_action :verify_authenticity_token
  GOOGLE_API_KEY = ENV.fetch("GOOGLE_API_KEY")
  AWS_BUCKET = ENV.fetch("BUCKETEER_BUCKET_NAME")

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
    if stencil == nil
      respond_to do |format|
        format.json { render json: { status: "failed" } }
      end
    else
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
        error: error,
        status: "worked"
      }
      respond_to do |format|
        format.json { render json: answer }
      end
    end
  end

  def upload
    uploaded_file = params["image_input"].tempfile
    bucket = Aws::S3::Bucket.new AWS_BUCKET
    obj = bucket.object(generate_image_name)
    obj.upload_file(uploaded_file)
    presigned_url = obj.presigned_url(:get, expires_in: 3000)

    respond_to do |format|
      format.json { render json: { url: presigned_url } }
    end
  end

  private

  def default_image_url
    request.base_url + "/default.jpg"
  end

  def generate_image_name
    (0...50).map { ('a'..'z').to_a[rand(26)] }.join
  end
end
