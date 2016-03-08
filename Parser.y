# Parser.y
# 
# Archivo que usa la herramienta para generar el Parser
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

        STORE COLLECT AS DROP LEFT RIGHT UP DOWN SEND READ 

        INT BOOL CHAR

        MENORIGUAL MAYORIGUAL MENOR MAYOR IGUAL NOIGUAL CONJUNCION DISYUNCION NEGACION  
        
        SUMA RESTA MULT DIV MOD RESTA_UNARIA

        COMA PUNTO DOSPUNTOS PARABRE PARCIERRA 

        IDENT CHARACTER NUM TRUE FALSE 
        

    start program

    rule

    program
    : CREATE declarationList EXECUTE instructionList END    { result = ProgramNode.new(val[3], val[1]) }
    | EXECUTE instructionList END                           { result = ProgramNode.new(val[1], SymbolTable.new()) }
    ;

    declarationList
    : declaration                                           { result = SymbolTable.new().insertL(val[0][0], val[0][1], val[0][2]) }           
    | declarationList declaration                           { result = val[0].insertL(val[1][0], val[1][1], val[1][2]) }
    ;

    declaration 
    : type BOT identifierList behaviorList END              { result = [ val[2], val[0], val[3] ] }
    | type BOT identifierList END                           { result = [ val[2], val[0], BehaviorListNode.new() ] }
    ;

    identifierList
    : IDENT                         { result = IdentListNode.new().add(VariableNode.new(val[0])) }
    | identifierList COMA IDENT     { result = val[0].add(VariableNode.new(val[2])) } 
    ;

    type
    : INT           { result = :INT }
    | BOOL          { result = :BOOL }
    | CHAR          { result = :CHAR }
    ;

    behaviorList
    : behavior                  { result = BehaviorListNode.new().add(val[0]) }
    | behaviorList behavior     { result = val[0].add(val[1]) }
    ;

    behavior
    : ON condition DOSPUNTOS botInstructionList END     { result = BehaviorNode.new(val[1],val[3]) }
    ; 

    botInstructionList
    : botInstruction                        { result = BotInstListNode.new().add(val[0]) }
    | botInstructionList botInstruction     { result = val[0].add(val[1]) }
    ;

    botInstruction
    : STORE expression PUNTO            { result = StoreNode.new(val[1]) }        
    | COLLECT AS IDENT PUNTO            { result = CollectNode.new(val[2]) }
    | COLLECT PUNTO                     { result = CollectNode.new() }
    | DROP expression PUNTO             { result = DropNode.new(val[1]) }
    | direction PUNTO                   { result = MoveNode.new(val[0]) }
    | direction expression PUNTO        { result = MoveNode.new(val[0], val[1]) }
    | READ PUNTO                        { result = ReadNode.new() }
    | READ AS IDENT PUNTO               { result = ReadNode.new(val[2]) }
    | SEND PUNTO                        { result = SendNode.new() }
    ;

    instructionList
    : instruction                       { result = InstListNode.new().add(val[0]) }
    | instructionList instruction       { result = val[0].add(val[1]) }
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
    : IF expression DOSPUNTOS instructionList END               { result = ConditionalNode.new(val[1], val[3], nil) }
    | IF expression DOSPUNTOS instructionList ELSE DOSPUNTOS instructionList END    {result = ConditionalNode.new(val[1], val[3], val[6]) }
    ;

    undfiter
    : WHILE expression DOSPUNTOS instructionList END        { result = UndfIterNode.new(val[1], val[3]) }
    ;

    direction
    : LEFT                  { result = :LEFT }
    | RIGHT                 { result = :RIGHT }
    | UP                    { result = :UP }
    | DOWN                  { result = :DOWN }
    ;

    condition
    : ACTIVATION            { result = :ACTIVATION }
    | DEACTIVATION          { result = :DEACTIVATION }
    | expression
    | DEFAULT               { result = :DEFAULT }
    ;

    literal
    : NUM                   { result = NumberNode.new(val[0]) }
    | TRUE                  { result = BoolNode.new(val[0]) }
    | FALSE                 { result = BoolNode.new(val[0]) }
    | CHARACTER             { result = CharNode.new(val[0]) }
    | IDENT                 { result = VariableNode.new(val[0]) }
    | ME                    { result = VariableNode.new('me') }
    ;

    expression
    : literal
    | expression SUMA expression          { result = AritExprNode.new(:SUMA, val[0], val[2]) }
    | expression RESTA expression         { result = AritExprNode.new(:RESTA, val[0], val[2]) }
    | expression MULT expression          { result = AritExprNode.new(:MULT, val[0], val[2]) }
    | expression DIV expression           { result = AritExprNode.new(:DIV, val[0], val[2]) }
    | expression MOD expression           { result = AritExprNode.new(:MOD, val[0], val[2]) }
    | RESTA expression =RESTA_UNARIA      { result = UnExprNode.new(:RESTA, val[1], :int) }
    | PARABRE expression PARCIERRA        { result = val[1] }
    | NEGACION expression                 { result = UnExprNode.new(:NEGACION, val[1], :bool) }
    | expression CONJUNCION expression    { result = BoolExprNode.new(:CONJUNCION, val[0], val[2]) }
    | expression DISYUNCION expression    { result = BoolExprNode.new(:DISJUNCION, val[0], val[2]) }
    | expression MENORIGUAL expression    { result = RelExprNode.new(:MENORIGUAL, val[0], val[2]) }
    | expression MAYORIGUAL expression    { result = RelExprNode.new(:MAYORIGUAL, val[0], val[2]) }
    | expression IGUAL expression         { result = RelExprNode.new(:IGUAL, val[0], val[2]) }
    | expression NOIGUAL expression       { result = RelExprNode.new(:NOIGUAL, val[0], val[2]) }
    | expression MENOR expression         { result = RelExprNode.new(:MENOR, val[0], val[2]) }
    | expression MAYOR expression         { result = RelExprNode.new(:MAYOR, val[0], val[2]) }
    ;
        
end

---- inner

require "./classes.rb"

    def initialize(tokens)
        @tokens = tokens
    end

    def parse
        do_parse
    end

    def next_token
        @tokens.next_token
    end
