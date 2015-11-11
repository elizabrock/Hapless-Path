import HAppS.Server

main = simpleHTTP nullConf {port=5000} [
       -- dir "proxy" [withRequest proxyServe]-- so http://127.0.0.1/proxy/happs.org/blah works for ajax
       -- rproxyServe "happs.org" [("localhost:5000","vo.com")]
        dir "proxy" [proxyServe ["happs.org","*.haskell.org"]]
       ,dir "src" [fileServe ["index.html"] "src"]
       ,dir "req" [withRequest $ ok . toResponse . show ]
       ,fileServe ["index2.html","index.html","README.html","package-info.xml"] "public/"
       ]



                      


  


                 
          

