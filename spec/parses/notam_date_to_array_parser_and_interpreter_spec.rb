require 'pry'
require 'rails_helper'

RSpec.describe NotamDateToArrayParserAndInterpreter, type: :parser do

  let(:string_to_test){" MON-THU.0500-1830:FRI\n0630-0700, 0730-2100 SAT 0630-0730, 1900-2100 SUN CLOSED\n"}
  let(:right_result){["MON", "-", "THU", "0500", "-", "1830", "FRI", "0630", "-", "0700", "0730", "-", "2100", "SAT", "0630", "-", "0730", "1900", "-", "2100", "SUN", "CLOSED"]}

  describe '#initialize' do
    it "should" do
      parser = NotamDateToArrayParserAndInterpreter.new(string_to_test)
      expect(parser.instance_variable_get(:@tokens)).to eq(right_result)
    end
  end  

  describe 'catching errors' do
    it 'when day name is wrong should ignore that record and return error' do
      parser = NotamDateToArrayParserAndInterpreter.new("MON-WOW 0230-0500")
      expect(parser.interprate_and_return_result).to eq(["system found", "syntax error", "in that NOTAM", "'WOW'", "is not" , "represents","a day"])
    end
  end
  describe '#interprate_and_return_result' do
    it 'Should work with extreme cases' do 
      parser = NotamDateToArrayParserAndInterpreter.new("MON-SUN 0230-0500, 0530-1200, 1230-2400")
      expect(parser.interprate_and_return_result).to eq(["0230-0500</br>0530-1200</br>1230-2400",
                                   "0230-0500</br>0530-1200</br>1230-2400",
                                   "0230-0500</br>0530-1200</br>1230-2400",
                                   "0230-0500</br>0530-1200</br>1230-2400",
                                   "0230-0500</br>0530-1200</br>1230-2400",
                                   "0230-0500</br>0530-1200</br>1230-2400",
                                   "0230-0500</br>0530-1200</br>1230-2400"])
    end
    it 'Should work with standard cases' do 
      parser = NotamDateToArrayParserAndInterpreter.new(string_to_test)
      expect(parser.interprate_and_return_result).to eq(["0500-1830",
                                   "0500-1830",
                                   "0500-1830",
                                   "0500-1830",
                                   "0630-0700</br>0730-2100",
                                   "0630-0730</br>1900-2100",
                                   "CLOSED"])
    end
  end
end
