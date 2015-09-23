def lexer(file)
    reservedW = /\A(bot|execute|if|create|else|while|int|bool|char|store|recieve|on|end|activate|activation|advance|
             deactivate|deactivation|default|collect|as|drop|left|right|up|down|read|true|false)/

    /\n| |\t/

    program = File.read(file)
    line = 1
    column = 1
    has_errors = false
    while not program.empty?
        # puts "Programa:\n'#{program}'\n\n"
        case program
        when /\A +/s 
            sub = program.slice!(/\A +/)
            column += sub.length

        when reservedW
            sub = program.slice!(reservedW)
            column += sub.length

        when /\A\n/
            program.slice!(/\A\n/)
            line += 1
            column = 1

        when /\A,[ \n\t]/
            column += 1
        when /\A.[ \n\t]/
            column += 1
        when /\A:[ \n\t]/
            column += 1    
        when /\A\(/
            column += 1
        when /\A\)/
            column += 1

        when /\A\+[ \n\t]/
            column += 1
        when /\A\-[ \n\t]/
            column += 1
        when /\A\*[ \n\t]/
            column += 1
        when /\A\/[ \n\t]/
            column += 1
        when /\A\%[ \n\t]/
            column += 1
        when /\A\/\\[ \n\t]/ # conjuncion
            column += 1
        when /\A\\\/[ \n\t]/ # disjuncion
            column += 1
        when /\A~[ \n\t]/
            column += 1
        when /\A<=[ \n\t]/
            column += 1
        when /\A<[ \n\t]/
            column += 1
        when /\A>=[ \n\t]/
            column += 1
        when /\A>[ \n\t]/
            column += 1
        when /\A=[ \n\t]/
            column += 1


        else
            sub = program.slice!(/\A.+/)
            column += sub.length
        end

    end
end


lexer("prueba")