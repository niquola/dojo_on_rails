/**
 * <%= full_name %>
 * put documentation here
 *
 * Created by <%= creator %>
 *
 */

dojo.provide("<%= full_name %>");

dojo.require("<%= base_class %>");
<% mixins.each do |mixin| %>
dojo.require("<%= mixin %>");
<% end %>

(function(){
//here go private vars and functions

dojo.declare("<%= full_name %>",
    [<%= base_class %><%= mixins.size > 0 ? ',' : '' %><%= mixins.join(',') %>],
{
    // summary:
    //  HERE SUMMARY 
    //
    // description:
    // HERE DESCRIPTION
    //
    // example:
    // |
    // | HERE EXAMPLE
    // |
    // baseClass: [protected] String
    //    The root className to use for the various states of this widget
    baseClass: "<%= no_dots_name %>",

    <% if is_templated %>
    templatePath: dojo.moduleUrl("<%= package_name %>", "templates/<%= class_name %>.html"),
    <% end %>

    <% if widgets_in_template %>
    widgetsInTemplate: true,
    <% end %>

    // someVar: String
    //   HERE DESC 
    someVar: "",
    
    // open: Boolean
    //   HERE DESC 
    someFlag: true,

    postCreate: function(){
      this.inherited(arguments);
    },
    //called on resize
    layout: function() {
      //content box of widget
      var cb = this._contentBox;
      //layout children here with dojo.marginBox(childNode,newMarginBox);
    },
    _someFunction: function(/* String */ opt){
      // summary:
      //          HERE DESC	
      // tags:
      //          private
    },
    _onClick: function(/* Event */ event){
      // summary:
      //          HERE DESC	
      // tags:
      //          private
      console.log(event);
    }

});
})();
