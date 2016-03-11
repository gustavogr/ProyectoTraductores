class ProgramMatrix
    def initialize
        @filled = {}
    end

    def add(x,y,value)
        begin
            @filled[x][y] = value.to_s
        rescue NoMethodError
            @filled[x] = {}
            @filled[x][y] = value.to_s 
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