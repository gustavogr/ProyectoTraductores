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
        left MULT DIV MOD
        left PLUS MINUS
        
        right NEGACION
        left CONJUNCION
        left DISYUNCION
        
        nonassoc MENOR MAYOR MENORIGUAL MAYORIGUAL
        nonassoc IGUAL NOIGUAL


    preclow


    token 

        CREATE BOT EXECUTE 

        ON READ RECIEVE ME END  
        
        ACTIVATION DEACTIVATION DEFAULT

        ACTIVATE DEACTIVATE ADVANCE IF ELSE WHILE 

        STORE COLLECT AS DROP LEFT RIGHT UP DOWN 

        INT BOOL CHAR

        MENORIGUAL MAYORIGUAL MENOR MAYOR IGUAL NOIGUAL CONJUNCION DISYUNCION NEGACION  
        
        SUMA RESTA MULT DIV MOD 

        COMA PUNTO DOSPUNTOS PARABRE PARCIERRA 

        IDENT CHARACTER NUM TRUE FALSE 

    start program

    rule

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
    | RESTA expression =RESTA_UNARIA       { puts val[1]}
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