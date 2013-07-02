require 'spec_helper'

describe RpnCalculatorController do
  render_views

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
      response.should contain('Reverse Polish Notation Calculator')
    end
  end

  describe "GET 'calculate'" do
    it "returns http success with input present" do
      get 'calculate', input: '1 1 +'
      response.should be_success
      response.should contain('Calculation Results')
    end

    it "handles missing input" do
      get 'calculate'
      response.should redirect_to(root_path)
    end

    it "calculates addition" do
      get 'calculate', input: '1 1 +'
      response.body.should contain('Answer: 2')
    end

    it "calculates addition with negative integers" do
      get 'calculate', input: '1 -1 +'
      response.body.should contain('Answer: 0')
    end

    it "calculates subtraction" do
      get 'calculate', input: '1 1 -'
      response.body.should contain('Answer: 0')
    end

    it "calculates subtraction in the correct order" do
      get 'calculate', input: '3 1 -'
      response.body.should contain('Answer: 2')
    end

    it "calculates multiplication" do
      get 'calculate', input: '2 3 *'
      response.body.should contain('Answer: 6')
    end

    it "calculates multiplication with negative integers" do
      get 'calculate', input: '-2 3 *'
      response.body.should contain('Answer: -6')
    end

    it "calculates integer division" do
      get 'calculate', input: '5 2 /'
      response.body.should contain('Answer: 2')
    end

    it "calculates integer division in the correct order" do
      get 'calculate', input: '2 5 /'
      response.body.should contain('Answer: 0')
    end

    it "calculates modulo division" do
      get 'calculate', input: '8 5 %'
      response.body.should contain('Answer: 3')
    end

    it "calculates modulo division in the correct order" do
      get 'calculate', input: '5 8 %'
      response.body.should contain('Answer: 5')
    end

    it "calculates regardless of whitespace" do
      get 'calculate', input: ' 1   1     + '
      response.body.should contain('Answer: 2')
    end

    it "gives an error message on random strings" do
      get 'calculate', input: 'Daft Punk - Random Access Memories'
      response.body.should contain('is invalid')
    end

    it "gives an error message on only numbers" do
      get 'calculate', input: '1 1 2 3 5 8'
      response.body.should contain('is invalid')
    end

    it "gives an error message on only operators" do
      get 'calculate', input: '+ + + + +'
      response.body.should contain('is invalid')
    end

    it "gives an error message on infix input order" do
      get 'calculate', input: '1 + 1'
      response.body.should contain('is invalid')
    end

    it "gives an error message on missing postfix argument" do
      get 'calculate', input: '1 +'
      response.body.should contain('is invalid')
    end

    it "gives an error message on invalid postfix argument with extra operators" do
      get 'calculate', input: '1 1 + +'
      response.body.should contain('is invalid')
    end

    it "gives an error message on invalid postfix argument with extra values" do
      get 'calculate', input: '1 1 1 +'
      response.body.should contain('is invalid')
    end

    # Courtesy of http://csserver.evansville.edu/~acm/progcont/2011/testcases.html
    it "calculates 5 1 2 + 4 * 3 - +" do
      get 'calculate', input: '5 1 2 + 4 * 3 - +'
      response.body.should contain('Answer: 14')
    end

    it "calculates 42 3 * 15 + 6 5 - *" do
      get 'calculate', input: '42 3 * 15 + 6 5 - *'
      response.body.should contain('Answer: 141')
    end

    it "calculates 5 17 - 52 8 9 6 7 * + - + *" do
      get 'calculate', input: '5 17 - 52 8 9 6 7 * + - + *'
      response.body.should contain('Answer: -108')
    end
  end

  # These are tests of private methods, which is usually bad since
  # it's testing things that aren't publicly facing.
  # However, for this project I deemed it an acceptable practice,
  # since in a real project this logic would most likely go into
  # a model object that can be more thoroughly unit tested.
 
  describe "#is_value?" do
    @controller = RpnCalculatorController.new

    it 'returns true on integers represented as strings' do
      %w[-1 0 1 42 -999].each do |val|
        @controller.send(:is_value?, val).should be_true
      end
    end

    it 'returns false on all other strings' do
      %w[- a A xy XX -999a ' '' """ why?].each do |val|
        @controller.send(:is_value?, val).should be_false
      end
    end

    it 'returns false on whitespace strings' do
      [' ', '  ', "\n", "\t"].each do |val|
        @controller.send(:is_value?, val).should be_false
      end
    end
  end

  describe "#is_operator?" do
    @controller = RpnCalculatorController.new

    it 'returns true on valid operators' do
      RpnCalculatorController::OPERATORS.each do |op|
        @controller.send(:is_operator?, op).should be_true
      end
    end

    it 'returns false on all other strings' do
      %w[-- a A xy XX -999a ' '' """ why?].each do |val|
        @controller.send(:is_operator?, val).should be_false
      end
    end

    it 'returns false on whitespace strings' do
      [' ', '  ', "\n", "\t"].each do |val|
        @controller.send(:is_value?, val).should be_false
      end
    end
  end
end
