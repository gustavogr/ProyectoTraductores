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
#   02 / 03 / 2016

class Token
    def initialize(id, value, line, column)
        @id = id 
        @value = value
        @line = line
        @column = column
    end
  
    def to_s
        "Tk#{@id} #{@line} #{@column}"
    end
   
    def get_token
        return [@id, @value]
    end
end

class TkIdent < Token
    def initialize(value, line, column)
        super(:IDENT, value, line, column)
    end

    def to_s
        "TkIdent(\"#{@value}\") #{@line} #{@column}" 
   end
end

class TkChar < Token
    def initialize(value, line, column)
        super(:CHARACTER, value[1...-1], line, column)
    end

    def to_s
        "TkCharacter(#{@value}) #{@line} #{@column}"
    end
end

class TkNum < Token
    def initialize(value, line, column)
        super(:NUM, value, line, column)
    end

    def to_s
        "TkNum(#{@value}) #{@line} #{@column}"
    end
end


