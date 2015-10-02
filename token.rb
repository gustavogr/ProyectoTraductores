# token.rb
# 
# Clases para los Token del Lenguaje
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

class Token
    def initialize(name, line, column)
        @name = name 
        @line = line
        @column = column
    end
    def to_s
        "Tk#{@name} #{@line} #{@column}"
    end
end

class TkIdent < Token
    def initialize(argument, line, column)
        @argument = argument
        @name = "Ident"
        @line = line
        @column = column
    end

    def to_s
        "Tk#{@name}(\"#{@argument}\") #{@line} #{@column}"
    end
end


class TkChar < Token
    def initialize(argument, line, column)
        @argument = argument
        @name = "Character"
        @line = line
        @column = column
    end

    def to_s
        "Tk#{@name}('#{@argument}') #{@line} #{@column}"
    end
end

class TkNum < Token
    def initialize(argument, line, column)
        @argument = argument
        @name = "Num"
        @line = line
        @column = column
    end

    def to_s
        "Tk#{@name}(#{@argument}) #{@line} #{@column}"
    end
end


