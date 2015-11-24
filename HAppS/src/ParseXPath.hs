module ParseXPath(XPath(..), xpath, xpathTest) where

import qualified Text.ParserCombinators.Parsec.Token as P
import Text.ParserCombinators.Parsec.Language(LanguageDef (..)  )
import Text.ParserCombinators.Parsec

data XPath = StartExpr XPath
        | LocationStep String XPath
        | PredicateTest XPath XPath
        | FunctionCall String [XPath] XPath
        | Expression XPath String XPath
        | Literal String
        | EndOfExpr

instance Show XPath where
    show = showXPath

showXPath :: XPath -> String
showXPath (StartExpr firstPath) = showXPath firstPath
showXPath (LocationStep name nextPath) = "/" ++ name ++ (showXPath nextPath)
showXPath (PredicateTest exp nextPath) = "[" ++ (show exp) ++ "]" ++ (showXPath nextPath)
showXPath (FunctionCall func exps nextPath) = func ++ "(" ++ (commaSeperate (map show exps)) ++ ")" ++ (showXPath nextPath)
showXPath (Expression left op right) =  (show left)++op++(show right)
showXPath (Literal lit) = lit
showXPath (EndOfExpr) = "{eoe}"

commaSeperate [] = []
commaSeperate (c:[]) = c
commaSeperate (c:cs) = (c++", "++commaSeperate(cs))
{------------- Location Paths --------------------}

--naturalOrFloat  :: CharParser st (Either Integer Double)
float = P.float

xpathTest = parseTest startLocationPath

xpath :: String -> XPath
xpath input = case (parse startLocationPath "" input) of
                    Left err -> EndOfExpr
                    Right x ->  x


nextPredicateLocationStepOrFunctionCall = do{ notFollowedBy (char ']')
                                            ; res <- nPLSFChelper
                                            ; return res
                                            } <|> (return $ EndOfExpr)--(return $ LocationStep "oops" $EndOfExpr )

nPLSFChelper = try(endOfExpression) <|> try(functionCall) <|> try(predicate) <|> try(locationPath)  {-<|> attributeSpecifier-} <?> "following expression"



-- ']' -> EndOfExpr
-- not ']' -> Fail otherwise (-> ']' -> endofexpr)


--[4] Step ::= AxisSpecifier NodeTest Predicate* | AbbreviatedStep
--[5] AxisSpecifier ::= AxisName '::' | AbbreviatedAxisSpecifier
--[6] AxisName ::= 'ancestor' | 'ancestor-or-self' | 'attribute' | 'child' | 'descendant' | 'descendant-or-self' | 'following'
--              | 'following-sibling' | 'namespace' | 'parent' | 'preceding' | 'preceding-sibling' | 'self'

--[7] NodeTest ::= NameTest | NodeType '(' ')' | 'processing-instruction' '(' Literal ')'
--nodeTest = nameTest -- add rest later

--[10] AbbreviatedAbsoluteLocationPath   ::=  '//' RelativeLocationPath
--[11] AbbreviatedRelativeLocationPath   ::=  RelativeLocationPath '//' Step
--[12] AbbreviatedStep                   ::=  '.' | '..'
--[13] AbbreviatedAxisSpecifier          ::=  '@'?


--[15] PrimaryExpr ::= VariableReference | '(' Expr ')' | Literal | Number | FunctionCall
primaryExpr :: Parser XPath
primaryExpr =  try(functionCall) <|> literal <?> "maybe you should finish primaryExpr"

literal :: Parser XPath
literal = do{ val <- many1 alphaNum
                ; return $ Literal val
        } <?> "primary expression"

--[18] UnionExpr ::= PathExpr | UnionExpr '|' PathExpr --uh-huh...

--[19] PathExpr ::=  LocationPath | FilterExpr | FilterExpr '/' RelativeLocationPath | FilterExpr '//' RelativeLocationPath

--[20] FilterExpr ::=   PrimaryExpr | FilterExpr Predicate --filterExpr??

--[27] UnaryExpr ::= UnionExpr | '-' UnaryExpr

--[28] ExprToken ::= '(' | ')' | '[' | ']' | '.' | '..' | '@' | ',' | '::'
--                | NameTest | NodeType | Operator | FunctionName | AxisName | Literal | Number | VariableReference

