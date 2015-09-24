require_relative 'token.rb'

def lexer(file)

    reservedW = /\A(bot|execute|if|create|else|while|int|bool|char|store|recieve|on|end|activate|activation|advance|
             deactivate|deactivation|default|collect|as|drop|left|right|up|down|read|true|false)/

    symbols   = /\A(>=|<=|\\\/|\/\\|\/=|,|\.|:|\+|-|\(|\)|\*|\/|%|~|<|>|=)/

    tokenHash = Hash[   ","   =>  "Coma",
                        "."   =>  "Punto",
                        ":"   =>  "DosPuntos",
                        "("   =>  "ParAbre",
                        ")"   =>  "ParCierra",
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

    program = File.read(file)
    line = 1
    column = 1
    hasErrors = false
    tokensList = []
    while not program.empty?
        case program
        ## Espacios vacios
        when /\A +/s 
            sub = program.slice!(/\A +/)
            column += sub.length

        ## Palabras Reservadas
        when /#{reservedW}(\W|\z)/ 
            sub = program.slice!(reservedW)
            tokensList << Token.new(sub.capitalize, line, column)
            column += sub.length

        ## Saltos de línea
        when /\A\n/
            program.slice!(/\A\n/)
            line += 1
            column = 1

        ## Símbolos
        when symbols
            sub = program.slice!(symbols)
            tokensList << Token.new(tokenHash[sub], line, column)
            column += sub.length

        ## Caracteres
        when /\A\w(\W|\z)/
            sub = program.slice!(/\A\w/)
            tokensList << TkChar.new(sub, line, column)
            column += sub.length

        ## Numeros
        when /\A\d+(\W|\z)/
            sub = program.slice!(/\A\d+/)
            tokensList << TkNum.new(sub, line, column) 
            column += sub.length

        ## Identificadores
        when /\A[a-zA-Z]\w+(\W|\z)/
            sub = program.slice!(/\A[a-zA-Z]\w+/)
            tokensList << TkIdent.new(sub, line, column)
            column += sub.length

        ## Comentarios de una línea
        when /\A\$\$.*$/
            sub = program.slice!(/\A\$\$.*$/)

        ## Comentarios multilinea
        when /\A\$-.*?-\$/m
            sub = program.slice!(/\A\$-.*?-\$/m)
            line += sub.count("\n")
            lastLine = sub.slice!(/^.*\z/)
            column = lastLine.length + 1

        when /\A\d+[a-zA-Z]/
            hasErrors = true
            sub = program.slice!(/\A\d+/)
            puts "Error: Caracter inesperado \"#{sub[0]}\" en la fila #{line}, columna #{column}"
            column += sub.length

        else
            sub = program.slice!(0)
            hasErrors = true
            puts "Error: Caracter inesperado \"#{sub}\" en la fila #{line}, columna #{column}"
            column += 1
    
        end 
    end
  
    return tokensList unless hasErrors
end

