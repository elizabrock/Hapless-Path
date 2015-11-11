module ParseXML (XMLElement(Attr, Element, RootElement, CharData), showElemJS, showElem, parseFileToJS, parseTestToJS, parseTestToElem, parseTestNumToJS, parseTestNumToElem, commaSeperate) where 
import Text.ParserCombinators.Parsec 

{- Runners -}

run :: String -> IO ()
run input
    = case (parse document "" input) of
    Left err -> do{ putStr "parse error at "
                ; print err
                }
    Right x -> print $  showElem x

parseTestToElem :: XMLElement
parseTestToElem = case (parse document "" testXML) of
    Left err -> RootElement $ Element "0" ("parse error at " ++ (show err)) [] []
    Right x ->  x
    
parseTestNumToElem :: String -> XMLElement
parseTestNumToElem num = case (parse document "" (getDocument num)) of
	    Left err -> RootElement $ Element "0" ("parse error at " ++ (show err)) [] []
	    Right x ->  x    
	    
parseTestNumToJS :: String -> String
parseTestNumToJS num = case (parse document "" (getDocument num)) of
	    Left err -> show $ "parse error at " ++ (show err)
	    Right x ->  showElemJS x

getDocument :: String -> String
getDocument num = case num of
	"0" -> simpleXML
	"1" -> breakfastXML
	"2" -> plantXML
	"3" -> cdXML
	 
