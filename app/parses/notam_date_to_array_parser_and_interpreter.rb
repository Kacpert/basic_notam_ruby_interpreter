class NotamDateToArrayParserAndInterpreter
  def initialize text
    @errors = nil
    # @tokens = ["MON", "0500", "-", "2000", "TUE", "-", "THU", "0500", "-", "2100", "FRI", "0545", "-", "2100", "SAT0630", "-", "0730", "1900", "-", "2100", "SUN", "1215", "-", "2000"]
    @tokens = text.gsub(/[\\n,:\.]/, " ").gsub("-", " - ").split(" ")
    @parser_result = []
  end

  def interprate_and_return_result(token = next_token)
    return @errors || @parser_result unless token
    first_day = parse_day_to_integer token
    second_token = next_token
    if second_token == "-"
      find_the_amount_and_fill_parser_result_from(first_day)
    else
      fill_parser_result_by(second_token)
    end
    
  end

  def find_the_amount_and_fill_parser_result_from(first_day)
    second_day = parse_day_to_integer(next_token)
    ammount = second_day - first_day + 1
    fill_parser_result_by(next_token, ammount: ammount)
  end

  def fill_parser_result_by(token, ammount: 1)
    if token == "CLOSED" || token == "CLSD"
      @parser_result += [token] * ammount 
      interprate_and_return_result
    else
      value = ""
      while (token =~ /^\d\d\d\d$/)
        value += (token + next_token + next_token + "</br>")
        token = next_token
      end
      ammount.times{@parser_result.push(value.chomp("</br>"))}
      interprate_and_return_result(token)
    end
  end

  def next_token
    @tokens.shift
  end

  def parse_day_to_integer token
    token = fix_whitespace_in token
    case token.upcase
      when "MON" then 1
      when "TUE" then 2
      when "WED" then 3
      when "THU" then 4
      when "FRI" then 5
      when "SAT" then 6
      when "SUN" then 7
      else
        @errors = ["system found", "syntax error", "in that NOTAM", "'#{token}'", "is not" , "represents","a day"]
        0
    end
  end

# "SAT0630" => ["SAT", 0630]
  def fix_whitespace_in token
    if token.length > 3
      new_token = token[3..-1]
      token[3..-1] = ''
      @tokens.unshift new_token
    end
    token
  end
end

