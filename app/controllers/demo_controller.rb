class DemoController < ApplicationController
  GOOGLE_API_KEY = ENV.fetch("GOOGLE_API_KEY")

  attr_reader :license_class, :number, :municipality, :names, :surnames, :adress, :issue_date
  attr_reader :expiration_date, :transform, :error

  def index
    puts "I'm in the home page!"
  end

  private

  def process_image
    word_collection = Guillotine::WordCollection.build_from_url image_url, GOOGLE_API_KEY
    stencil = DrivingLicenceStencil.match word_collection
    @license_class = stencil.license_class
    @number = stencil.number
    @municipality = stencil.municipality
    @names = stencil.names
    @surnames = stencil.surnames
    @adress = stencil.adress
    @issue_date = stencil.issue_date
    @expiration_date = stencil.expiration_date
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
    "https://upload.wikimedia.org/wikipedia/commons/f/fe/El_ejemplo_de_Cedula_identidad_Chile_2013.jpg"
  end
end
