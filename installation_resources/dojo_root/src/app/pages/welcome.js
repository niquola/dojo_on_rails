dojo.require('kley.mvc');

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
          url: 'content?contentId=' + contentId,
          load: function(responce) {
            dojo.publish('contentLoaded', [responce]);
            delete contentLoadDefered;
          },
          error: function(error) {
            dojo.publish('contentLoadingFailed', error);
            delete contentLoadDefered;
          }
        })
      }
    },
    controllers: {
      navigate: function(content) {
        console.log('navigate', content);
        this.models.contentStore(content);
      },
      contentLoaded: function(content) {
        dojo.publish('setContent', content);
      }
    },
    mediators: {
      navigation: function(view) {
        dojo.connect(view.domNode, 'onclick',
        function(event) {
          var target = event.target;
          var content = dojo.attr(target, 'content');
          if (content) {
            dojo.query('.selected', view.domNode).removeClass('selected');
            dojo.addClass(target, 'selected');
            dojo.publish('navigate', [content]);
          }
        });
      },
      contentViewer: function(view) {
        dojo.subscribe('contentLoaded',
        function(content) {
          console.log(view);
          view.attr('content', content);
        });
      }
    }
  });

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
      },
    },
    onEnd: function() {
      dojo.byId("logo").innerHTML += "!!!";
    }
  }).play();
});
