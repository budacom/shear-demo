require 'rails_helper'

RSpec.describe "Demos", type: :request do
  describe "GET /" do
    it "home routes to DemoController#index" do
      assert_recognizes({ controller: "demo", action: "index" }, { method: "get", path: "/" })
    end
  end
end