breakfastXML = "<?xml version='1.0' encoding='ISO-8859-1'?><breakfast_menu><food>  <name>Belgian Waffles</name>  <price>$5.95</price>  <description>two of our famous Belgian Waffles with plenty of real maple syrup</description>  <calories>650</calories> </food> <food>  <name>Strawberry Belgian Waffles</name>  <price>$7.95</price>  <description>light Belgian waffles covered with strawberries and whipped cream</description>  <calories>900</calories> </food> <food>  <name>Berry-Berry Belgian Waffles</name>  <price>$8.95</price>  <description>light Belgian waffles covered with an assortment of fresh berries and whipped cream</description>  <calories>900</calories> </food> <food>  <name>French Toast</name>  <price>$4.50</price>  <description>thick slices made from our homemade sourdough bread</description>  <calories>600</calories> </food> <food>  <name>Homestyle Breakfast</name>  <price>$6.95</price>  <description>two eggs, bacon or sausage, toast, and our ever-popular hash browns</description>  <calories>950</calories> </food></breakfast_menu>" 
plantXML = "<?xml version='1.0' encoding='ISO-8859-1'?> <CATALOG><PLANT><COMMON>Bloodroot</COMMON><BOTANICAL>Sanguinaria canadensis</BOTANICAL><ZONE>4</ZONE><LIGHT>Mostly Shady</LIGHT><PRICE>$2.44</PRICE><AVAILABILITY>031599</AVAILABILITY></PLANT><PLANT><COMMON>Columbine</COMMON><BOTANICAL>Aquilegia canadensis</BOTANICAL><ZONE>3</ZONE><LIGHT>Mostly Shady</LIGHT><PRICE>$9.37</PRICE><AVAILABILITY>030699</AVAILABILITY></PLANT></CATALOG>"
simpleXML = "<?xml version='1.0' encoding='ISO-8859-1'?><all><bob>hi</bob><jane>bye</jane></all>"
cdXML = "<?xml version='1.0' encoding='ISO-8859-1'?><CATALOG> <CD>  <TITLE>Empire Burlesque</TITLE>  <ARTIST>Bob Dylan</ARTIST>  <COUNTRY>USA</COUNTRY>  <COMPANY>Columbia</COMPANY>  <PRICE>10.90</PRICE>  <YEAR>1985</YEAR> </CD> <CD>  <TITLE>Hide your heart</TITLE>  <ARTIST>Bonnie Tyler</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>CBS Records</COMPANY>  <PRICE>9.90</PRICE>  <YEAR>1988</YEAR> </CD> <CD>  <TITLE>Greatest Hits</TITLE>  <ARTIST>Dolly Parton</ARTIST>  <COUNTRY>USA</COUNTRY>  <COMPANY>RCA</COMPANY>  <PRICE>9.90</PRICE>  <YEAR>1982</YEAR> </CD> <CD>  <TITLE>Still got the blues</TITLE>  <ARTIST>Gary Moore</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Virgin records</COMPANY>  <PRICE>10.20</PRICE>  <YEAR>1990</YEAR> </CD> <CD>  <TITLE>Eros</TITLE>  <ARTIST>Eros Ramazzotti</ARTIST>  <COUNTRY>EU</COUNTRY>  <COMPANY>BMG</COMPANY>  <PRICE>9.90</PRICE>  <YEAR>1997</YEAR> </CD> <CD>  <TITLE>One night only</TITLE>  <ARTIST>Bee Gees</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Polydor</COMPANY>  <PRICE>10.90</PRICE>  <YEAR>1998</YEAR> </CD> <CD>  <TITLE>Sylvias Mother</TITLE>  <ARTIST>Dr.Hook</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>CBS</COMPANY>  <PRICE>8.10</PRICE>  <YEAR>1973</YEAR> </CD> <CD>  <TITLE>Maggie May</TITLE>  <ARTIST>Rod Stewart</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Pickwick</COMPANY>  <PRICE>8.50</PRICE>  <YEAR>1990</YEAR> </CD> <CD>  <TITLE>Romanza</TITLE>  <ARTIST>Andrea Bocelli</ARTIST>  <COUNTRY>EU</COUNTRY>  <COMPANY>Polydor</COMPANY>  <PRICE>10.80</PRICE>  <YEAR>1996</YEAR> </CD> <CD>  <TITLE>When a man loves a woman</TITLE>  <ARTIST>Percy Sledge</ARTIST>  <COUNTRY>USA</COUNTRY>  <COMPANY>Atlantic</COMPANY>  <PRICE>8.70</PRICE> <YEAR>1987</YEAR> </CD> <CD>  <TITLE>Black angel</TITLE>  <ARTIST>Savage Rose</ARTIST>  <COUNTRY>EU</COUNTRY>  <COMPANY>Mega</COMPANY>  <PRICE>10.90</PRICE>  <YEAR>1995</YEAR> </CD> <CD>  <TITLE>1999 Grammy Nominees</TITLE>  <ARTIST>Many</ARTIST>  <COUNTRY>USA</COUNTRY>  <COMPANY>Grammy</COMPANY>  <PRICE>10.20</PRICE>  <YEAR>1999</YEAR> </CD> <CD>  <TITLE>For the good times</TITLE>  <ARTIST>Kenny Rogers</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Mucik Master</COMPANY>  <PRICE>8.70</PRICE>  <YEAR>1995</YEAR> </CD> <CD>  <TITLE>Big Willie style</TITLE>  <ARTIST>Will Smith</ARTIST>  <COUNTRY>USA</COUNTRY>  <COMPANY>Columbia</COMPANY>  <PRICE>9.90</PRICE>  <YEAR>1997</YEAR> </CD> <CD>  <TITLE>Tupelo Honey</TITLE>  <ARTIST>Van Morrison</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Polydor</COMPANY>  <PRICE>8.20</PRICE>  <YEAR>1971</YEAR> </CD> <CD>  <TITLE>Soulsville</TITLE>  <ARTIST>Jorn Hoel</ARTIST>  <COUNTRY>Norway</COUNTRY>  <COMPANY>WEA</COMPANY>  <PRICE>7.90</PRICE>  <YEAR>1996</YEAR> </CD> <CD>  <TITLE>The very best of</TITLE>  <ARTIST>Cat Stevens</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Island</COMPANY>  <PRICE>8.90</PRICE>  <YEAR>1990</YEAR> </CD> <CD>  <TITLE>Stop</TITLE>  <ARTIST>Sam Brown</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>A and M</COMPANY>  <PRICE>8.90</PRICE>  <YEAR>1988</YEAR> </CD> <CD>  <TITLE>Bridge of Spies</TITLE>  <ARTIST>T'Pau</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Siren</COMPANY>  <PRICE>7.90</PRICE>  <YEAR>1987</YEAR> </CD> <CD>  <TITLE>Private Dancer</TITLE>  <ARTIST>Tina Turner</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>Capitol</COMPANY>  <PRICE>8.90</PRICE>  <YEAR>1983</YEAR> </CD> <CD>  <TITLE>Midt om natten</TITLE>  <ARTIST>Kim Larsen</ARTIST>  <COUNTRY>EU</COUNTRY>  <COMPANY>Medley</COMPANY>  <PRICE>7.80</PRICE>  <YEAR>1983</YEAR> </CD> <CD>  <TITLE>Pavarotti Gala Concert</TITLE>  <ARTIST>Luciano Pavarotti</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>DECCA</COMPANY>  <PRICE>9.90</PRICE>  <YEAR>1991</YEAR> </CD> <CD>  <TITLE>The dock of the bay</TITLE>  <ARTIST>Otis Redding</ARTIST>  <COUNTRY>USA</COUNTRY>  <COMPANY>Atlantic</COMPANY>  <PRICE>7.90</PRICE>  <YEAR>1987</YEAR> </CD> <CD>  <TITLE>Picture book</TITLE>  <ARTIST>Simply Red</ARTIST>  <COUNTRY>EU</COUNTRY>  <COMPANY>Elektra</COMPANY>  <PRICE>7.20</PRICE>  <YEAR>1985</YEAR> </CD> <CD>  <TITLE>Red</TITLE>  <ARTIST>The Communards</ARTIST>  <COUNTRY>UK</COUNTRY>  <COMPANY>London</COMPANY>  <PRICE>7.80</PRICE>  <YEAR>1987</YEAR> </CD> <CD>  <TITLE>Unchain my heart</TITLE>  <ARTIST>Joe Cocker</ARTIST>  <COUNTRY>USA</COUNTRY>  <COMPANY>EMI</COMPANY>  <PRICE>8.20</PRICE>  <YEAR>1987</YEAR> </CD></CATALOG>"
testXML = plantXML

