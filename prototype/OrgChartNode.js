/* 
	OrgChartNode.js - a javascript library for making organization charts
	
	Copyright (C) 2007  Roland Bouman http://rpbouman.blogspot.com/
	web: http://www.xcdsql.org/OrgChart/ 
	email: Roland.Bouman@gmail.com
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

var orgchart = {};

/**
*
*/
var OrgChart = orgchart.Chart = function(configuration){
	this.orgChartNodeDefaults = orgchart._setProperties(
		{}
	,	orgchart.orgChartNodeDefaults
	);
	
	this._domRoot = null;
	this._domBody = null;
	this.rootOrgChartNode = null;

	this._initDom();
	this.setConfiguration(configuration);
	return this;
}

OrgChart.prototype._initDom = function(){
	var table = document.createElement("TABLE");
	var row = table.insertRow(0);
	var cell;

	cell = row.insertCell(row.cells.length);
	cell.style.width = "50%";

	cell = row.insertCell(row.cells.length);
	cell.style.width = "0%";
	this._domBody = cell;
	cell.onclick = function(e){
		var target = null;
		var orgChartNode = null;
		if(window.event){
			target = window.event.srcElement;
		} else {
			target = e.target;
		}
		switch(target.className){
			case orgchart.Node.prototype.CSS_NODE_BODY_CHILDREN_SWITCH:
				orgChartNode = target.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.orgChartNode;
				orgChartNode.toggleState();
				break;
		}
	}

	cell = row.insertCell(row.cells.length);
	cell.style.width = "50%";

	this._domRoot = table;	
}

OrgChart.prototype._replaceDom = function(id){
	var element = document.getElementById(id);
	if(element == null){
		throw "Id specified but corresponding DomNode not found.";
	}
	var parentNode = element.parentNode;
	if (parentNode == null){
		throw "Specified element cannot be document element.";
	}
	var domRootParent = this._domRoot.parentNode;
	if(domRootParent!=null){
		domRootParent.removeChild(this._domRoot);
	}
	parentNode.replaceChild(this._domRoot,element);
	return element;
}

OrgChart.prototype.setConfiguration = function(configuration){
	switch(typeof(configuration)){
		case "string":
			var element = this._replaceDom(configuration);
			break;
		case "object":
			switch(typeof(configuration.id)){
				case "string":
					var element = this._replaceDom(configuration.id);
				case "undefined":
					break;
				default:
					throw "Id specified but not a string type";
			}
			switch(typeof(configuration.root)){
				case "object":
					this.setRootOrgChartNode(new orgchart.Node(configuration.root));
					break;
				case "undefined":
					break;
				default:
					throw "Root specified but is not a valid object";
			}
			break;
		default:
			throw "Expected a string (id of element) or an object";
	}
}

OrgChart.prototype.setRootOrgChartNode = function(OrgChartNode){	
	var oldRootOrgChartNode = this._rootOrgChartNode;
	this.rootOrgChartNode = OrgChartNode;
	OrgChartNode.removeFromParent();
	var OrgChartNodeDomRoot = OrgChartNode._domRoot;
	if(oldRootOrgChartNode!=null){
		this._domBody.replaceChild(OrgChartNodeDomRoot, oldRootOrgChartNode);
	} else {
		this._domBody.appendChild(OrgChartNodeDomRoot);
	}
	return oldRootOrgChartNode;
}

