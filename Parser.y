# class CLASS_NAME
#   [precedance table]
#   [token declarations]
#   [expected number of S/R conflict]
#   [options]
#   [semantic value convertion]
#   [start rule]
# rule
#   GRAMMARS

class Parser

    prechigh
    
        right RESTA_UNARIA
        right NEGACION
        
        left MULT DIV MOD
        left SUMA RESTA
        left CONJUNCION
        left DISYUNCION
        
        nonassoc MENOR MAYOR MENORIGUAL MAYORIGUAL
        nonassoc IGUAL NOIGUAL

    preclow


    token 

        CREATE BOT EXECUTE ON READ RECIEVE ME END  
        
        ACTIVATION DEACTIVATION DEFAULT

        ACTIVATE DEACTIVATE ADVANCE IF ELSE WHILE 

        STORE COLLECT AS DROP LEFT RIGHT UP DOWN 

        INT BOOL CHAR

        MENORIGUAL MAYORIGUAL MENOR MAYOR IGUAL NOIGUAL CONJUNCION DISYUNCION NEGACION  
        
        SUMA RESTA MULT DIV MOD 

        COMA PUNTO DOSPUNTOS PARABRE PARCIERRA 

        IDENT CHARACTER NUM TRUE FALSE 
        RESTA_UNARIA

    start program

    rule

    program
    : CREATE declarationList EXECUTE instructionList END    { result = ProgramNode.new(val[3])}
    | EXECUTE instructionList END                           { result = ProgramNode.new(val[1])}
    ;

    declarationList
    : declaration
    | declarationList declaration
    ;

    declaration 
    : type BOT identifierList behaviorList END
    | type BOT identifierList END
    ;

    identifierList
    : IDENT                         { result = IdentListNode.new().add(val[0])}
    | identifierList COMA IDENT     { result = val[0].add(val[1])}
    ;

    type
    : INT
    | BOOL
    | CHAR 
    ;

    behaviorList
    : behavior
    | behaviorList behavior
    ;

    behavior
    : ON condition DOSPUNTOS botInstructionList END
    ; 

    botInstructionList
    : botInstruction
    | botInstructionList botInstruction
    ;

    botInstruction
    : STORE expression PUNTO
    | COLLECT AS IDENT PUNTO
    | COLLECT PUNTO
    | DROP expression PUNTO
    | direction PUNTO
    | direction expression PUNTO
    | READ PUNTO
    | READ AS IDENT PUNTO
    ;

    instructionList
    : instruction                       { result = InstListNode.new().add(val[0])}
    | instructionList instruction       { result = val[0].add(val[1])}
    ;

    instruction
    : ACTIVATE  identifierList  PUNTO       { result = BasicInstrNode.new(:ACTIVATE, val[1]) }
    | ADVANCE identifierList  PUNTO         { result = BasicInstrNode.new(:ADVANCE, val[1]) }
    | DEACTIVATE identifierList PUNTO       { result = BasicInstrNode.new(:DEACTIVATE, val[1]) }
    | conditional  
    | undfiter 
    | program
    ; 

    conditional
    : IF expression DOSPUNTOS instructionList END               { result = ConditionalNode.new(val[1], val[3], nil)}
    | IF expression DOSPUNTOS instructionList ELSE DOSPUNTOS instructionList END    {result = ConditionalNode.new(val[1], val[3], val[5])}
    ;

    undfiter
    : WHILE expression DOSPUNTOS instructionList END        { result = UndfIterNode.new(val[1], val[3])}
    ;

    direction
    : LEFT
    | RIGHT
    | UP
    | DOWN
    ;

    condition
    : ACTIVATION
    | DEACTIVATION
    | expression
    | DEFAULT
    ;

    literal
    : NUM                   { result = NumberNode.new(val[0]) }
    | TRUE                  { result = BoolNode.new(val[0]) }
    | FALSE                 { result = BoolNode.new(val[0]) }
    | CHARACTER             { result = CharNode.new(val[0]) }
    | IDENT                 { result = VariableNode.new(val[0]) }
    | ME                    { result = VariableNode.new(val[0]) }
    ;

    expression
    : literal
    | expression SUMA expression          { result = AritExprNode.new(:SUMA, val[0], val[2], :int) }
    | expression RESTA expression         { result = AritExprNode.new(:RESTA, val[0], val[2], :int) }
    | expression MULT expression          { result = AritExprNode.new(:MULT, val[0], val[2], :int) }
    | expression DIV expression           { result = AritExprNode.new(:DIV, val[0], val[2], :int) }
    | expression MOD expression           { result = AritExprNode.new(:MOD, val[0], val[2], :int) }
    | RESTA expression =RESTA_UNARIA      { result = UnExprNode.new(:RESTA, val[1], :int) }
    | PARABRE expression PARCIERRA        { result = val[1] }
    | NEGACION expression                 { result = UnExprNode.new(:NEGACION, val[1], :bool) }
    | expression CONJUNCION expression    { result = BoolExprNode.new(:CONJUNCION, val[0], val[2], :bool) }
    | expression DISYUNCION expression    { result = BoolExprNode.new(:DISJUNCION, val[0], val[2], :bool) }
    | expression MENORIGUAL expression    { result = RelExprNode.new(:MENORIGUAL, val[0], val[2], :bool) }
    | expression MAYORIGUAL expression    { result = RelExprNode.new(:MAYORIGUAL, val[0], val[2], :bool) }
    | expression IGUAL expression         { result = RelExprNode.new(:IGUAL, val[0], val[2], :bool) }
    | expression NOIGUAL expression       { result = RelExprNode.new(:NOIGUAL, val[0], val[2], :bool) }
    | expression MENOR expression         { result = RelExprNode.new(:MENOR, val[0], val[2], :bool) }
    | expression MAYOR expression         { result = RelExprNode.new(:MAYOR, val[0], val[2], :bool) }
    ;
        
end

---- inner

require "./ast.rb"

    def initialize(tokens)
        @tokens = tokens
    end

    def parser
        do_parse
    end

    def next_token
        @tokens.next_token
    end