parseTestToJS = case (parse document "" testXML) of
    Left err -> do{ show $ "parse error at " ++ (show err)
                }
    Right x -> showElemJS x



parseFIO :: IO()
parseFIO = do{
    result <- parseFromFile document "..\\xml\\plant_catalog.xml"
    ;case (result) of
        Left err -> print err
        Right elem -> print $ showElem elem
    }
    
parseFIOJS :: IO()
parseFIOJS = do{
    result <- parseFromFile document "..\\xml\\plant_catalog.xml"
    ;case (result) of
        Left err -> print err
        Right elem -> print $ showElemJS elem
    }   
    
parseFileToJS :: IO String
parseFileToJS = do{
     result <- parseFromFile document  "..\\xml\\"-- ++filename --"..\\xml\\plant_catalog.xml"
    ; case (result) of
        Left err -> return $ show err
        Right elem -> return $ showElemJS elem
    }
    
transformToIO arg = return arg

{- Data Section -}
data XMLElement = Attr String String String
	| Element String String [XMLElement] [XMLElement]
	| RootElement XMLElement
	| CharData String String
    
instance Show XMLElement where
    show = showElemOnly
	
showElemOnly :: XMLElement -> String
showElemOnly (RootElement root) = showElemOnly root
showElemOnly (Element id name attrs []) = "<"++name++(foldl (++) "" (map showElemOnly attrs))++" />"
showElemOnly (Element id name attrs children) = "<"++name++(foldl (++) "" (map showElemOnly attrs))++">"++"..."++"</"++name++">"
showElemOnly (Attr id name value) = " "++name++"='"++value++"'"
showElemOnly (CharData id str) = str
    
showElem :: XMLElement -> String
showElem (RootElement root) = showElem root
showElem (Element id name attrs []) = "<"++name++(foldl (++) "" (map showElem attrs))++" />"
showElem (Element id name attrs children) = "<"++name++(foldl (++) "" (map showElem attrs))++">"++(foldl (++) "" (map showElem children))++"</"++name++">"
showElem (Attr id name value) = " "++name++"='"++value++"'"
showElem (CharData id str) = str

