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

$currentTable = nil

# Nodo que simboliza el programa.
class ProgramNode
    def initialize(instructions, symTable)
        @symTable = symTable
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
    
    ###########
    # DEBUGGEO
    ###########
    def printSymTable()
        p @symTable
    end

    def check
        @symTable.checkBehaviors                         
        @symTable.father = $currentTable
        $currentTable = @symTable
        @instructions.check 
        $currentTable = @symTable.father
    end
end




# Nodo que contiene una lista de instruciones
class InstListNode 
    def initialize
        @instList = []        
    end

    def add(inst)
        @instList << inst
        self 
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

class BehaviorNode

    attr_accessor :symTable

    def initialize(condition, instructions)
        @condition = condition
        @instructions = instructions
        @symTable = SymbolTable.new()
    end
    
    def check
        oldTable = $currentTable
        $currentTable = @symTable 
        if @condition != :ACTIVATION and @condition != :DEACTIVATION and @condition != :DEFAULT then
            @condition.check == :BOOL
        end
        @instructions.check
        $currentTable = oldTable
    end

    def duplicate
        result = self.clone
        result.symTable = SymbolTable.new()
        result
    end

end

class BotInstListNode
    def initialize
        @instList = []
    end

    def add(inst)
        @instList << inst
        self
    end

    def check
       @instList.each {|inst| inst.check} 

    end
end


class BehaviorListNode
    def initialize
        @bhList = []
    end

    def add(inst)
        @bhList << inst
        self
    end

    def initTables(bot)
        @bhList.each { |behavior|
            behavior.symTable.insert("me", bot)
        }
    end

    def check
        ac = deac = default = 0

        @bhList.each {|behavior| 
            cond = behavior.condition
            ac += 1 if cond == :ACTIVATION 
            deac += 1 if cond == :DEACTIVATION
            default += 1 if cond == :DEFAULT
            $currentTable = behavior.symTable
            raise "Error: condiciones de robot" if ac > 1 or deac > 1 or default > 1
        }
        raise "Error: condicion default de robot no se encuentra al final." if default == 1 and cond != :DEFAULT 

    end

    def duplicate
        result = BehaviorListNode.new()
        @bhList.each { |behavior| 
            result.add(behavior.duplicate)
        }
        result
    end

end

class StoreNode
    def initialize(expr)
        @expr = expr
    end

    def check
        exprT = @expr.check
        if $currentTable.lookup("me").type != exprT then
            raise "Store: tipo de la expresion #{@expr} no es compatible con el BOT."
        end
    end

end

# Guarda el valor de la matriz en el robot
class CollectNode
    def initialize(ident="me")
        @ident = ident
        $currentTable.insert(ident, :UNDEF) unless ident == "me"
    end

    def check
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
        expT = @expr.check unless @expr == nil # luego debe ser no negativa
        raise "Move: #{@expr} no es de tipo entero." unless @expr == nil or expT == :INT
    end
    
end

class ReadNode
    def initialize(ident="me")
        @ident = ident
        $currentTable.insert(ident, :UNDEF) unless ident == "me"
    end

    def check
    end
end

class SendNode
    def initialize
    end

    def check
    end
end

# Nodo que contiene una lista de Identificadores
class IdentListNode 
    attr_accessor :identList 

    def initialize
        @identList = []        
    end

    def add(ident)
        @identList << ident 
        self
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
        raise "Error: #{@operator} #{expT}" unless expT == @type or expT == :UNDEF
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
        raise "Error: #{exp1} #{@op} #{exp2}" unless (exp1 == @type and exp1 == exp2) or exp1 == :UNDEF or exp2 == :UNDEF
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
        super(operator, expr1, expr2, :INT)
    end

    def to_s(level)
        "ARIT_EXPR\n" + super
    end
end

# Nodo que contiene una Expresion Booleana
class BoolExprNode < BinExprNode
    def initialize(operator, expr1, expr2)
        super(operator, expr1, expr2, :BOOL)
    end

    def to_s(level)
        "BOOL_EXPR\n" + super
    end
end

# Nodo que contiene una Expresion Relacional
class RelExprNode < BinExprNode
    def initialize(operator, expr1, expr2)
        super(operator, expr1, expr2, :BOOL)
    end

    def check
        exp1 = @expr1.check
        exp2 = @expr2.check
        raise "Error: #{exp1} #{@op} #{exp2}" unless ((exp1 == :INT or exp1 == :BOOL) and exp1 == exp2) or
                                                                            exp1 == :UNDEF or exp2 == :UNDEF
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
        raise "Error: Expresion de Condicional" unless @condition.check == :BOOL
        @ifBody.check
        @elseBody.check unless @elseBody == nil
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
        raise "Error: Condicion de Iteracion" unless @condition.check == :BOOL
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
    
    def to_s(level)
        @value
    end

    def check
        @type
    end
end

# Nodo que contiene Numeros Enteros
class NumberNode < Terminal
    def initialize(value)
        super(value, :INT)
    end
end

# Nodo que contiene caracteres de BOT
class CharNode < Terminal 
    def initialize(value)
        super(value, :CHAR)
    end
end

# Nodo que contiene True o False
class BoolNode < Terminal
    def initialize(value)
        super(value, :BOOL)
    end
end

# Nodo que contiene una Variable
class VariableNode < Terminal 
    attr_accessor :value

    def initialize(value)
        super(value, :ident)
    end


    def check      
        if result = $currentTable.lookup(@value) then
            return result.type
        else
            raise "Variable #{@value} no inicializada."
        end      
    end
end

####################
# Tabla de Simbolos
####################

class SymAttribute 
    attr_accessor :value 
    attr_reader :type, :behaviors

    def initialize(type, behaviors)
        @type = type
        @value = nil
        @behaviors = behaviors
    end
end

# Clase que representa una Tabla de Simbolos
class SymbolTable
    attr_accessor :father

    def initialize()
        @father = father
        @symbols = Hash.new
    end

    def insertL(list, type, behaviors)
        list.identList.each {|ident| insert(ident.value, SymAttribute.new(type,behaviors.duplicate))}
        self
    end

    def insert(name, attributes)
        if @symbols.key?(name) then 
            raise "Redeclaracion de la variable #{name}."
        else
            @symbols[name] = attributes
            self
        end
    end

    def lookup(name)
        if @symbols.key?(name)
            return @symbols[name]
        end    
        @father.lookup(name) unless @father == nil
        return false
    end

    def update(name, value)
        if var = self.lookup(name) then 
            var.value = value
        else
            raise "La variable #{name} no ha sido inicializada"
        end
    end

    def checkBehaviors()
        @symbols.each { |key, attributes|
            attributes.behaviors.initTables(attributes)
            attributes.behaviors.check()
        }
    end
    
end