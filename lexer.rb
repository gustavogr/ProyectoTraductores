require_relative 'token.rb'

def lexer(file)

    reservedW = /\A(bot|execute|if|create|else|while|int|bool|char|store|recieve|on|end|activate|activation|advance|
             deactivate|deactivation|default|collect|as|drop|left|right|up|down|read|true|false)/

    symbols   = /\A(>=|<=|\\\/|\/\\|,|\.|:|\+|-|\(|\)|\*|\/|%|~|<|>|=)/

    tokenHash = Hash[","   =>  "Coma", "."   =>  "Punto", ":"   =>  "DosPuntos", "("   =>  "ParAbre",
                 ")"   =>  "ParCierra", "+"   => "Suma", "-"   => "Resta", "*"   => "Mult", "/"   => "Div", 
                "%"   => "Mod", "\/\\"  => "Conjuncion", "\\\/"  => "Disyuncion", "~"   => "Negacion", 
                "<"   => "Menor", "<="  => "MenorIgual", ">"   => "Mayor", ">="  => "MayorIgual", "="   => "Igual"]


    program = File.read(file)
    line = 1
    column = 1
    has_errors = false
    while not program.empty?
        case program
        when /\A +/s 
            sub = program.slice!(/\A +/)
            column += sub.length

        when /#{reservedW}\W/ 
            sub = program.slice!(reservedW)
            print Token.new(sub.capitalize, line, column)
            column += sub.length
            
        when /\A\n/
            program.slice!(/\A\n/)
            line += 1
            column = 1

        when symbols
            print Token.new(tokenHash[program[0]], line, column)
            column += 1
            program[0] = ''

        #Hasta ahora todo esto lo tomo como identificadores
        #hay que seguir refinando, para sacar Nums y chars.
        when /\A\w+ /
            sub = program.slice!(/\A\w+ /)
            #print TIdent.new("TkIdent", sub,  line, column)
            column += sub.length - 1
        #     has_errors = true
        end

    
    end
end


lexer("prueba")