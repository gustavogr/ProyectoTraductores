class Token
    def initialize(name, line, column)
        @name = name 
        @line = line
        @column = column
    end
    def to_s
        "#{@name}, #{@line}, #{@column}"
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
        "#{@name}(\"#{@argument}\"), #{@line}, #{@column}"
    end
end

class TChar < WArgs
    def to_s
        "#{@name}('#{@argument}'), #{@line}, #{@column}"
    end
end

class TNum < WArgs
    def to_s
        "#{@name}(#{@argument}), #{@line}, #{@column}"
    end
end


h = Token.new("TkCreate", 1, 1)
puts h
a = TChar.new("TkCharacter", 'p', 5, 3)
puts a
b = TIdent.new("TkIdent", "varX" , 5, 3)
puts b
c = TNum.new("TkNum", 3434, 5, 3)
puts c
