# ast.rb
# 
# Archivo que contiene la estructura del Arbol Sintactico
# Abstracto
#
# Autores:
#   Gustavo Gutierrez   11-10428
#   Jose Pascarella     11-10743
#
# Repositorio:
#   https://github.com/gutielr/ProyectoTraductores 
#
# Ultima modificacion: 
#   15 / 02 / 2016

# Nodo que simboliza el programa.

class ProgramNode
    def initialize(instructions)
        #@symbolTable = nil
        @instructions = instructions
    end

    def to_s(level=1)
        if level == 1 then 
            @instructions.to_s(1)
        else
            "NEW_SCOPE\n" + 
            "    "*level + @instructions.to_s(level+1) 
        end
    end 

    def check
        @instructions.check
    end


end

# Nodo que contiene una lista de instruciones
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
            @instList.each { |inst| printable += "    "*level + inst.to_s(level + 1)}
            "SECUENCE\n" + printable 
        else
            @instList[0].to_s(level)
        end
    end

    def check
        @instList.each {|inst| inst.check}
    end

end

class BotInstListNone
    def initialize
        @instList = []
    end

    def add(inst)
        @instList << inst
        return self
    end

    def check
       @instList.each {|inst| inst.check} 
    end

end

class BehaviorListNone
    def initialize
        @bhList = []
        @type = nil
    end

    def add(inst)
        @bhList << inst
        return self
    end

    def check
        #Chequear por defaults y activates
        @bhList.each {|behavior| behavior.symTable.add("me", @type); behavior.check}

    end

end

class BehaviorNode
    def initialize(condition, instructions)
        @condition = condition
        @instructions = instructions
        @symTable = SymbolTable.new()
    end
    
    def check
        condT = @condition.check 
        condT == :bool # or activation or...
        @instructions.check
    end
end

class StoreNode
    def initialize(expr)
        @expr = expr
    end

    def check
        exprT = expr.check
        #exprT == type Robot 
    end

end

# Guarda el valor de la matriz en el robot
class CollectNode
    def initialize(ident="me")
        @ident = ident
    end

    def check
        #lookup
    end
end

class DropNode
    def initialize(expr)
        @expr = expr
    end

    def check
        @expr.check
    end

end

class MoveNode
    def initialize(to, expr=nil)
        @to = to
        @expr = expr
    end
    
    def check
        expT = @expr.check # luego debe ser no negativa
    end
    
end


# Nodo que contiene una lista de Identificadores
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
        var = "- var: "
        @identList.each {|ident| printable += "    "*level + var + ident.to_s(level + 1) + "\n"}
        printable
    end

    def check
        @identList.each {|ident| ident.check}
    end

end

# Nodo que contiene una Expresion Unaria
class UnExprNode
    def initialize(operator, expression, type)
        @operator = operator
        @expr = expression
        @type = type
    end

    def check
        expT = @expr.check
        raise "Error: #{@operator} #{expT}" unless expT == @type
        @type
    end

    def to_s(level)
        "UNARY_EXPR\n" +
        "    "*level + "operator: #{@operator}\n" +
        "    "*level + "operand: " + @expr.to_s(level+1)
    end
end

# Nodo que contiene una Expresion Binaria
class BinExprNode
    def initialize(operator, expr1, expr2, type)
        @op = operator
        @expr1 = expr1 
        @expr2 = expr2 
        @type = type
    end

    def check
        exp1 = @expr1.check
        exp2 = @expr2.check
        raise "Error: #{exp1} #{@op} #{exp2}" unless exp1 == @type and exp1 == exp2
        @type
    end

    def to_s(level)
        "    "*level + "- operation: #{@op}\n" + 
        "    "*level + "- left operand: " + @expr1.to_s(level+1) + "\n" +
        "    "*level + "- right operand: " + @expr2.to_s(level+1)
    end
end

# Nodo que contiene una Expresion Aritmetica
class AritExprNode < BinExprNode
    def initialize(operator, expr1, expr2)
        super(operator, expr1, expr2, :int)
    end

    def to_s(level)
        "ARIT_EXPR\n" + super
    end
