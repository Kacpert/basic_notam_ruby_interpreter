class FilteringNotamsController < ApplicationController
  def new
  end

  def create
    file = params[:filtering][:notams].tempfile.read
    @array = file.scan /A\).(\w+\b).*\n*.*\n*.*\n*.*AERODROME HOURS OF OPS\/SERVICE+(.*\n*.*.*\n*.*.*\n*.*.*\n*.*)CREATED/
  end
end
