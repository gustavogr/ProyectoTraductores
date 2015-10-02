# lexBot.rb
# 
# Programa que llama al interprete (por ahora solo lexer) 
#   con el archivo que se suministre
#
# Autores:
#   Gustavo Gutierrez   11-10428
#   Jose Pascarella     11-10743
#
# Repositorio:
#   https://github.com/gutielr/ProyectoTraductores 
#
# Ultima modificacion: 
#   2 / 10 / 2015


require_relative 'lexer.rb' 

tokenList = lexer(ARGV[0])
puts tokenList.join(", ") unless tokenList == nil