end

# Nodo que contiene una Expresion Booleana
class BoolExprNode < BinExprNode
    def initialize(operator, expr1, expr2)
        super(operator, expr1, expr2, :bool)
    end

    def to_s(level)
        "BOOL_EXPR\n" + super
    end
end

# Nodo que contiene una Expresion Relacional
class RelExprNode < BinExprNode
    def initialize(operator, expr1, expr2)
        super(operator, expr1, expr2, :bool)
    end

    def check
        exp1 = @expr1.check
        exp2 = @expr2.check
        raise "Error: #{exp1} #{@op} #{exp2}" unless (exp1 == :int or exp1 == :bool) and exp1 == exp2
        @type 
    end

    def to_s(level)
        "REL_EXPR\n" + super
    end
end

# Nodo que contiene respresentacion de una clausula IF-THEN-ELSE
class ConditionalNode
    def initialize(condition, instruction1, instruction2)
        @condition = condition 
        @ifBody = instruction1 
        @elseBody = instruction2
    end

    def check  
        raise "Error: Expresion de Condicional" unless @condition.check == :bool
        @ifBody.check
        @elseBody.check
    end

    def to_s(level)
        printable = "CONDITIONAL\n" +
        "    "*level + "- condition: " + @condition.to_s(level+1) + "\n" +
        "    "*level + "- ifBody: " + @ifBody.to_s(level+1)
        
        if @elseBody != nil then
            printable += "    "*level + "- elseBody: " + @elseBody.to_s(level+1)
        end
        printable
    end
end

# Nodo que contiene la representacion de la Iteracion Indefinida
class UndfIterNode
    def initialize(condition, instruction)
        @condition = condition 
        @body = instruction 
    end

    def check
        raise "Error: Condicion de Iteracion" unless @condition.check == :bool
        @body.check
    end

    def to_s(level)
        "UNDF_ITER\n" +
        "    "*level + "- condition: " + @condition.to_s(level+1) + "\n" +
        "    "*level + "- body: " + @body.to_s(level+1)
    end
end

# Nodo que contiene instrucciones basicas como: Activate, Deactivate, Advance
class BasicInstrNode
    def initialize(id, identifiers)
        @id = id
        @identifiers = identifiers 
    end

    def check
        @identifiers.check 
    end 

    def to_s(level)
        "#{@id}\n" +
        @identifiers.to_s(level)
    end
end

class Terminal
    def initialize(value, type)
        @value = value
        @type = type
    end
    
    def check
        @type
    end
end

# Nodo que contiene Numeros Enteros
class NumberNode < Terminal
    def initialize(value)
        super(value, :int)
    end
end

# Nodo que contiene caracteres de BOT
class CharNode < Terminal 
    def initialize(value)
        super(value, :char)
    end
end

# Nodo que contiene True o False
class BoolNode < Terminal
    def initialize(value)
        super(value, :bool)
    end
end

# Nodo que contiene una Variable
class VariableNode < Terminal 
    def initialize(value, type)
        super 
    end


    def check
        #Chequear en la tabla de simbolos?
    end
end

####################
# Tabla de Simbolos
####################

class SymAttribute 
    def initialize(type)
        @type = type
        @value = nil
        @behaviors = BehaviorListNone.new()
    end
end

# Clase que representa una Tabla de Simbolos
class SymbolTable
    def initialize(father)
        @father = father
        @symbols = Hash.new
    end

    def insert(name, type)
        if @symbols.key?(name) then 
            puts "variable #{name}, ya existe en la tabla de simbolos."
        else
            @symbols[name] = SymAttribute.new(type)
        end
    end

    def lookup(name)
        if @symbols.key?(name)
            return @symbols[name]
        end    
        @father.lookup(name) unless @father == nil
        puts "variable #{name} no existe."
        return false

    end

    def update(name, value)
        if var = self.lookup(name) then 
            var.value = value
        else
            puts "La variable no ha sido inicializada"
        end
    end
    
end