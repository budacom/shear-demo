class DemoController < ApplicationController
  GOOGLE_API_KEY = ENV.fetch("GOOGLE_API_KEY")

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

  private

  def process_image
    word_collection = Guillotine::WordCollection.build_from_url image_url, GOOGLE_API_KEY
    stencil = DrivingLicenceStencil.match word_collection
    @read_values = {
      license_class: stencil.license_class,
      number: stencil.number,
      municipality: stencil.municipality,
      names: stencil.names,
      surnames: stencil.surnames,
      adress: stencil.adress,
      issue_date: stencil.issue_date,
      expiration_date: stencil.expiration_date
    }
    @transform = stencil.match.transform
    @error = stencil.match.error
  end

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
