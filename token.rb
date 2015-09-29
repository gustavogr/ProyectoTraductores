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


