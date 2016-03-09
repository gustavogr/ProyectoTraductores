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

class ContextError < StandardError
end


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
    
    def check
        @symTable.checkBehaviors                         
        @symTable.father = $currentTable
        $currentTable = @symTable
        @instructions.check 
        $currentTable = @symTable.father
    end

    def eval
        @instructions.eval
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
    
    def check
        @instList.each {|inst| inst.check}
    end

    def eval
        @instList.each {|inst| inst.eval}
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
end

class BehaviorNode

    attr_accessor :symTable
    attr_reader :condition

    def initialize(condition, instructions)
        @condition = condition
        @instructions = instructions
        @symTable = SymbolTable.new()
    end
    
    def check
        oldTable = $currentTable
        $currentTable = @symTable 
        if @condition != :ACTIVATION and @condition != :DEACTIVATION and @condition != :DEFAULT then
            @condition.check == :BOOL # aqui no deberia levantarse una excepcion?
        end
        @instructions.check
        $currentTable = oldTable
    end

    def eval
        @instructions.eval
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

    def eval
       @instList.each {|inst| inst.eval}
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
            behavior.check()
            raise ContextError, "Error: condiciones de robot" if ac > 1 or deac > 1 or default > 1
            raise ContextError, "Error: condicion default de robot no se encuentra al final." if default == 1 and cond != :DEFAULT 
        }

    end

    def eval(inst)
        case inst
        when :ACTIVATE
            @bhList.each {|behavior|
                if behavior.condition == :ACTIVATION then
                    behavior.eval; break
                end
            }
        when :ADVANCE
            @bhList.each {|behavior|
                bc = behavior.condition
                if (bc != :ACTIVATION and bc != :DEACTIVATION and bc.eval) or bc == :DEFAULT then
                    behavior.eval; break
                end
            }
        when :DEACTIVATE
            @bhList.each {|behavior|
                if behavior.condition == :DEACTIVATION then
                    behavior.eval; end
                end
            }
        end
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
            raise ContextError, "Store: tipo de la expresion #{@expr} no es compatible con el BOT."
        end
    end

    def eval
        $currentTable.update("me", @expr.eval)
    end

end

# Guarda el valor de la matriz en el robot
class CollectNode
    def initialize(ident="me")
        @ident = ident
    end

    def check
        meType = $currentTable.lookup('me').type
        $currentTable.insert(@ident, SymAttribute.new(meType,nil)) unless @ident == "me"
    end

    def eval
        raise "valor de matriz incompatible con el robot" if vm.type != $currentTable.lookup('me').type or vm = nil
        #$currentTable.update("me", VALOR_MATRIZ)
    end

end

class DropNode
    def initialize(expr)
        @expr = expr
    end

    def check
        @expr.check
    end

    def eval
        #pos = $currentTable.lookup('me').position
        #matriz[pos] = @expr.eval
    end
end

class MoveNode
    def initialize(to, expr=nil)
        @to = to
        @expr = expr
    end
    
    def check
        expT = @expr.check unless @expr == nil # luego debe ser no negativa
        raise ContextError, "Move: #{@expr} no es de tipo entero." unless @expr == nil or expT == :INT
    end

    def eval
        steps = @expr ? @expr.eval : 1 # me exito esta linea xD

        raise "Movimiento negativo" if steps < 0

        bot = $currentTable.lookup('me')
        case @to
        when :LEFT 
            bot.pos[:x] -= steps                
        when :RIGHT 
            bot.pos[:x] += steps
        when :UP 
            bot.pos[:y] += steps
        when :DOWN
            bot.pos[:y] -= steps
        end
    end
end

class ReadNode
    def initialize(ident="me")
        @ident = ident
    end

    def check
        meType = $currentTable.lookup('me').type
        $currentTable.insert(@ident, SymAttribute.new(meType,nil)) unless @ident == "me"
    end

    def eval
        tmp = gets.chomp
        # hay que volver a pasarle el lexer a esto? xD 
        # quizas y estoy mamao        
    end
end

