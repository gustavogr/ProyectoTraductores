require_relative 'token.rb'

def lexer(file)

    reservedW = /\A(bot|execute|if|create|else|while|int|bool|char|store|recieve|on|end|activate|activation|advance|
             deactivate|deactivation|default|collect|as|drop|left|right|up|down|read|true|false)/

    singles   = /\A(,|\.|:|\+|-|\*|\/|%|~|<|>|=)[ \t\n]/ # Faltan los parentesis

    megaHash  = Hash[","   =>  "TkComa", "."   =>  "TkPunto", ":"   =>  "TkDosPuntos", "("   =>  "TkParAbre",
                 ")"   =>  "TkParCierra", "+"   => "TkSuma", "-"   => "TkResta", "*"   => "TkMult", "/"   => "TkDiv", 
                "%"   => "TkMod", "\/\\"  => "TkConjuncion", "\\\/"  => "TkDisyuncion", "~"   => "TkNegacion", 
                "<"   => "TkMenor", "<="  => "TkMenorIgual", ">"   => "TkMayor", ">="  => "TkMayorIgual", "="   => "TkIgual"]


    program = File.read(file)
    line = 1
    column = 1
    has_errors = false
    while not program.empty?
        case program
        when /\A +/s 
            sub = program.slice!(/\A +/)
            column += sub.length

        when reservedW
            sub = program.slice!(reservedW)
            # Si cableamos el Tk en las clases hay que quitarlo de aqui
            print Token.new("Tk"+sub.capitalize, line, column), ", "
            column += sub.length
            
        when /\A\n/
            program.slice!(/\A\n/)
            line += 1
            column = 1

        # Podriamos agrupar todos los simbolos compuestos

        when /\A<=[ \n\t]/
            print Token.new(megaHash[program[0,2]], line, column), ", "
            column += 2
            program[0,2] = ''

        when /\A>=[ \n\t]/
            print Token.new(megaHash[program[0,2]], line, column), ", "
            column += 2
            program[0,2] = ''

        when /\A\/\\[ \n\t]/ # conjunction
            print Token.new(megaHash[program[0,2]], line, column), ", "
            column += 2
            program[0,2] = ''

        when /\A\\\/[ \n\t]/ # disjunction
            print Token.new(megaHash[program[0,2]], line, column), ", "
            column += 2
            program[0,2] = ''

        when singles
            print Token.new(megaHash[program[0]], line, column), ", "
            column += 1
            program[0] = ''

        # Los parentesis pueden ser parte de singles

        when /\A\(/
            print Token.new(megaHash[program[0]], line, column), ", "
            column += 1
            program[0] = ''

        when /\A\)/
            print Token.new(megaHash[program[0]], line, column), ", "
            column += 1
            program[0] = ''

        #Hasta ahora todo esto lo tomo como identificadores
        #hay que seguir refinando, para sacar Nums y chars.
        when /\A\w+ /
            sub = program.slice!(/\A\w+ /)
            print TIdent.new("TkIdent", sub,  line, column), ", "
            column += sub.length - 1
        #     has_errors = true
        end

    
    end
end


lexer("prueba")