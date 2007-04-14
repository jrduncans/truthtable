# Copyright 2006 Stephen Duncan Jr
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at 
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'set'

class TruthTable
  VERSION = "1.0.0"

  def initialize(formula, size = nil, &expression)
    @formula = formula
    @size = size
    @expression = expression
    
    @size ||= Set.new(@formula.gsub(/[^[:alpha:]]/, "").split(//)).size
    @expression ||= eval("Proc.new {|a,b| #{formula} }")
    
    @string = ""
    
    column = "a"    
    @size.times do
      @string << "#{column}\t"
      column.next!
    end
    
    @string << @formula << "\n"
  
    values = generate_values(@size)  
    values.each do |entry|
      entry.each do |value|
        @string << "#{value}\t"
      end
  
      @string << @expression.call(*entry).to_s << "\n"
    end
    
    @string << "\n"
  end
  
  def to_s
    @string
  end

  private

  def generate_values(size)
    values = []
    row = Array.new(size, false)
  
    (2**size).times do
      values << row.dup
      get_next(row)
    end
  
    return values
  end
  
  def get_next(row, index = nil)
    index ||= row.size - 1
  
    if row[index] == false
      row[index] = true
    else
      row[index] = false
      row[0..(index - 1)] = get_next(row, index - 1)[0..(index - 1)]
    end
  
    return row
  end
end