/**
*	new orgchart.Node()
*	
*	Creates a new OrgChartNode (but does not render it)
*
*	new orgchart.Node(DOMElement)
*
*	Creates a new OrgChartNode using the specified DOMElement (and renders it in place)
*	Any 
*
*	new orgchart.Node(config)
*
*	Creates a new OrgChartNode using the specifed config. 
*	The config is an object with the following optional properties:
*
*	{
*		id				(string)		The id attribute of the corresponding DOMElement. If the element exists, it will be rendered in place. If it does not exist, the node will not be rendered.
*		label			(htmlFragment)	The html that is to be used as label
*		labelURI		(URI)			URI used to make a link of the label
*		labelURITarget	(string)		Name of the window (frame) that is to be used for the uri
*		style			(object){		Css style object
*			..any javascript equivalent of a css propery...
*		}
*		className		(string)		CSS classname(s)
*		childNodes		(array)			Array of configs for any childnodes
*	}
*/
var OrgChartNode = orgchart.Node = function(
	configuration	
){
	orgchart._setOrgChartNodeDefaults(configuration);
	this.type = configuration.type;
	this.parentNode = null;
	
	this._domRoot = null;
	this._domTop = null;
	this._domBottom = null;
	this._domNodeBody = null;
	this._domNodeBodyLabel = null;
	this._domNodeBodyChildNodes = null;
	this._domNodeBodyChildNodeSwitchText = null;
	this._domNodeBodyChildNodeCountText = null;
	this._domChildNodeConnections = null;
	this._domChildNodes = null;

	this._initDom();
	this.setConfiguration(configuration);
	return this;
}
OrgChartNode.prototype.TYPE_SPACE = "space";
OrgChartNode.prototype.TYPE_NODE = "node";

OrgChartNode.prototype.CSS_NODE = "CSS_NODE";
OrgChartNode.prototype.CSS_VSTICKS = "CSS_VSTICKS";
OrgChartNode.prototype.CSS_VSTICKL = "CSS_VSTICKL";
OrgChartNode.prototype.CSS_VSTICKR = "CSS_VSTICKR";
OrgChartNode.prototype.CSS_HSTICK = "CSS_HSTICK";
OrgChartNode.prototype.CSS_FLANK = "CSS_FLANK";

OrgChartNode.prototype.CSS_NODE_BODY_SPACE = "CSS_NODE_BODY_SPACE";

OrgChartNode.prototype.CSS_NODE_BODY = "CSS_NODE_BODY";
OrgChartNode.prototype.CSS_NODE_BODY_CONTAINER = "CSS_NODE_BODY_CONTAINER";
OrgChartNode.prototype.CSS_NODE_BODY_LABEL = "CSS_NODE_BODY_LABEL";
OrgChartNode.prototype.CSS_NODE_BODY_CHILDREN = "CSS_NODE_BODY_CHILDREN";
OrgChartNode.prototype.CSS_NODE_BODY_CHILDREN_SWITCH = "CSS_NODE_BODY_CHILDREN_SWITCH";
OrgChartNode.prototype.CSS_NODE_BODY_CHILDREN_COUNT = "CSS_NODE_BODY_CHILDREN_COUNT";

OrgChartNode.prototype.CSS_NODE_CHILDREN = "CSS_NODE_CHILDREN";
OrgChartNode.prototype.CSS_NODE_CHILD = "CSS_NODE_CHILD";

OrgChartNode.prototype.STATE_COLLAPSED = "+";
OrgChartNode.prototype.STATE_EXPANDED = "-";

OrgChartNode.prototype._createTable = function(className){
	table = document.createElement("TABLE");
	table.cellPadding = 0;		
	table.cellSpacing = 0;	
	table.className = className;
//	table.border="1";
	return table;
}

OrgChartNode.prototype._addSpacer = function(tableCell){
	var spacer = document.createElement("DIV");
	spacer.className = OrgChartNode.prototype.CSS_SPACER;
	spacer.appendChild(document.createElement("BR"));	
	tableCell.appendChild(spacer);
}

OrgChartNode.prototype._addFlank = function(tableRow){
	var cell;
	cell = tableRow.insertCell(tableRow.cells.length);
	cell.className = OrgChartNode.prototype.CSS_FLANK;
	this._addSpacer(cell);
}

OrgChartNode.prototype._addVerticalStick = function(tableSection){
	var row,cell;
	row = tableSection.insertRow(tableSection.rows.length);
	row.className = OrgChartNode.prototype.CSS_VSTICKS;
	
	this._addFlank(row);

	cell = row.insertCell(row.cells.length);
	cell.className = OrgChartNode.prototype.CSS_VSTICKR;
	this._addSpacer(cell);

	cell = row.insertCell(row.cells.length);
	cell.className = OrgChartNode.prototype.CSS_VSTICKL;
	this._addSpacer(cell);

	this._addFlank(row);	
	return row;
}

