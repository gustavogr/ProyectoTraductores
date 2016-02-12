class ProgramNode
    def initialize(instructions)
        @symbolTable = nil
        @instructions = instructions
    end

    def to_s
        @instructions.to_s(1)
    end 
end

class InstListNode 
    def initialize
        @instList = []        
    end

    def add(inst)
        @instList << inst
        return self 
    end
    
    def to_s(level)
        if @instList.size > 1 then 
            printable = "" 
            @instList.each { |inst| printable += "\t"*level + inst.to_s(level + 1) + "\n"}
            "SECUENCE\n" + printable 
        else
            @instList[0].to_s(level)
        end
    end

end

class IdentListNode 
    def initialize
        @identList = []        
    end

    def add(ident)
        @identList << ident 
        return self
    end
    
    def to_s(level)
        printable = ""
        var = "var: "
        @identList.each {|ident| printable += "\t"*level + var + ident.to_s(level + 1) + "\n"}
        printable
    end

end


class UnExprNode
    def initialize(operator, expression, type)
        @operator = operator
        @expr = expression
        @type = type
    end

    def to_s(level)
        "UNARY_EXPR\n" +
        "\t"*level + "operator: #{@operator}\n" +
        "\t"*level + "operand: " + @expr.to_s(level+1) + "\n"
    end
end


class BinExprNode
    def initialize(operator, expr1, expr2, type)
        @op = operator
        @expr1 = expr1 
        @expr2 = expr2 
        @type = type
    end

    def to_s(level)
        "\t"*level + "operation: #{@op}\n" + 
        "\t"*level + "left operand: " + @expr1.to_s(level+1) + "\n" +
        "\t"*level + "right operand: " + @expr2.to_s(level+1) + "\n"
    end
end

class AritExprNode < BinExprNode
    def initialize(operator, expr1, expr2, type)
        super
    end

    def to_s(level)
        "ARIT_EXPR\n" + super
    end
end

class BoolExprNode < BinExprNode
    def initialize(operator, expr1, expr2, type)
        super
    end

    def to_s(level)
        "BOOL_EXPR\n" + super
    end

end

class RelExprNode < BinExprNode
    def initialize(operator, expr1, expr2, type)
        super
    end

    def to_s(level)
        "REL_EXPR\n" + super
    end
end

class ConditionalNode
    def initialize(condition, instruction1, instruction2)
        @condition = condition 
        @ifBody = instruction1 
        @elseBody = instruction2
    end
    def to_s(level)
        "CONDITIONAL\n" +
        "\t"*level + "condition: " + @condition.to_s(level+1) + "\n" +
        "\t"*level + "ifBody: " + @ifBody.to_s(level+1) + "\n" #+
        #{}"\t"*level + "elseBody: " + @elseBody.to_s(level+1) + "\n" 
    end

end

class UndfIterNode
    def initialize(condition, instruction)
        @condition = condition 
        @body = instruction 
    end

    def to_s(level)
        "UNDF_ITER\n" +
        "\t"*level + "condition: " + @condition.to_s(level+1) + "\n" +
        "\t"*level + "body: " + @body.to_s(level+1)
    end
end

# activate, deactivate, advance
class BasicInstrNode
    def initialize(id, identifiers)
        @id = id
        @identifiers = identifiers 
    end

    def to_s(level)
        "#{@id}\n" +
        "\t"*level + @identifiers.to_s(level) ##################(level+1)
    end
end


class NumberNode 
    attr_accessor :number

    def initialize(number)
        @number = number
    end

    def to_s(level)
        @number
    end
end

class CharNode   
    attr_accessor :char

    def initialize(char)
        @char = char
    end

    def to_s(level)
        "\'#{self.char}\'"
    end
end

class BoolNode   
    attr_accessor :bool

    def initialize(bool)
        @bool = bool
    end

    def to_s(level)
        @bool
    end
end

class VariableNode 

    #value and type
    def initialize(id)
        @id = id 
    end

    def to_s(level)
        @id
    end
end



