module Main where

import HAppS.Server
import ParseXML
import ExecuteQuery
import Control.Monad

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

parseFileForMe name = name

processXMLReq filenum = [anyRequest $ ok $ toResponse $ parseTestNumToJS filenum]

processXPATHReq [filenum, query, querynum] = [anyRequest $ ok $ toResponse $ evalWith querynum query filenum ]

impl = [ dir "xmljs" [methodSP GET $ withDataFn fromXMLRequest processXMLReq],
        dir "xpath" [methodSP GET $ withDataFn fromXPATHRequest processXPATHReq]
       , fileServe ["index.html","README.html","package-info.xml"] "public/"
       , fileServe ["1.xml", "2.xml", "3.xml","0.xml"] "xml/"
       , anyRequest $ ok $ toResponse "Sorry, couldn't find a matching handler"]

main = do simpleHTTP nullConf impl
