"use strict";
jQuery(function($) {
  
  $(".gmap3").livequery(function() {
    var $this = $(this),
        opts = $this.data();

    if (typeof(opts.marker) !== 'undefined') {

      opts.marker.events =  {
        "click": function(marker, event, context) {
          var $this = $(this),
              infowindow = $this.gmap3({get:{name:"infowindow"}}),
              content;
          
          if (context.data) {
            content = context.data.replace(/, */g, '<br />');
    
            if (infowindow) {
              infowindow.open($this.gmap3("get"), marker);
              infowindow.setContent(content);
            } else {
              $this.gmap3({
                infowindow: {
                  anchor:marker, 
                  options:{ content: content }
                }
              });
            }
          } else {
            $this.gmap3({
              getaddress: {
                latLng:marker.getPosition(),
                callback:function(results){
                  var content = results && results[0] ? results[0].formatted_address : "no address";

                  if (infowindow){
                    infowindow.open($this.gmap3("get"), marker);
                    infowindow.setContent(content);
                  } else {
                    $this.gmap3({
                      infowindow: {
                        anchor:marker, 
                        options:{ content: content }
                      }
                    });
                  }
                }
              }
            });
          }
        }
      };
    }


    $this.gmap3(opts);
  });
});
