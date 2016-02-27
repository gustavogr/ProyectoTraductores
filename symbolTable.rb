class SymAttribute 
    def initialize(type)
        @type = type
        @value = nil
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