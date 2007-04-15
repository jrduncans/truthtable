truthtable
    by Stephen Duncan Jr
    http://code.google.com/p/jrduncans

== DESCRIPTION:
  
Builder for boolean truth tables.

== FEATURES/PROBLEMS:
  
* Builds truth tables
* Should field order be alphabetical, or by order of appearance?

== SYNOPSIS:

  puts TruthTable.new("a & b", 2) {|a, b| a & b }

== REQUIREMENTS:

* RubyGems

== INSTALL:

* sudo gem install truthtable

== LICENSE:

Copyright 2006 Stephen Duncan Jr

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. 
You may obtain a copy of the License at 
	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
