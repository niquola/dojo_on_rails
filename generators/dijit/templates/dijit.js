/**
 * app.<%= class_name %> dijit component
 */
dojo.provide("app.<%= class_name %>");

dojo.require("dijit._Templated");
dojo.require("dijit._Widget");

dojo.declare("app.<%= class_name %>", [dijit._Widget, dijit._Templated], {
    baseClass: "app<%= class_name %>",
    templatePath: dojo.moduleUrl("dijit", "../app/templates/<%= class_name %>.html"),
    postCreate: function(){
      
      this.inherited(arguments);
    },
    doit:function(){
      alert('I did it');
    },
		_onClick:function(event){
			this.myattach.innerHTML="goodby dijit" ;
		}
});
