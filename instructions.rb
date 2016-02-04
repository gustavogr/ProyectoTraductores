class UnExpression
    def initialize(operator, expression)
        @operator = operator 
        @expr = expression1 
    end
    # def to_s
    #     "Tk#{@name} #{@line} #{@column}"
    # end
end

class BinExpression
    def initialize(operator, expression1, expression2)
        @operator = operator 
        @expr1 = expression1 
        @expr2 = expression2
    end
    # def to_s
    #     "Tk#{@name} #{@line} #{@column}"
    # end
end

class Conditional
    def initialize(codition, ifStmt, elseStmt)
        @condition = condition 
        @ifBody = ifStmt 
        @elseBody = elseStmt
    end

class UndfIter
    def initialize(condition, statement)
        @ex = operator 
        @expr1 = expression1 
        @expr2 = expression2
    end
end


