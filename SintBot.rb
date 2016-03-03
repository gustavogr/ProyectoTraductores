# SintBot.rb
# 
# Programa que llama al interprete (por ahora solo lexer y parser) 
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
#   15 / 02 / 2016

require_relative 'lexer.rb' 
require_relative 'Parser.tab.rb' 

lex = Lexer.new
lex.analize(ARGV[0])

begin
    parser = Parser.new(lex)
    arbol = parser.parse
    puts arbol
    arbol.printSymTable()
    arbol.check()
    puts
    puts
    arbol.printSymTable()


rescue ParseError => e 
    print "Syntax error: "
    puts e
end
