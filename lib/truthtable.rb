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

# Author::	Stephen Duncan Jr (mailto:jrduncans@stephenducanjr.com)
# Copyright::	Copyright 2006 Stephen Duncan Jr
# License::	Apache License, Version 2.0

# This class represents a truth table.  A truth table can be constructed for
# any boolean expression that Ruby understands.  Example usage:
#   puts TruthTable.new("a ^ b") {|x, y| x ^ y }
#   puts TruthTable.new("a | b")
class TruthTable
  VERSION = "1.0.0"

  # Creates a truth table.  If no block is given, then the provided formula will
  # be used as the expression, otherwise the formula will just be used for display
  # purposes.
  def initialize(formula, &expression)
    @formula = formula
    @expression = expression
    
    # Should .sort be put back on the end of this line?
    variables = @formula.gsub(/[^[:alpha:]\s]/, "").split(" ").uniq
    
    @expression ||= eval("Proc.new {|#{variables.join(',')}| #{formula} }")
        
    @string = ""
    
    variables.each do |column|
      @string << "#{column}\t"
    end
    
    @string << @formula << "\n"
  
    values = generate_values(variables.size)
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

  # Generates a two-dimensional array containing the table of values
  # for the a number values equal to the provided size.
  def generate_values(size)
    values = []
    row = Array.new(size, false)
  
    (2**size).times do
      values << row.dup
      get_next(row)
    end
  
    return values
  end
  
  # Gets the next row by "adding" to the given to the end of the row
  # if no index is given.
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
