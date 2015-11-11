live = true;

function queryResult(queryid, elemids){
	for( i in elemids){
		//alert(elemids[i]);
		elem = document.getElementById(elemids[i]);
		elem.className += " subquery"+queryid;
	}
}

nextidnumber = 1;
firstSlash = true;
function xpathChange(e){
	var keynum;
	var keychar;
	var numcheck;
	if(window.event) // IE
	  {
	  keynum = e.keyCode;
	  }
	else if(e.which) // Netscape/Firefox/Opera
	  {
	  keynum = e.which;
	  }
	keychar = String.fromCharCode(keynum);	
	nextXPath(keychar, keynum);
}

function finalizeXPath(){
	nextXPath("...",0);
}

function nextXPath(keychar, keynum){
	var xmlhttpforxpath=false;
	if (!xmlhttpforxpath && typeof XMLHttpRequest!='undefined') {
		try {
			xmlhttpforxpath = new XMLHttpRequest();
		} catch (e) {
			xmlhttpforxpath=false;
		}
	}
	if (!xmlhttpforxpath && window.createRequest) {
		try {
			xmlhttpforxpath = window.createRequest();
		} catch (e) {
			xmlhttpforxpath=false;
		}
	}

	//alert("Key was: "+keynum);
	/*A key was pressed.  If it is a backspace(keychar 8) or delete (46), we need to
	make sure it didn't remove something we already had in place */
	if ( keynum == 46 || keynum == 8 ){
		//TODO: this :P
	/*Otherwise, it is an addition.  If it is a slash(47) then it constitutes a new
	token.*/
	}else if(keychar == "/" || keychar == "[" || keychar=="..."){ //a slash
		if(firstSlash){
			firstSlash = false;
			return;
		}
		document.getElementById('establishedtokens').innerHTML += "<span class=\"subquery subquery"+nextidnumber+"\">"+document.getElementById('tokeninprogress').innerHTML+"</span>";
		document.getElementById('tokeninprogress').innerHTML = (keychar=="...")?"":keychar;
		//send XPath update request with the current query
		//alert("loading XPATH")
		querystring = "xpath?xmlfile="+document.getElementById('xml').value+"&query="+document.getElementById('xpath').value+"&querynum="+nextidnumber;
		//alert(querystring);
		xmlhttpforxpath.open("GET", querystring,true);
		xmlhttpforxpath.onreadystatechange=function() {
			if (xmlhttpforxpath.readyState==4) {
			   //alert(xmlhttpforxpath.responseText);
			   eval(xmlhttpforxpath.responseText);
			}
		}
		if(live){ 
			xmlhttpforxpath.send(null); 
		}
		nextidnumber += 1;
	/*If it is neither a deletion or worthy of a new token, add it to the 
	token-in-progress and update the display of the token-in-progress*/
	}else{
		document.getElementById('tokeninprogress').innerHTML += keychar;
		//send internim XPath request
	}
	
	//if the character isn't allowed return false: return !numcheck.test(keychar);
	return true;
	}

function reset(){
	nextidnumber = 1;
	firstSlash = true;
	loadXML();
	document.getElementById('xpath').value = "";
	document.getElementById('establishedtokens').innerHTML = "";
	document.getElementById('tokeninprogress').innerHTML = "";
}

function loadXML(){
	var xmlhttp=false;
	if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
		try {
			xmlhttp = new XMLHttpRequest();
		} catch (e) {
			xmlhttp=false;
		}
	}
	if (!xmlhttp && window.createRequest) {
		try {
			xmlhttp = window.createRequest();
		} catch (e) {
			xmlhttp=false;
		}
	}
	 //alert("loading "+"xml?xmlfile="+document.getElementById('xml').value);
	 xmlhttp.open("GET", "xmljs?xmlfile="+document.getElementById('xml').value,true);
	 document.getElementById("xmlLink").href = "xml/"+document.getElementById('xml').value+".xml";
	 xmlhttp.onreadystatechange=function() {
	  if (xmlhttp.readyState==4) {
	   //alert(xmlhttp.responseText)
	   eval(xmlhttp.responseText)
	  }
	 }
	 if(live){ 
		document.getElementById("orgchartHolder").innerHTML = "<div id=\"orgchart1\"/>";
		xmlhttp.send(null) 
	 }
}