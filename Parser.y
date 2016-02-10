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

    #prechigh
      # nonassoc '++'
      # left     '*' '/'
      # left     '+' '-'
      # right    '='
    #preclow


    token 

        CREATE BOT EXECUTE IF ELSE WHILE INT BOOL CHAR STORE RECIEVE ON END ACTIVATE 
        ACTIVATION ADVANCE DEACTIVATE DEACTIVATION DEFAULT COLLECT AS DROP LEFT RIGHT UP 
        DOWN READ TRUE FALSE MENORIGUAL MAYORIGUAL NOIGUAL CONJUNCION DISYUNCION NEGACION 
        MENOR MAYOR IGUAL COMA PUNTO DOSPUNTOS PARABRE PARCIERRA SUMA RESTA MULT DIV MOD 
        IDENT CHARACTER NUM ME

    rule

    S
    : program
    ;

    program
    : CREATE declarationList EXECUTE instructionList END
    | EXECUTE instructionList END
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
    : IDENT 
    | identifierList COMA IDENT
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
    : ON condition DOSPUNTOS botInstruction END
    ; 

    instructionList
    : instruction 
    | instructionList instruction 
    ;

    instruction
    : ACTIVATE  identifierList  PUNTO
    | ADVANCE identifierList  PUNTO
    | DEACTIVATE identifierList PUNTO
    | instruction instruction 
    | conditional  
    | undfiter 
    | program
    ; 

    conditional
    : IF expression DOSPUNTOS instruction END
    | IF expression DOSPUNTOS instruction ELSE DOSPUNTOS instruction END
    ;

    undfiter
    : WHILE expression DOSPUNTOS instruction END
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
    | botInstruction botInstruction
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
    : NUM
    | TRUE
    | FALSE
    | CHARACTER
    | IDENT 
    | ME
    ;

    expression
    : literal
    | expression SUMA expression           { puts val[1]}
    | expression RESTA expression          { puts val[1]}
    | expression MULT expression           { puts val[1]}
    | expression DIV expression            { puts val[1]}
    | expression MOD expression            { puts val[1]}
    | RESTA expression                     { puts val[1]}
    | PARABRE expression PARCIERRA         { puts val[1]}
    | NEGACION expression                  { puts val[1]}
    | expression CONJUNCION expression     { puts val[1]}
    | expression DISYUNCION expression     { puts val[1]}
    | expression MENORIGUAL expression     { puts val[1]}
    | expression MAYORIGUAL expression     { puts val[1]}
    | expression IGUAL expression          { puts val[1]}
    | expression NOIGUAL expression        { puts val[1]}
    | expression MENOR expression          { puts val[1]}
    | expression MAYOR expression          { puts val[1]}
    ;
        
end