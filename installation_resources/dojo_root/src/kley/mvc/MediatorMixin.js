dojo.provide("kley.mvc.MediatorMixin");
dojo.declare('kley.mvc.MediatorMixin', null, {
  publish: function() {
    var opts = dojo._toArray(arguments);
    var topic = opts.shift();
    dojo.publish(topic, opts);
  }
});
