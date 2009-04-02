(function() {
  dojo.provide('kley.mvc');

  //private debug flag
  var do_notifications = true;
  //start mvc function
  var start = function(app) {
    //connect to dojo publish to intercept notifications
    dojo.connect(dojo, 'publish',
    function(topic, args) {
      if (do_notifications) {
        console.log(arguments);
      }
      if (app.controllers[topic]) {
        app.controllers[topic].apply(app, args);
      }
    });
    //go throu mediators and call them
    console.log(views);
    for (p in app.mediators) {
      if (typeof views != 'undefined' && views[p]) {
        console.log(views[p]);
        app.mediators[p].apply(app,[views[p]]);
      } else {
        app.mediators[p].apply(app);
      }
    }

  };

  dojo.mixin(kley.mvc, {
    app: start
  });
})();
