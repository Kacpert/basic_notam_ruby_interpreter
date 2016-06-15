class FilteringNotamsController < ApplicationController
  def new
  end

  def create
    @formated_data = []
    file = params[:filtering][:notams].present? ? params[:filtering][:notams].tempfile.read : params[:filtering][:text] 
    array = file.scan /A\).(\w+\b).*\n*.*\n*.*\n*.*AERODROME HOURS OF OPS\/SERVICE+(.*\n*.*.*\n*.*.*\n*.*.*\n*.*)CREATED/
    array.each do |a|
      @formated_data << [a[0]] + NotamDateToArrayParserAndInterpreter.new(a[1]).interprate_and_return_result
    end
  end
end


