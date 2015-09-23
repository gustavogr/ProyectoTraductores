class Token
    def initialize(name, line, column)
        @name = name 
        @line = line
        @column = column
    end
    def to_s
        "#{@name} #{@line} #{@column}"
    end
end

class WArgs < Token 
    def initialize(name, argument, line, column)
        super(name, line, column)
        @argument = argument
    end

end

class TIdent < WArgs
    def to_s
        "#{@name}(\"#{@argument}\") #{@line} #{@column}"
    end
end

class TChar < WArgs
    def to_s
        "#{@name}('#{@argument}') #{@line} #{@column}"
    end
end

class TNum < WArgs
    def to_s
        "#{@name}(#{@argument}) #{@line} #{@column}"
    end
end


