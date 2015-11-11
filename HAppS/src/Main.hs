module Main where

import HAppS.Server
import ParseXML
import ExecuteQuery
import Control.Monad

{-main = simpleHTTP nullConf {port=5000} impl

--filename, file's XML data, current xpath query
data sessionInfo = SessionXML String XMLElement

impl = [
       -- dir "proxy" [withRequest proxyServe]-- so http://127.0.0.1/proxy/happs.org/blah works for ajax
       -- rproxyServe "happs.org" [("localhost:5000","vo.com")]
        dir "src" [fileServe ["index.html"] "src"]
       ,dir "req" [withRequest $ ok . toResponse . show ]
       ,dir "xml"  [methodSP GET $  withData processXMLReq]
       ,dir "login" [methodSP GET $ (fileServe ["filelist.html"] ".")
                     ,methodSP POST $ withDataFn fromXMLRequest processXML]
       ,fileServe ["index2.html","index.html","README.html","package-info.xml"] "public/"
       ]
       

fromXMLRequest = do file <- look "filename" `mplus` return "default.xml"
                    return a

processXMLq (file) =
  [anyRequest $ ok $ toResponse $ "User logged in with: " ++ show (file)] 
       -}
{-
main = simpleHTTP nullConf {port=5000} [
       -- dir "proxy" [withRequest proxyServe]-- so http://127.0.0.1/proxy/happs.org/blah works for ajax
       -- rproxyServe "happs.org" [("localhost:5000","vo.com")]
        dir "proxy" [proxyServe ["happs.org","*.haskell.org"]]
       ,dir "src" [fileServe ["index.html"] "src"]
       ,dir "req" [withRequest $ ok . toResponse . show ]
       ,fileServe ["index2.html","index.html","README.html","package-info.xml"] "public/"
       ]

-}

{-parseFileToJS filename = do{
	result <- parseFileForMe filename
	; case (result) of
		Left err -> show err
		Right elem -> showElemJS elem
	}-}

data NewUserInfo = NewUserInfo String String String

instance FromData NewUserInfo where
    fromData = liftM3 NewUserInfo
      (look "username")
      (look "password" `mplus` return "nopassword")
      (look "password2" `mplus` return "nopassword2")

processNewUser (NewUserInfo user pass1 pass2)
  | pass1 == pass2 =
    [anyRequest $ ok $ toResponse $ "NewUserInfo: " ++ show (user,pass1,pass2)]
  | otherwise = [anyRequest $ ok $ toResponse $ "Passwords did not match"]

--creates data structure
fromXMLRequest = do{ a <- look "xmlfile" `mplus` return "default.xml"
		  ; return a
		}

--creates data structure
fromXPATHRequest = do{ a <- look "xmlfile" `mplus` return "1"
                    ;  b <- look "query" `mplus` return ""
		    ;  c <- look "querynum" `mplus` return "0"
                    ;  return [a,b,c]
                }
--uses data structure
--processLogin (u,p) =
--  [anyRequest $ ok $ toResponse $ "User logged in with: " ++ show (u,p)]

parseFileForMe name = name

processXMLReq filenum = [anyRequest $ ok $ toResponse $ parseTestNumToJS filenum]--parseFileForMe filename]

processXPATHReq [filenum, query, querynum] = [anyRequest $ ok $ toResponse $ evalWith querynum query filenum ]--parseFileForMe filename]
  
impl = [ dir "xmljs" [methodSP GET $ withDataFn fromXMLRequest processXMLReq],
        dir "xpath" [methodSP GET $ withDataFn fromXPATHRequest processXPATHReq]
--	 dir "xml" [methodSP GET $ (fileServe ["public/index.html"] ".")
--                   ,methodSP POST $ withDataFn fromLoginRequest processLogin]
       , dir "newuser" [methodSP POST $ withData processNewUser]
       , fileServe ["index.html","README.html","package-info.xml"] "public/"
       , fileServe ["1.xml", "2.xml", "3.xml","0.xml"] "xml/"
       , anyRequest $ ok $ toResponse "Sorry, couldn't find a matching handler"]

main = do simpleHTTP nullConf impl