OrgChartNode.prototype._initDom = function(){
	var table,tHead,tFoot,tBody,row,cell,text;
	var root = this._domRoot = this._createTable(OrgChartNode.prototype.CSS_NODE); 
	this._domRoot.orgChartNode = this;	
	
	//TBODY
	row = root.insertRow(0);
	this._addFlank(row);
	cell = row.insertCell(row.cells.length);
	this._addFlank(row);

	//NODE BODY
	cell.className = OrgChartNode.prototype.CSS_NODE_BODY_CONTAINER;
	cell.colSpan = 2;
	table = this._domNodeBody = this._createTable(OrgChartNode.prototype.CSS_NODE_BODY);
	cell.appendChild(table);		
	switch(this.type){
		case OrgChartNode.prototype.TYPE_SPACE:
			table.className = OrgChartNode.prototype.CSS_NODE_BODY_SPACE;
			break;
		default:
	}

	//NODE BODY LABEL
	row = table.insertRow(0);
	cell = row.insertCell(0);
	cell.colSpan = 2;
	cell.className = OrgChartNode.prototype.CSS_NODE_BODY_LABEL;
	cell.appendChild(this._domNodeBodyLabel = document.createElement("A"));
	this._domNodeBodyLabel.className = OrgChartNode.prototype.CSS_NODE_BODY_LABEL;

	//NODE BODY CHILDREN
	row = table.insertRow(1);
	row.style.display = "none";
	row.className = OrgChartNode.prototype.CSS_NODE_BODY_CHILDREN;	
	this._domNodeBodyChildNodes = row;	

	//NODE BODY CHILDREN SWITCH
	cell = row.insertCell(0);
	cell.className = OrgChartNode.prototype.CSS_NODE_BODY_CHILDREN_SWITCH;
	cell.appendChild(text = document.createTextNode(""));
	this._domNodeBodyChildNodeSwitchText = text;

	if(this.type==OrgChartNode.prototype.TYPE_SPACE){
		cell.className = "";
		cell.style.display = "none";
	}

	//NODE BODY CHILDREN COUNT
	cell = row.insertCell(1);
	cell.className = OrgChartNode.prototype.CSS_NODE_BODY_CHILDREN_COUNT;
	cell.appendChild(text = document.createTextNode(""));
	this._domNodeBodyChildNodeCountText = text;

	if(this.type==OrgChartNode.prototype.TYPE_SPACE){
		cell.className = "";
		cell.style.display = "none";
	}
	
	//THEAD
	tHead = root.createTHead();
	this._domTop = tHead;
	tHead.style.display = "none";	
	this._addVerticalStick(tHead);

	//FOOT
	tFoot = root.createTFoot();
	this._domBottom = tFoot;
	tFoot.style.display = "none";	
	this._domChildNodeConnections = this._addVerticalStick(tFoot);
	
	//CHILNODES
	row = tFoot.insertRow(tFoot.rows.length);
	cell = row.insertCell(row.cells.length);
	cell.colSpan = tFoot.rows.item(0).cells.length;
	
	cell.appendChild(table = this._createTable(OrgChartNode.prototype.CSS_NODE_CHILDREN));	

	row = table.insertRow(0);
	this._domChildNodes = row;
	//add ChildNodes.
	return root;
}
OrgChartNode.prototype._updateChildNodeCount = function(){
	var childNodeCount = this.childNodeCount();
	this._domNodeBodyChildNodeCountText.data = childNodeCount;
	var display;
	if(childNodeCount==0){
		display = "none";
	} else {
		display = "";
	}
	this._domNodeBodyChildNodes.style.display = display;
	this._domBottom.style.display = display;
}

OrgChartNode.prototype.setConfiguration = function(configuration){
	var type, charAt0, capitalizedPropertyName, methodName, domProperty, value;
	var state = orgchart.orgChartNodeDefaults.state;
	for (p in configuration){
		switch (p){
			case "state":
				state = configuration.state;
			default:
				charAt0 = p.charAt(0);
				if(charAt0=='_'){
					continue;
				}
				capitalizedPropertyName = charAt0.toUpperCase() + p.substr(1);
				value = configuration[p];
				methodName = 'set' + capitalizedPropertyName;
				domProperty = '_dom' + capitalizedPropertyName;
				if ((type = typeof(this[methodName]))=="function"){		
					this[methodName](value);
				} else if((type = typeof(this[domProperty]))=="object") {
					this._setDomProperty(domProperty,value);
				}
		}
	}
	this.setState(state);
}