--[29] Literal   ::=   '"' [^"]* '"' | "'" [^']* "'"

--[35] FunctionName ::= QName - NodeType

--[37] NameTest ::= '*' | NCName ':' '*' | QName

--[38] NodeType ::= 'comment' | 'text' | 'processing-instruction' | 'node'

{---------- Add to Me:  -------------}
--[21] OrExpr  ::=   AndExpr | OrExpr 'or' AndExpr
--[22] AndExpr ::= EqualityExpr | AndExpr 'and' EqualityExpr
--[23] EqualityExpr ::= RelationalExpr| EqualityExpr '=' RelationalExpr | EqualityExpr '!=' RelationalExpr
--[24] RelationalExpr ::= AdditiveExpr | RelationalExpr '<' AdditiveExpr | RelationalExpr '>' AdditiveExpr | RelationalExpr '<=' AdditiveExpr | RelationalExpr '>=' AdditiveExpr
--[25] AdditiveExpr ::=   MultiplicativeExpr | AdditiveExpr '+' MultiplicativeExpr | AdditiveExpr '-' MultiplicativeExpr
--[26] MultiplicativeExpr ::= UnaryExpr | MultiplicativeExpr MultiplyOperator UnaryExpr | MultiplicativeExpr 'div' UnaryExpr | MultiplicativeExpr 'mod' UnaryExpr
--[32] Operator ::= OperatorName | MultiplyOperator | '/' | '//' | '|' | '+' | '-' | '=' | '!=' | '<' | '<=' | '>' | '>='
--[33] OperatorName ::=  'and' | 'or' | 'mod' | 'div'
--[34] MultiplyOperator ::=  '*'
operator :: Parser String -- This is wildly inefficient
operator = try(string "<=") <|> try(string ">=") <|> try(string "=") <|> try(string "!=")
        <|> try(string "and") <|> try(string "or") <|> try(string "+") <|> try(string "-")
        <|> try(string "div") <|> try(string "mod") <|> try(string "*") <|> try(string "|")
        <|> try(string "<") <|> try(string ">") <?> "operator"


{----- Only necesary for XSLT -------}
--[36] VariableReference ::= '$' QName

{-------- Tested/Finished  ----------}
{-------- below this point ----------}
--[1] LocationPath ::= RelativeLocationPath | AbsoluteLocationPath
startLocationPath :: Parser XPath
startLocationPath = do{ root <- locationPath
                        ; return $ StartExpr $ root
                        }<?> "XPath Expression"
--locationPath elem = try{absoluteLocationPath)<|>(relativeLocationPath)

rootOnly :: Parser XPath
rootOnly = do{ char '/'
        ; end <- endOfExpression
        ; return end
        }
--[2] AbsoluteLocationPath ::= '/' RelativeLocationPath? | AbbreviatedAbsoluteLocationPath
--[3] RelativeLocationPath ::= Step | RelativeLocationPath '/' Step | AbbreviatedRelativeLocationPath
locationPath :: Parser XPath
locationPath = do{ char '/'
                ; name <- many1 (letter)  --try manyTill? --what if the first thing is a function call or AbbreviatedAbsoluteLocationPath e.g. '//'
                ; following <- nextPredicateLocationStepOrFunctionCall
                ; return $ LocationStep name following
                } <?> "absoluteLocationPath"

--[8] Predicate ::= '[' PredicateExpr ']'
predicate :: Parser XPath
predicate = do{ test <- between (char '[') (char ']') predicateExpr
                ; following <- nextPredicateLocationStepOrFunctionCall
                ; return $ PredicateTest test following
                } <?> "predicate expression"

--[9] PredicateExpr ::= Expr
predicateExpr :: Parser XPath
predicateExpr =  expr <?> "predicate expression"

--[14] Expr ::= OrExpr
expr :: Parser XPath
expr = try(primaryExpr) <|> try(opExpr) <?> "Expression"

opExpr :: Parser XPath
opExpr = do{ left <- primaryExpr --try(functionCall) <|> many alphaNum
           ;spaces
           ;op <- operator
           ;spaces
           ;right <- primaryExpr --manyTill anyChar (char endChar)
           ;return $ Expression left op right
        } <?> "expr"

--[16] FunctionCall ::= FunctionName '(' ( Argument ( ',' Argument )* )? ')'
functionCall :: Parser XPath
functionCall = do{ skipMany $ char '/' --try(char '/')
                 ; name <- many (noneOf "(/[")
                 ; args <- between (char '(') (char ')') functionArgs
                 ; next <- nextPredicateLocationStepOrFunctionCall
                 ; return $ FunctionCall name args next
                 } <?> "function"

--[17] Argument ::= Expr
functionArgs :: Parser [XPath] --doesn't do multiple args?
functionArgs = do{
                ; args <- sepBy expr (char ',')
                ; return $ args
                } <?> "function arguments"

--[30] Number ::= Digits ('.' Digits?)? | '.' Digits
number :: Parser Double
number = try(decimalNumber) <|> digits <?> "number"

decimalNumber :: Parser Double
decimalNumber = do{ number <- many1 (digit)
                ; char '.'
                ; dec <- many digit
                ; return (read (number++"."++dec)::Double)
        } <?> "decimal number"

--[31] Digits ::= [0-9]+
digits  :: Parser Double
digits  = do{ ds <- many1 digit
            ; return (read ds::Double)
            }

--[39] ExprWhitespace ::= S
exprWhitespace :: Parser ()
exprWhitespace = spaces

endOfExpression :: Parser XPath
endOfExpression = do{ eof
                ; return EndOfExpr
                } <?> "EndOfExpression"

