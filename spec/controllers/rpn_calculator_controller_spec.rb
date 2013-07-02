require 'spec_helper'

describe RpnCalculatorController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'calculate'" do
    it "returns http success" do
      get 'calculate'
      response.should be_success
    end
  end
end
