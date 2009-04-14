dojo.provide('<%= app_name%>');
dojo.require('<%= app_name%>.models');
dojo.require('<%= app_name%>.views');
dojo.require('<%= app_name%>.controllers');
dojo.require('<%= app_name%>.autorequire');
dojo.require('kley.mvc');

dojo.addOnLoad(function() {
	kley.mvc.app(<%= app_name%>);
});
