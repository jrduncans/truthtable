#!/bin/env ruby

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

def truthtable(formula, size)
  column = "a"
  
  size.times do
    print "#{column}\t"
    column.next!
  end
  
  puts formula

  values = generate_values(size)

  values.each do |entry|
    entry.each do |value|
      print "#{value}\t"
    end

    puts yield(*entry).to_s
  end

  puts
end

truthtable("(a & b) | c", 3) do |a, b, c|
  (a & b) | c
end

truthtable("a ^ b", 2) do |a, b|
  a ^ b
end

truthtable("(a & b) | (c & d)", 4) do |a, b, c, d|
  (a & b) | (c & d)
end