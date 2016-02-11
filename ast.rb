class ASTNode
    def initialize(node)
        @tree = node     
    end


end


class UnExprNode < ASTNode
    def initialize(operator, expression)
        @operator = operator
        @expr = expression
    end

    def to_s
        puts "UNARY_EXPR"
        puts "operator: #{@operator}"
        puts "operand: " + to_s(@expression)
    end
  end

end

class BinExprNode < ASTNode
    def initialize(operator, expr1, expr2, type)
        @op = operator
        @expr1 = expr1 
        @expr2 = expr2 
        @type = type
    end
end

class AritExprNode < BinExprNode
    def initialize(operator, expr1, expr2, type)
        @op = operator
        @expr1 = expr1 
        @expr2 = expr2 
        @type = type
    end

    def to_s
        puts "ARIT_EXPR"
        puts "operation: #{@op}"
        puts "left operand:" + to_s(@expr1)
        puts "right operand:" + to_s(@expr2)
    end
end

class BoolExprNode < BinExprNode
    def initialize(operator, expr1, expr2, type)
        @op = operator
        @expr1 = expr1 
        @expr2 = expr2 
        @type = type
    end

    def to_s
        puts "BOOL_EXPR"
        puts "operation: #{@op}"
        puts "left operand:" + to_s(@expr1)
        puts "right operand:" + to_s(@expr2)
    end

end

class RelExprNode < BinExprNode
    def initialize(operator, expr1, expr2, type)
        @op = operator
        @expr1 = expr1 
        @expr2 = expr2 
        @type = type
    end

    def to_s
        puts "REL_EXPR"
        puts "operation: #{@op}"
        puts "left operand:" + to_s(@expr1)
        puts "right operand:" + to_s(@expr2)
    end
end

class ConditionalNode < ASTNode
    def initialize(id, condition, instruction1, instruction2)
        @condition = condition 
        @ifBody = instruction1 
        @elseBody = instruction2
    end
    def to_s
        puts "CONDITIONAL"
        puts "condition: " + to_s(@condition)
        puts "ifBody: " + to_s(@ifBody)
        puts "elseBody: " + to_s(@elseBody)
    end

end

class UndfIterNode < ASTNode
    def initialize(condition, instruction)
        @condition = condition 
        @body = instruction 
    end

    def to_s
        puts "UNDF_ITER"
        puts "condition: " + to_s(@condition)
        puts "body: " + to_s(@body)
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