OrgChartNode.prototype.addChildNodes = function(array, index){
	if(isNaN(parseInt(index))){
		index = 0;
	}
	var count = array.length;
	var childNode;
	for (var i=0; i<count; i++){
		childNode = new orgchart.Node(array[i]);
		childNode.setParent(this, index+i);
	}
}

OrgChartNode.prototype.removeAllChildNodes = function(){
	var childNodeCount = this.childNodeCount();
	for(var i=0; i<childNodeCount; i++){
		this.getChildNodeAt(0).removeFromParent();
	}
}

OrgChartNode.prototype.setChildNodes = function(array){
	this.removeAllChildNodes();
	this.addChildNodes(array,0);
}

OrgChartNode.prototype._setDomProperty = function(domProperty,value){
	var dom = this[domProperty];
	if (typeof(dom)!="object"){
		throw "No such dom property: " + domProperty.substr(6);
	}
	if(typeof(value)!="object"){
		throw "Expected object type value for propery " 
		+ "\"" + p + "\", got: " + type + "."
		;
	}
	orgchart._setProperties(dom,value);
}

OrgChartNode.prototype.setStyle = function(style){
	orgchart._setProperties(this._domNodeBody.style,style);
}

OrgChartNode.prototype.setState = function(state){
	var display,otherState;
	switch(state){
		case orgchart.Node.prototype.STATE_EXPANDED:			
			if(this.childNodeCount()>0){
				display = "";
			} else {
				display = "none";
			}
			break;
		case orgchart.Node.prototype.STATE_COLLAPSED:
			display = "none";
			break;
		default:
			throw "Property \"state\" has the value " 
			+ "\"" + state + "\", expected one of "
			+ "(\"" + orgchart.Node.prototype.STATE_EXPANDED + "\""
			+ ",\"" + orgchart.Node.prototype.STATE_COLLAPSED + "\")"
			;
	}
	this._domBottom.style.display = display;
	this._domNodeBodyChildNodeSwitchText.data = state;
	this.state = state;
}

OrgChartNode.prototype.toggleState = function(){
	var newState = null;
	switch (this.state){
		case orgchart.Node.prototype.STATE_COLLAPSED:
			newState = orgchart.Node.prototype.STATE_EXPANDED;
			break;
		case orgchart.Node.prototype.STATE_EXPANDED:
			newState = orgchart.Node.prototype.STATE_COLLAPSED;
			break;
		default:
			return;
	}
	this.setState(newState)	;
}

OrgChartNode.prototype.setLabel = function(label){
	var type = typeof(label);
	switch (type){
		case "string":
			this._domNodeBodyLabel.innerHTML = label;
			break;
		default:
			throw "Property \"label\" has the type "
			+"\""+type+"\", expected string."
			;
	}
}

OrgChartNode.prototype.setLabelURI = function(uri){
	this._domNodeBodyLabel.href = uri;
}

OrgChartNode.prototype.setLabelTarget = function(target){
	this._domNodeBodyLabel.target = target;
}

OrgChartNode.prototype.setLink = function(link){
	var type = typeof(link);
	switch(type){
		case "string":
			this.setLabelURI(link);
			break;
		case "object":
			orgchart._setProperties(this._domNodeBodyLabel,link);
			break;
		default:
			throw "Invalid type \"" + type + "\" for property link, expected string or object.";
	}
}

OrgChartNode.prototype.childNodeCount = function(){
	return this._domChildNodes.cells.length;
}

OrgChartNode.prototype.removeFromParent = function(){
	if(this.parentNode == null){
		return;
	}
	var domRootParentNode = this._domRoot.parentNode;
	if(domRootParentNode!=null){
		domRootParentNode.removeChild(this._domRoot);
	}
	var domRootParentNodeParentNode = domRootParentNode.parentNode;
	domRootParentNodeParentNode.deleteCell(domRootParentNode.cellIndex);
	this._domTop.style.display = "none";	
	this.parentNode._updateChildNodeCount();
	this.parentNode = null;
}