class SendNode
    def initialize
    end

    def check
    end

    def eval
        #peitos de saltos de linea incoming
        print $currentTable.lookup('me').value
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
    
    def check
        @identList.each {|ident| ident.check}
    end

    def eval(inst)
        @identList.each {|ident| ident.eval(inst)}

    def to_s(level)
        printable = ""
        var = "- var: "
        @identList.each {|ident| printable += "    "*level + var + ident.to_s(level + 1) + "\n"}
        printable
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
        raise ContextError, "Error de tipo. Operador:#{@operator}. Tipo de operando: #{expT}." unless expT == @type
        @type
    end

    def eval
        case @operator
        when :RESTA
            @expr.eval * (-1)
        when :NEGACION
            not @expr.eval
        end
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
        raise ContextError, "Error de tipo. Operador: #{@op}. Tipos de operando #{exp1} #{exp2}" unless exp1 == @type and exp1 == exp2
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

    def eval
        case @operator
        when :SUMA
            @expr1.eval + @expr2.eval
        when :RESTA
            @expr1.eval - @expr2.eval
        when :MULT
            @expr1.eval * @expr2.eval
        when :DIV
            @expr1.eval / @expr2.eval
        when :MOD
            @expr1.eval % @expr2.eval
        end
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

    def eval
        case @operator
        when :CONJUNCION
            @expr1.eval and @expr2.eval
        when :DISYUNCION
            @expr1.eval or @expr2.eval
        end
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
        raise ContextError, "Error de tipo. Operador: #{@op}. Tipos de operando #{exp1} #{exp2}" unless (exp1 == :INT or exp1 == :BOOL) and exp1 == exp2
        @type 
    end

    def eval
        case @operator
        when :MENOR
            @expr1.eval < @expr2.eval
        when :MAYOR
            @expr1.eval > @expr2.eval            
        when :MENORIGUAL
            @expr1.eval <= @expr2.eval
        when :MAYORIGUAL
            @expr1.eval >= @expr2.eval
        when :IGUAL
            @expr1.eval == @expr2.eval
        when :NOIGUAL
            @expr1.eval != @expr2.eval
        end
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
        raise ContextError, "Error: Expresion de condicional no es de tipo booleano." unless @condition.check == :BOOL
        @ifBody.check
        @elseBody.check unless @elseBody == nil
    end

    def eval
        @condition.eval ? @ifBody.eval : (@elseBody.eval unless elseBody == nil)
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
        raise ContextError, "Error: Condicion de Iteracion no es de tipo booleano." unless @condition.check == :BOOL
        @body.check
    end

    def eval
        #el peo aqui de quedarse pegado?
        while @condition.eval do
            @body.eval
        end
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

    def eval
        @identifiers.eval(id)
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

    def eval
        @value
    end

    def to_s(level)
        @value
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

    def eval
    end
end

# Nodo que contiene True o False
class BoolNode < Terminal
    def initialize(value)
        super(value, :BOOL)
    end

    # Me valgo de que aqui solo entra TRUE Y FALSE
    def eval
        value == "TRUE"
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
            raise ContextError, "Variable #{@value} no inicializada."
        end      
    end

    def eval(inst)
        robot = $currentTable.lookup(@value)
        case inst
        when :ACTIVATE
            raise "reactivacion de robot" if robot.state == :ACT
        when :ADVANCE
            raise "avance de robot desactivado" if robot.state == :DEACT
        when :DEACTIVATE
            raise "redesactivacion de robot" if robot.state == :DEACT
        end

        robot.behaviors.eval(inst)
    end


end

####################
# Tabla de Simbolos
####################

class SymAttribute 
    attr_accessor :value, :state, :position 
    attr_reader :type, :behaviors

    def initialize(type, behaviors)
        @type = type
        @value = nil
        @behaviors = behaviors
        @state = :DEACT
        @position = { x => 0, y => 0}
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
            raise ContextError, "Redeclaracion de la variable #{name}."
        else
            @symbols[name] = attributes
            self
        end
    end

    def lookup(name)
        if @symbols.key?(name)
            return @symbols[name]
        end    
        return @father.lookup(name) unless @father == nil
        return false
    end

    def update(name, value)
        if var = self.lookup(name) then 
            var.value = value
        else
            raise ContextError, "La variable #{name} no ha sido inicializada"
        end
    end

    def checkBehaviors()
        @symbols.each { |key, attributes|
            attributes.behaviors.initTables(attributes)
            attributes.behaviors.check()
        }
    end
    
end