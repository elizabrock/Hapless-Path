nextidnumber = 1;
function xpathAddition(e)
{
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
slashcheck = /\//;
//alert("Key was: "+keynum);
/*A key was pressed.  If it is a backspace(keychar 8) or delete (46), we need to
make sure it didn't remove something we already had in place */
if ( keynum == 46 || keynum == 8 ){
	//TODO: this :P
/*Otherwise, it is an addition.  If it is a slash(47) then it constitutes a new
token.*/
}else if(keynum == 47){
	document.getElementById('establishedtokens').innerHTML += 
		"<span class=\"subquery\" id=\"subquery"+nextidnumber+"\">"+
		document.getElementById('tokeninprogress').innerHTML+"/</span>";
	nextidnumber += 1;
	document.getElementById('tokeninprogress').innerHTML = "";
	//send XPath update request with the current query
/*If it is neither a deletion or worthy of a new token, add it to the 
token-in-progress and update the display of the token-in-progress*/
}else{
	document.getElementById('tokeninprogress').innerHTML += keychar;
	//send internim XPath request
}

//if the character isn't allowed return false: return !numcheck.test(keychar);
return true;
}