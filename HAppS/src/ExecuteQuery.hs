module ExecuteQuery( evaluate, evalWith) where
import ParseXML (XMLElement(..), parseTestToElem, parseTestNumToElem)
import ParseXPath (XPath(..), xpath, xpathTest)

------------------------------------------------------------------
--data XMLElement = Attr String String String			--
--	| Element String String [XMLElement] [XMLElement]	--
--	| RootElement XMLElement				--
--	| CharData String String				--
------------------------------------------------------------------

----------------------------------------------------------
--data XPath = StartExpr XPath				--
--	| LocationStep String 		XPath		--
--	| PredicateTest XPath 		XPath		--
--	| FunctionCall String [XPath] 	XPath		--
--	| Expression XPath String XPath			--
--	| Literal String				--
--	| EndOfExpr					--
----------------------------------------------------------

testEval query = evaluateQuery (xpath query) ((parseTestToElem):[])
--test :: IO ()
test = do
    assertEqual "(xpath \"/CATALOG\")" 		"[<CATALOG>...</CATALOG>]" 			(testEval "/CATALOG")
    assertEqual "(xpath \"/CATALOG\")" 		"[<CATALOG>...</CATALOG>]" 			(testEval "/CATALOG/")
    assertEqual "(testEval \"/CATALOG/PLANT\")" "[<PLANT>...</PLANT>,<PLANT>...</PLANT>]" 	(testEval "/CATALOG/PLANT")
    -- assertEqual "(testEval \"/CATALOG/last()\")" "[<PLANT>...</PLANT>]" 	(testEval "/CATALOG/last()") --should return error
    assertEqual "(testEval \"/CATALOG[last()]\")" "[<CATALOG>...</CATALOG>]" 	(testEval "/CATALOG[last()]")
    assertEqual "(testEval \"/CATALOG/PLANT[last()]\")" "[<PLANT>...</PLANT>]" 	(testEval "/CATALOG/PLANT[last()]") --bad test case (incorrect/hard to tell on the answer)
    assertEqual "(testEval \"/CATALOG[last()]/PLANT\")" "[<PLANT>...</PLANT>,<PLANT>...</PLANT>]" 	(testEval "/CATALOG[last()]/PLANT")
    
    return ()
    
commaSeperate [] = []
commaSeperate (c:[]) = "\""++c++"\""
commaSeperate (c:cs) = ("\""++c++"\", "++commaSeperate(cs))

-- data Result = NodeSet [String]
	-- | Number Float
	-- | Str String
	-- | Boolean Bool
	
evalWith querynum query filenum = makeJSCommand querynum $ getIDs $ evaluateQuery (xpath query) ((parseTestNumToElem filenum):[])
--evalWith querynum query filenum = "alert(" ++ (show $ evaluateQuery (xpath query) ((parseTestNumToElem filenum):[])) ++ ")"

makeJSCommand :: String -> [String] -> String
makeJSCommand querynum ids = "queryResult(\""++querynum++"\", new Array("++(commaSeperate ids)++"))";

getIDs ::[XMLElement] -> [String]
getIDs [] = []
getIDs (el:elems) = ((getID el):(getIDs elems))

getID :: XMLElement -> String
getID (Attr id _ _) = id
getID (Element id _ _ _) = id
getID (CharData id _) = id
getID (RootElement elem) = getID elem

    
--assertEqual :: (Eq a, Show a) => String -> a -> a -> IO ()
assertEqual :: String -> String -> [XMLElement] -> IO()
assertEqual msg expected actual 
    | expected == (show actual) = return ()
    | otherwise = do
                    putStrLn (show msg ++ ", expected " ++ expected ++ ", got " ++ show actual)
                    return ()

evaluate (StartExpr path) (RootElement elem) = print $ evaluateQuery path (elem:[])
evaluate (EndOfExpr) _ = print "There was apparently a parse error on the XPath"

evaluateQuery :: XPath -> [XMLElement] -> [XMLElement]
evaluateQuery _ [] = []
evaluateQuery (StartExpr nextExpr) elems = evaluateQuery nextExpr elems
evaluateQuery (EndOfExpr) elems = elems
evaluateQuery (LocationStep name next) elems = evaluateQuery next $ elemsNamed name $ childrenOf elems
evaluateQuery (PredicateTest test next) elems = evaluateQuery next $ passesTest test elems
evaluateQuery (FunctionCall name args next) elems = evaluateQuery next $ applyFunction name args elems
evaluateQuery (Expression left op right) elems = applyOperator op left right elems
evaluateQuery (Literal val) elems = []

--test is either literal or opExpression
passesTest test elems = evaluateQuery test elems -- elems
		
{------- FUNCTIONS ---------}
applyFunction :: String -> [XPath] -> [XMLElement] -> [XMLElement]

{-- 4.1 Node Set Functions --}
applyFunction "last" [] elems = ((last elems):[]) --Incorrect- should be the last item in its parent, not in its context.

--todo applyFunction "position" [] elems = lastsubstring (getID elem)
--todo applyFunction "count" [] elems = length elems
--todo applyFunction "id" [] elems = map getID elems
--todo applyFunction "local-name" [] elems = map getName elems
--todo applyFunction "namespace-uri" [] elems = map getName elems
--todo applyFunction "name" [] elems = map getName elems

{-- 4.2 String Functions --}
{-string
concat
starts-with
contains
substring-before
substring-after
substring
string-length
normalize-space
translate-}

{-- 4.3 Boolean Functions --}
{-boolean
not
true
false
lang-}

{-- 4.4 Number Functions --}
{-number
sum
floor
ceiling
round-}

applyFunction name args elems = elems
{------- OPERATORS ---------}
applyOperator op left right elems = elems
			{-do{ evall <- evaluateQuery left elems
					; evalr <- evaluateQuery right elems
					--apply op evall evalr
					; return $ Str "applied operator "++op -}
{-operator = try(string "<=") <|> try(string ">=") <|> try(string "=") <|> try(string "!=") 
	<|> try(string "and") <|> try(string "or") <|> try(string "+") <|> try(string "-") 
	<|> try(string "div") <|> try(string "mod") <|> try(string "*") <|> try(string "|") 
	<|> try(string "<") <|> try(string ">")  -}

{- ------ LOCATION STEPS -------- -}
elemsNamed :: String -> [XMLElement] -> [XMLElement]
--elemsNamed name elems = elems
elemsNamed name [] = []
elemsNamed name (elem:elems) =  if isNamed name elem
			  	then (elem:(elemsNamed name elems))
				else (elemsNamed name elems)
					where   isNamed name (Element id named attrs children) = name == named
						isNamed name elem = False



childrenOf :: [XMLElement] -> [XMLElement]
childrenOf [] = []
childrenOf ((Element id name attrs children):elems) = children++(childrenOf elems)
childrenOf ((CharData id cdata):elems) = childrenOf elems
childrenOf ((RootElement elem):[]) = (elem:[])