OrgChartNode.prototype._renderAttachmentToParent = function (){
	var parentNode = this.parentNode;
	var parentChildNodeCount = parentNode.childNodeCount();
	var cells = this._domTop.rows.item(0).cells;
	var index = this.getIndex();
	if(index==0){
		cells.item(0).className = OrgChartNode.prototype.CSS_FLANK;
		cells.item(1).className = OrgChartNode.prototype.CSS_VSTICKR;
	} else {
		cells.item(0).className = OrgChartNode.prototype.CSS_FLANK + " " + OrgChartNode.prototype.CSS_HSTICK;
		cells.item(1).className = OrgChartNode.prototype.CSS_VSTICKR + " " + OrgChartNode.prototype.CSS_HSTICK;
	}
	if(index == (parentChildNodeCount-1)){
		cells.item(2).className = OrgChartNode.prototype.CSS_VSTICKL;
		cells.item(3).className = OrgChartNode.prototype.CSS_FLANK;
	} else {
		cells.item(2).className = OrgChartNode.prototype.CSS_VSTICKL + " " + OrgChartNode.prototype.CSS_HSTICK;
		cells.item(3).className = OrgChartNode.prototype.CSS_FLANK + " " + OrgChartNode.prototype.CSS_HSTICK;
	}
}

OrgChartNode.prototype.getIndex = function(){
	var cell = this._domRoot.parentNode;
	var index;
	if(typeof(cell.cellIndex)=="undefined"){	//Hack to make it work for opera
		var cells = cell.parentNode.cells;
		for(var i=0; i<cells.length; i++){
			if(cell == cells.item(i)){
				index = i;
				break;
			}
		}		
	} else {
		index = cell.cellIndex;
	}
	return index;
}


OrgChartNode.prototype.getChildNodeAt = function(index){
	var cells = this._domChildNodes.cells;
	if(index<0 || cells.length<=index){
		throw "Index " + index + " is out of bounds: No such childnode";
	}
	var cell = cells.item(index);
	var domRoot = cell.firstChild;
	return domRoot.orgChartNode;
}

OrgChartNode.prototype.nextSibling = function(){
	return this.parentNode.getChildNodeAt(this.getIndex() + 1);
}

OrgChartNode.prototype.previousSibling = function(){
	return this.parentNode.getChildNodeAt(this.getIndex() - 1);
}

OrgChartNode.prototype.setParent = function(parent,index){
	if(this.parentNode == null){
		//this is needed in case this node is the root of an orgchart
		var domRootParentNode = this._domRoot.parentNode;
		if(domRootParentNode!=null){
			domRootParentNode.removeChild(this._domRoot);
		}
	} else {
		this.removeFromParent();
	}
	var parentChildNodeCount = parent.childNodeCount();
	if(typeof(index)=="undefined"){
		index = parentChildNodeCount;
	}
	var cell = parent._domChildNodes.insertCell(index);
	cell.className = OrgChartNode.prototype.CSS_NODE_CHILD;
	
	cell.appendChild(this._domRoot);
	this.parentNode = parent;
	parent._updateChildNodeCount();
	this._domTop.style.display = "";

	this._renderAttachmentToParent();
	if(parentChildNodeCount>0){
		switch(index){
			case 0:
				this.nextSibling()._renderAttachmentToParent();
				break;
			case parentChildNodeCount:
				this.previousSibling()._renderAttachmentToParent();
				break;
		}
	}
}
/**
*
*/
orgchart.orgChartNodeDefaults = {
	state:orgchart.Node.prototype.STATE_EXPANDED
,	type:orgchart.Node.prototype.TYPE_NODE
}	

orgchart._setProperties = function(object, properties, noOverwrite){
	var value; 
	for (p in properties){
		if(noOverwrite && typeof(object[p])!="undefined"){
			continue;
		} else {
			value = properties[p];
			if (typeof(value)=="object"){
				orgchart._setProperties(object[p],value);
			} else {
				object[p] = value;
			}
		}
	}
}

orgchart._setOrgChartNodeDefaults = function(configuration){
	orgchart._setProperties(
		configuration
	,	orgchart.orgChartNodeDefaults
	,	true
	);
	return configuration;
}
