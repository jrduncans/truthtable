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
    @variables = @formula.gsub(/[^[:alpha:]\s]/, " ").split(" ").uniq    
    @expression ||= eval("Proc.new {|#{@variables.join(',')}| #{formula} }")      
    @values = generate_values(@variables.size)
    
    @results = []
    @values.each do |entry|
      @results << @expression.call(*entry)
    end    
  end
  
  def to_s
    string = @variables.join("\t") + "\t#{@formula}\n"
  
    @values.each_with_index do |entry, i|
      entry.each do |value|
        string << "#{value}\t"
      end
  
      string << @results[i].to_s << "\n"
    end
    
    string << "\n"
  end

  private

  # Generates a two-dimensional array containing the table of values
  # for the a number values equal to the provided size.
  def generate_values(size)
    values = []
    
    var_masks = (0..size-1).to_a.reverse.map {|i| 2**i }
    
    0.upto(2**@variables.length-1) do |cnt_mask|
      values << var_masks.map {|var_mask| (var_mask & cnt_mask) == var_mask }
    end
    
    return values
  end
end
