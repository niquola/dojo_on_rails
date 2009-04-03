dojo.require('kley.mvc');
dojo.require('dojo.date.locale');

dojo.addOnLoad(function() {
     var contentLoadDefered = false;

     kley.mvc.app({
          models: {
               contentStore: function(contentId) {
                    if (contentLoadDefered && contentLoadDefered.fired == -1) {
                         contentLoadDefered.cancel();
                         contentLoadDefered = false;
                    }
                    dojo.publish('contentLoadingStarted', []);
                    contentLoadDefered = dojo.xhrGet({
                         url: '<%= class_name.downcase %>/lorem?contentId=' + contentId,
                         load: function(responce) {
                              dojo.publish('contentLoaded', [responce]);
                              contentLoadDefered = false;
                         },
                         error: function(error) {
                              dojo.publish('contentLoadingFailed', error);
                              contentLoadDefered = false;
                         }
                    });
               }
          },
          //controllers - automatically mapped on notifications with same name
          controllers: {
               navigate: function(content) {
                    this.models.contentStore(content);
               },
               contentLoaded: function(content) {
                    dojo.publish('setContent', content);
               }
          },
          //mediators initialization
          mediators: {
               navigation: function(view) {
                    dojo.connect(view.domNode, 'onclick', function(event) {
                         var target = event.target;
                         var content = dojo.attr(target, 'contentId');
                         if (content) {
                              dojo.query('.selected', view.domNode).removeClass('selected');
                              dojo.addClass(target, 'selected');
                              dojo.publish('navigate', [content]);
                         }
                    });
               },
               contentViewer: function(view) {
                    dojo.subscribe('contentLoaded', function(content) {
                         view.attr('content', content);
                    });
               },
               console: function(view) {
                    var log = function(mes) {
                         view.attr('content', view.attr('content') + '<p>[' + dojo.date.locale.format(new Date(), {
                              selector: 'time'
                         }) + '] ' + mes + '</p>');
                    };
                    dojo.subscribe('contentLoadingStarted', function() {
                         log('Loading content...');
                    });
                    dojo.subscribe('contentLoadingFailed', function() {
                         log('Content loading failed');
                    });
                    dojo.subscribe('contentLoaded', function() {
                         log('Content loaded');
                    });
               }
          }
     });
     //animate header
     dojo.animateProperty({
          node: dojo.byId("logo"),
          duration: 5000,
          properties: {
               backgroundColor: {
                    start: "#fff",
                    end: "#ff9"
               },
               paddingLeft: {
                    start: "200",
                    end: "15"
               },
               color: {
                    start: "gray",
                    end: "#005"
               }
          },
          onEnd: function() {
               dojo.byId("logo").innerHTML += "!!!";
          }
     }).play();
});