showElemJS :: XMLElement -> String
showElemJS (RootElement root) = "var config ={ id:\"orgchart1\", root:"++(showElemJS root)++"}; chart = new orgchart.Chart(config);"
showElemJS (Attr id name value) = " "++name++"='"++value++"'"
showElemJS (Element id name attrs []) = makeConfig(name++(foldl (++) "" (map showElemJS attrs)), id, id, [])
showElemJS (Element id name attrs children) = makeConfig(name++(foldl (++) "" (map showElemJS attrs)), id, id, (map showElemJS children))
showElemJS (CharData id str) = makeConfig(str, id, id, [])

makeConfig (label, labelURI, className, []) = "{label: \""++label++"\", labelURI: \""++labelURI++"\", className: \""++className++"\"}"
makeConfig (label, labelURI, className, childNodes) = "{label: \""++label++"\", labelURI: \""++labelURI++"\", className: \""++className++"\", childNodes:["++commaSeperate(childNodes)++"]}"


commaSeperate [] = []
commaSeperate (c:[]) = c
commaSeperate (c:cs) = (c++", "++commaSeperate(cs))

{- Helper functions -}

elementName :: Parser String
elementName = many (noneOf ">")

word :: Parser String
word  = many1 (letter)

phrase :: Parser String
--phrase = many1 (noneOf "'\"")
phrase = many1 (alphaNum <|> space <|> oneOf "-_")

--notFollowedByS  :: Show tok => GenParser [tok] st tok -> GenParser tok st ()
--notFollowedByS p :: GenParser [tok] -> [tok] -> ()
--not used.
notFollowedByS p  = try (do{ c <- p; unexpected (show [c]) }
                       <|> return ()
                       )

{- XML Parsing -}	       
		       
--document ::= prolog element Misc*  
-- Prolog is the beginning comments, element is the root element, Misc* is whitespace/comments/other ignored stuff
document :: Parser XMLElement
document = do{
        prolog
        ; el <- element "" 0         
	; s --should test to make sure that there isn't another element here (i.e. two roots).
        ; return $ RootElement el
        } <?> "Document root or prolog"

--element ::= EmptyElemTag | STag content ETag
element :: String -> Int -> Parser XMLElement
element parentId myPartID = do{
    s
    ; elem <- try (emptyElemTag parentId myPartID) <|> (fullElement parentId myPartID) <?> "element"
    ; return elem
    } <?> "element (any)"

--STag ::= '<' Name (S Attribute)* S? '>'
--STag is rolled into fullElement
--fullElement == STag content ETag
fullElement :: String -> Int -> Parser XMLElement
fullElement parentId myPartID= do{ 
        char '<'
        ; name <- elementName <?> "element name"
        ; s
        ; attrs <- endBy (attribute (parentId++(show myPartID)++".")) space
	; s
        ; char '>'
        ; children <- endOrChildren name (parentId++(show myPartID)++".") 0
        ; return $ Element (parentId++(show myPartID)++".") name attrs children
        } <?> "element"

        
notFollowedByEnd  = try (do{ c <- string "</"; unexpected (show [c]) }
                       <|> return ()
                       )
                       
--content ::= (element | CharData | Reference | CDSect | PI | Comment)*
content :: String -> Int -> Parser XMLElement
content parentPartID currentPartID = (element parentPartID currentPartID) <|> (charData parentPartID currentPartID)

charData :: String -> Int -> Parser XMLElement
charData parentID myPartID = do{
	str <- many (noneOf "<")
	; return $ CharData (parentID++(show myPartID)) str
	} <?> "Char Data"

endOrChildren :: String -> String -> Int -> Parser [XMLElement]
endOrChildren name parentID currentPartID = 
            try(do{s; endTag name; return [] })
            <|>
                do{ c <- content parentID currentPartID
                    --; return [c]
                    ; cs <- (endOrChildren name parentID (currentPartID + 1))
                    ; return (c:cs)
                  } <?> "end tag or child [endOrChildren]"

--ETag ::= '</' Name S? '>'
endTag :: String -> Parser [XMLElement]
endTag name = do{ 
        skipMany $ char '<'
        ;char '/'
	; s
        ;string name <?> "end tag for element "++name
        ;oneOf ">" <?> "end tag for element "++name
        ;return []
        }<?> "end tag for element "++name



