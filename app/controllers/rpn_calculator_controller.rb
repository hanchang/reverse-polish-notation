class RpnCalculatorController < ApplicationController
  OPERATORS = %w[+ - * / ^ %]
  ERROR_MESSAGE = "The input expression '%s' is invalid and cannot be parsed."

  def index
  end

  def calculate
    if params[:input].blank?
      @output = 'You must enter inputs to calculate.'
    else
      @output = ''
      stack = []
      params[:input].split(' ').each do |token|
        if is_operator?(token)
          if stack.length < min_operator_length(token)
            @output = ERROR_MESSAGE % params[:input]
          else
            val1 = stack.pop()
            val2 = stack.pop()
            token = '**' if token == '^'
            result = val2.send(token, val1)
            @output << "#{val2} #{token} #{val1} = #{result}\n"
            stack.push(result)
          end
        elsif is_value?(token)
          stack.push(Integer(token))
        else
          @output = nil
          break
        end
      end

      if stack.length == 1 and @output
        @output << "Answer: #{stack.pop()}"
      else
        @output = ERROR_MESSAGE % params[:input]
      end
    end

    respond_to do |format|
      format.text { render :text => @output }
      format.html # index.html.haml
    end
  end

  private

  # Seems like regular expressions are the best solution.
  def is_value?(token)
    token.strip.match(/^-?\d+$/) ? true : false
  end

  def is_operator?(token)
    # TODO: Try using metaprogramming via send() to allow any valid Ruby operator.
    OPERATORS.include?(token) ? true : false
  end

  def min_operator_length(token)
    # Right now each valid operator takes 2 arguments; 
    # there are operators that only take one (factorial, for example).
    case token
    when *OPERATORS
      2
    else
      0 # Compared against stack length, this will always yield error.
    end
  end
end
