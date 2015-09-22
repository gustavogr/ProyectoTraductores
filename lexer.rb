def lexer(file)
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
        when /\A\n/
            program.slice!(/\A\n/)
            line += 1
            column = 1
        else
            sub = program.slice!(/\A.+/)
            column += sub.length
        end

    end
end


lexer("prueba")