#!/usr/bin/env ruby

# == Synopsis
# 
# Outputs the truthtable for the given expression to standard-out.
# 
# == Usage
# 
#   truthtable "(a && b) || c"

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

require 'table_print'
require 'optparse'

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
    raise 'Invalid formula' unless formula =~ /\A[()^&|!a-zA-Z\s]+\z/
    @formula = formula
    @expression = expression
    @variables = @formula.gsub(/[^[:alpha:]\s]/, " ").split(" ").uniq.sort
    @expression ||= eval("Proc.new {|#{@variables.join(',')}| #{formula} }")
    @values = generate_values(@variables.size)
    
    @results = []
    @values.each do |entry|
      @results << @expression.call(*entry)
    end
  end

  def to_table
    header = @variables << @formula
    table_data = @values.zip(@results).map { |a| a[0] << a[1] }
    table = table_data.map do |a|
      row = {}
      a.each_with_index { |v, i| row[header[i]] = v }
      row
    end
  end

  private

  # Generates a two-dimensional array containing the table of values
  # for the a number values equal to the provided size.
  def generate_values(size)
    values = []
    
    var_masks = (0...size).to_a.reverse.map {|i| 2**i }
    
    0.upto((2**size) - 1) do |cnt_mask|
      values << var_masks.map {|var_mask| (var_mask & cnt_mask) == var_mask }
    end
    
    return values
  end
end

option_parser = OptionParser.new do |opts|
  opts.banner = 'Usage: ./truthtable "(a && b) || c"'
  opts.on_tail('-h', '-?', '--help', 'brief help message') do
    puts opts
    exit
  end
end

option_parser.parse!

if ARGV.length != 1
  puts "One argument required"
  puts option_parser.help
  exit(-1)
end

begin  
  tp.set :capitalize_headers, false
  tp.set :max_width, 80
  tp TruthTable.new(ARGV.shift).to_table
rescue
  puts option_parser.help
  exit(-1)
end

