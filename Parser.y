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
    : instruction 
    | instructionList instruction 
    ;

    instruction
    : ACTIVATE  identifierList  PUNTO
    | ADVANCE identifierList  PUNTO
    | DEACTIVATE identifierList PUNTO 
    | conditional  
    | undfiter 
    | program
    ; 

    conditional
    : IF expression DOSPUNTOS instructionList END
    | IF expression DOSPUNTOS instructionList ELSE DOSPUNTOS instructionList END
    ;

    undfiter
    : WHILE expression DOSPUNTOS instructionList END
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