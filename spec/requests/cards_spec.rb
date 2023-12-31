require 'rails_helper'

RSpec.describe "Cards", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/cards/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /index" do
    it "returns http success" do
      get "/cards/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/cards/show"
      expect(response).to have_http_status(:success)
    end
  end

end
