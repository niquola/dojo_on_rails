(function() {
	var controllers = dojo.provide('<%= app_name%>.controllers');
	//published actions 
	controllers.actions = {
		startup: function() {},
		exit: function() {}
	};
	//views topics two level hash
	controllers.views = {};
	//models topics three level hash
	controllers.models = {};
})();
