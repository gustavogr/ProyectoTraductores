# Bot.rb
# 
# Interprete del lenguaje Bot 
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

begin
    tokens = Lexer.new(ARGV[0])
    parser = Parser.new(tokens)
    ast = parser.parse
    ast.check()
    ast.eval
    puts

rescue LexicalError => e 
    print "Error lexico: "
    puts e 

rescue ParseError => e 
    print "Error de sintaxis: "
    puts e

rescue ContextError => e
	print "Error de contexto: "
	puts e

rescue RuntimeError => e
	print "Error en ejecucion: "
	puts e
end

