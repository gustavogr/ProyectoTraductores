def lexer(file)
    program = File.read(file)
    line = 1
    column = 1
    has_errors = false
    while not program.empty?
        # puts "Programa:\n'#{program}'\n"
        
        if (/^ +/ =~ program)
            sub = program.slice!(/^ +/)
            column += sub.length
        
        elsif (/^\n/ =~ program)
            program.slice!(/^\n/)
            puts "Linea #{line} tiene #{column} columnas."
            line += 1
            column = 1
        else
            sub = program.slice!(/^.+/)
            column += sub.length
        end

    end
end


lexer("prueba")