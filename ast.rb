class ASTNode
    def initialize(tree)
        @tree = tree        
    end
    
end

class UnExprNodeNode < ASTNode
    def initialize(operator, expression)
        @operator = operator 
        @expr = expression
    end
    # def to_s
    #     "Tk#{@name} #{@line} #{@column}"
    # end
end

### PODRIA SUBDIVIDIRSE EN RELACIONAL, ARITMETICA Y LOGICA
class BinExprNode < ASTNode
    def initialize(operator, expression1, expression2)
        @operator = operator 
        @expr1 = expression1 
        @expr2 = expression2
    end
    # def to_s
    #     "Tk#{@name} #{@line} #{@column}"
    # end
end


class ConditionalNode < ASTNode
    def initialize(condition, ifStmt, elseStmt)
        @condition = condition 
        @ifBody = ifStmt 
        @elseBody = elseStmt
    end
end

class UndfIterNode < ASTNode
    def initialize(condition, statement)
        @condition = condition 
        @statement = statement 
    end

end

class StoreNode < ASTNode
    def initialize(robot, expression)
        @robot = robot
        @expr = expression
    end
    
end

################??????????????????
#### No entiendo bien donde entra la matriz
# por ahora
class CollectNode < ASTNode
    def initialize(variable, value)

    end
end

class DropNode < ASTNode
    def initialize(expression)
        @expr = expression
    end
       
end

class RobotNode < ASTNode
    def initialize(id, value)
        @ident = id
        @value = value
        
    end
    
end

class VariableNode < ASTNode
    def initialize(id, value)
        @ident = id
        @value = value
    end
end


class Valores < ASTNode
    def initialize(id, value) 
        @id = id
        @value = value
    end
end





