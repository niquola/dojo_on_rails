/**
 * <%= full_name %>
 * put documentation here
 * Created by <%= creator %>
 **/

dojo.provide("<%= full_name %>");

dojo.require("<%= base_class %>"); 
<%= mixins.map{|mixin| %Q[dojo.require("#{mixin}");]}.join("\n") %>

(function () {
	//here go private vars and functions
	dojo.declare("<%= full_name %>", [ <%= base_class %><%= mixins.size > 0 ? ',': '' %><%=mixins.join(',') %>], {
		// summary:
		//  HERE SUMMARY 
    
		// baseClass: [protected] String
		//    The root className to use for the various states of this widget
		baseClass: "<%= no_dots_name %>",
    <% if is_templated %>templatePath: dojo.moduleUrl("<%= package_name %>", "templates/<%= class_name %>.html"),<% end %>
    //widgetsInTemplate: true,
		//buildRendering: function () {
			//this.inherited(arguments);
		//},
		//layout: function () {
			//var cb = this._contentBox;
      //dojo.marginBox(this.containerNode, cb);
		//},
		postCreate: function () {
			this.inherited(arguments);
		}
	});
})();