notElement :: Parser ()
notElement = (try comment) <|> do{ s; return()}
            
            
            
--EmptyElemTag ::= '<' Name (S Attribute)* S? '/>'
emptyElemTag :: String -> Int -> Parser XMLElement
emptyElemTag parentId myPartID = do{ 
            oneOf "<"
            ; name <- elementName
            ; s
            ; attrs <- endBy (attribute (parentId++(show myPartID)++".")) space
            ; string "/>" <?> "end of tag"
            ; return $ Element (parentId++(show myPartID)++".") name attrs []
            } <?> "empty element"
            
--Attribute ::= Name Eq AttValue
attribute :: String -> Parser XMLElement
attribute parentID = do{ name <- word
	; eq
	; quoteChar <- oneOf "'\""
	; val <- phrase
	; char quoteChar
	; return $ Attr (parentID++name) name val
	} <?> "attribute"
	
--prolog ::= XMLDecl? Misc* (doctypedecl Misc*)?
prolog :: Parser String
prolog = do{ a <- try xmlDecl
	; many misc
--	; try doctypedecl
--	; many misc
	; return a
	} <?> "xml prolog"

--Misc ::= Comment | PI |  S
-- no PI support
misc :: Parser ()
misc = do{
    try(comment)
	; s 
--	; pi (would have to be "try"d with comment.
	; return ()
	} <?> "misc"

{- Better comment example:
simpleComment = do{ string "<!--"
        ; manyTill anyChar (try (string "-->"))
        }-}
--Comment ::= '<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
-- doesn't allow any non-comment ending dashes.
comment :: Parser ()
comment = do{ string "<!--"
	; many (noneOf "-")
	; string "-->" <?> "end of comment"
	; return ()
	} <?> "comment"

-- PI ::= '<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
-- PITarget ::= Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))
-- doctypedecl ::= '<!DOCTYPE' S Name (S ExternalID)? S? ('[' (markupdecl | PEReference | S)* ']' S?)? '>'
-- markupdecl ::= elementdecl | AttlistDecl | EntityDecl | NotationDecl | PI | Comment 

--XMLDecl ::= '<?xml' VersionInfo EncodingDecl? SDDecl? S? '?>'
xmlDecl :: Parser String
xmlDecl = do{ string "<?xml"
	; a <- versionInfo
	; b <- try encodingDecl
--	; try sdDecl
	; s
	; string "?>"
	; return ("<?xml "++a++" "++b++" ?>")
	} <?> "xml declaration"
	
--EncodingDecl ::= S 'encoding' Eq ('"' EncName  '"' |  "'" EncName "'" )
encodingDecl :: Parser String
encodingDecl = do{ s
	; string "encoding"
	; eq
	; quoteChar <- oneOf "'\""
	; encname <- encName
	; char quoteChar
	; return ("encoding='"++encname++"'")
	} <?> "encoding declaration"

--EncName ::= [A-Za-z] ([A-Za-z0-9._] | '-')*
encName :: Parser String
encName = do { c <- letter
	; cs <- many (oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.-")
	; return (c:cs)
	} <?> "encoding name"

--Not bothering: SDDecl ::= S 'standalone' Eq (("'" ('yes' | 'no') "'") | ('"' ('yes' | 'no') '"')) 

--VersionInfo ::= S 'version' Eq (' VersionNum ' | " VersionNum ")
versionInfo :: Parser String
versionInfo = do{ s
		; string "version"
		; eq
		; quoteChar <- oneOf "'\""
		; vn <- versionNum
		; char quoteChar
		; return ("version='"++vn++"'")
		} <?> "versionInfo"

--Eq ::= S? '=' S?
eq :: Parser Char
eq = do{  s
	; out <- oneOf "="
	; s
	; return out
	}
	<?> "equals sign"

--VersionNum ::= ([a-zA-Z0-9_.:] | '-')+
versionNum :: Parser String
versionNum = many1 (oneOf "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.:-")

--S ::= (#x20 | #x9 | #xD | #xA)+
s :: Parser ()
s = spaces


