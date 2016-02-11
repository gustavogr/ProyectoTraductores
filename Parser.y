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

        # trantando de desambiguar la secuenciacion
        # el if tambien deberia dar problemas
        left SEQ 

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

        CREATE BOT EXECUTE ON READ RECIEVE ME END  
        
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
    | instruction =SEQ instruction 
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
    | botInstruction =SEQ botInstruction 
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
    | expression SUMA expression          
    | expression RESTA expression         
    | expression MULT expression          
    | expression DIV expression           
    | expression MOD expression           
    | RESTA expression =RESTA_UNARIA      
    | PARABRE expression PARCIERRA        
    | NEGACION expression                 
    | expression CONJUNCION expression    
    | expression DISYUNCION expression    
    | expression MENORIGUAL expression    
    | expression MAYORIGUAL expression    
    | expression IGUAL expression         
    | expression NOIGUAL expression       
    | expression MENOR expression         
    | expression MAYOR expression         
    ;
        
end