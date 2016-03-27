class ProgramMatrix
    def initialize
        @filled = {}
    end

    def add(x,y,value,type)
        begin
            @filled[x][y] = [value, type]
        rescue NoMethodError
            @filled[x] = {}
            @filled[x][y] = [value, type] 
        end
    end

    def get(x,y)
        begin
            @filled[x][y]
        rescue
            nil
        end 
    end
end