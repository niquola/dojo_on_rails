dependencies = {
	stripConsole: "normal",

	layers: [{
		name: "../dijit/dijit.js",
		dependencies: ["dijit.dijit"]
	},
	{
		name: "../dijit/dijit-all.js",
		layerDependencies: ["../dijit/dijit.js"],
		dependencies: ["dijit.dijit-all"]
	},
	{
		name: "../dojox/off/offline.js",
		layerDependencies: [],
		dependencies: ["dojox.off.offline"]
	},
	{
		name: "../dojox/grid/DataGrid.js",
		dependencies: ["dojox.grid.DataGrid"]
	},
	{
		name: "../dojox/gfx.js",
		dependencies: ["dojox.gfx"]
	},
	{
		name: "../kley/kley.js",
		dependencies: ["kley.kley-all"]
	},{
		name: "../app/pages/doctor.js",
		dependencies: ["app.pages.doctor"]
	}
  ],

	prefixes: [["dijit", "../dijit"], ["dojox", "../dojox"], ["kley", "../kley"], ["app", "../app"]]
};
