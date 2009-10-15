dojo.require("doh.runner");
//dojo.require("dojo.robot");
dojo.require("<%= full_name%>");

dojo.addOnLoad(function () {
	doh.register("<%= full_name%>", [
	function test1(t) {
		t.t(false, 'not implemented');
	},
	function asyncTest(t) {
		var d = new doh.Deferred();
		t.t(false, 'not implemented');
		//d.callback(true);
		return d;
	}]);
	doh.run();
});
