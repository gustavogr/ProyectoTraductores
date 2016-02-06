class ASTNode
    def initialize(tree)
        @tree = tree        
    end
    
end

class UnExprNodeNode
    def initialize(operator, expression1)
        @operator = operator 
        @expr = expression1 
    end
    # def to_s
    #     "Tk#{@name} #{@line} #{@column}"
    # end
end

class BinExprNode
    def initialize(operator, expression1, expression2)
        @operator = operator 
        @expr1 = expression1 
        @expr2 = expression2
    end
    # def to_s
    #     "Tk#{@name} #{@line} #{@column}"
    # end
end

class ConditionalNode
    def initialize(condition, ifStmt, elseStmt)
        @condition = condition 
        @ifBody = ifStmt 
        @elseBody = elseStmt
    end
end

class UndfIterNode
    def initialize(condition, statement)
        @condition = condition 
        @statement = statement 
        @expr2 = expression2
    end

end

class StoreNode
    def initialize(robot, expression)
        @robot = robot
        @expr = expression
    end
    
end

################??????????????????
#### No entiendo bien donde entra la matriz
# por ahora
class CollectNode
    def initialize(variable, valor)

    end
end

class DropNode
    def initialize(expresion, )
        
    end
    
    
end

class RobotNode
    def initialize(id, value)
        @ident = id
        @value = value
        
    end
    
end

class Valores
    def initialize(id, value)
        @id = id
        @value = value
    end
    
end





