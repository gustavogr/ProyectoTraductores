require_relative 'lexer.rb' 

tokenList = lexer(ARGV[0])
puts tokenList.join(", ") unless tokenList == nil