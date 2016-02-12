
# lexer.rb
# 
# Convierte un programa en bot (string) en tokens del lenguaje BOT
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

require_relative 'token.rb'

class Lexer

    ## 
    #  Regexp que hace match con cualquiera de los simbolos del lenguaje
    #  Es importante notar que los símbolos compuestos se evalúan antes que
    #  los simbolos de un solo caracter para evitar inconsistencias
    
    Symbols   = /\A(>=|<=|\\\/|\/\\|\/=|,|\.|:|\+|-|\(|\)|\*|\/|%|~|<|>|=)/
    
    # Regexp que hace match con cualquier palabra reservada
        
    ReservedW = /\A(?x)(bot|execute|if|create|else|while|int|bool|char|store|recieve|on|end|deactivate|
        activate|activation|advance|deactivation|default|collect|as|drop|left|right|up|down|
        read|true|false|me)/
    
    # Tabla de Hash para facilitar la busqueda del nombre de cada simbolo
    
    TokenHash = Hash[   ","   => "Coma",
                        "."   => "Punto",
                        ":"   => "DosPuntos",
                        "("   => "ParAbre",
                        ")"   => "ParCierra",
                        "+"   => "Suma",
                        "-"   => "Resta",
                        "*"   => "Mult",
                        "/"   => "Div",
                        "%"   => "Mod",
                        "/\\" => "Conjuncion",
                        "\\/" => "Disyuncion",
                        "~"   => "Negacion",
                        "<"   => "Menor",
                        "<="  => "MenorIgual",
                        ">"   => "Mayor",
                        ">="  => "MayorIgual",
                        "="   => "Igual",
                        "/="  => "NoIgual"
                    ]
    
    attr_accessor :tokensList 
        
    ##
    #  Iteramos sobre el programa a analizar.
    #  En cada iteracion se hace match del inicio
    #  del programa con las diferentes Regexp y se procesa
    #  según sea el caso.
    def analize(file)
        program = File.read(file)   # Programa a Analizar
        line = 1                    # Contador para mostrar el numero de linea
        column = 1                  # Contador para mostrar el numero de columna
        hasErrors = false           # Booleano para recordar si hubo un error
        self.tokensList = Array.new

        while not program.empty?

            case program
            
            ## Espacios vacios
            #  Se extraen todos los espacios posibles y se aumenta la columna
            when /\A +/s 
                sub = program.slice!(/\A +/)
                column += sub.length

            ## Palabras Reservadas
            #  Se usa la regexp ReservedW. Luego de la palabra no puede venir 
            #  un caracter valido para palabra debido a que dejaria de ser una
            #  palabra reservada.
            when /#{ReservedW}(\W|\z)/ 
                sub = program.slice!(ReservedW)
                self.tokensList << Token.new(sub.upcase.to_sym, sub.capitalize, line, column)
                column += sub.length

            ## Saltos de línea
            #  Se aumenta el numero de linea y se reinicia el numero de columna a 1
            when /\A\n/
                program.slice!(/\A\n/)
                line += 1
                column = 1

            ## Símbolos
            #  Se usa la regexp symbols. A diferencia del caso de las palabras
            #  reservadas no nos afecta que venga despues del simbolo
            when Symbols
                sub = program.slice!(Symbols)
                self.tokensList << Token.new(TokenHash[sub].upcase.to_sym, sub, line, column)
                column += sub.length

            ## Caracteres
            #  Hace match con un solo caracter. Al igual que con las palabras
            #  reservadas se pide que no venga un caracter valido de palabra
            #  despues.
            when /\A'[a-zA-Z]'(\W|\z)/
                sub = program.slice!(/\A'\w'/)
                self.tokensList << TkChar.new(sub, line, column)
                column += sub.length

            ## Numeros
            #  Hace match con cualquier secuencia de numeros. 
            #  Tambien se verifica que no siga un caracter valido de palabra
            when /\A\d+(\W|\z)/
                sub = program.slice!(/\A\d+/)
                self.tokensList << TkNum.new(sub, line, column) 
                column += sub.length

            ## Identificadores
            #  Deben empezar con una letra y luego puede venir cualquier
            #  combinacion de caracteres de palabra.
            when /\A[a-zA-Z]\w+(\W|\z)/
                sub = program.slice!(/\A[a-zA-Z]\w+/)
                self.tokensList << TkIdent.new(sub, line, column)
                column += sub.length

            ## Comentarios de una línea
            #  Hace match desde la ocurrencia de $$ hasta el final de esa linea
            when /\A\$\$.*$/
                sub = program.slice!(/\A\$\$.*$/)

            ## Comentarios multilinea
            #  Se extraen todas las lineas que esten entre $- y -$. 
            #  Una vez extraidas se ajustan los contadores de manera adecuada.
            when /\A\$-.*?-\$/m
                sub = program.slice!(/\A\$-.*?-\$/m)
                line += sub.count("\n")
                lastLine = sub.slice!(/^.*\z/)
                column = lastLine.length + 1

            ## Identificadores no validos
            #  Extrae los identificadores que empiezan con un numero o un _
            #  Este caso reporta el error.
            when /\A[\d_]\w/
                sub = program.slice!(/\A[\d_]+/)
                hasErrors = true
                puts "Error: Caracter inesperado \"#{sub[0]}\" en la fila #{line}, columna #{column}"
                column += sub.length

            ## Errores
            #  Si no cae en ninguna de las reglas anteriores estamos ante un error
            #  Se reporta el error y se consume un caracter para seguir avanzando
            else
                sub = program.slice!(0)
                hasErrors = true
                puts "Error: Caracter inesperado \"#{sub}\" en la fila #{line}, columna #{column}"
                column += 1
        
            end 
        end

        def next_token
            token = self.tokensList.shift
            token == nil ? [false,false] : token.get_token
        end

        def print_tokens
            puts self.tokensList.join(", ")
        end

    end    
end


