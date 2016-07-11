"use strict";
(function($) {

   $('#example2').livequery(function() {
      var $this = $(this);

      function init() {
         $this.gmap3({
            marker: {
               address: "London"
            },
            map:{
               options:{
                  zoom: 15,
               },
               events: {
                 bounds_changed: function(map) {
                    var center = map.getCenter();
                    $("#lat").val(center.lat());
                    $("#lng").val(center.lng());
                    $("#zoom").val(map.getZoom());
                    $this.gmap3({
                       getaddress: {
                          latLng:center,
                          callback:function(results){
                             var address = results && results[0] ? results[0].formatted_address : "no address";
                             $("#address").val(address);
                          }
                       }
                    });
                 }
              }
           }
         });
      }

      if (!window.googleApiLoaded) {
         $(window).on("googleApiLoaded", function() {
            init();
         });
      } else {
         init();
      }

      function updateMap() {
         $this.gmap3({
            clear: {},
            getlatlng: {
               address: $("#address").val(), 
               callback: function(results) { 
                  if (results) {
                     var pos = results[0].geometry.location;
                     $this.gmap3({
                        map: {
                           options: {
                              center: pos,
                              zoom: parseInt($("#zoom").val(),10)
                           }
                        },
                        marker: {
                           latLng: pos
                        }
                     });
                  }
               }
            }
         });
      }

      $("#searchAddress").click(function() {
         updateMap();
         return false;
      });

      $("#address, #zoom").keydown(function(ev) {
         if (ev.keyCode == 13) {
            updateMap();
            return false;
         }
      });

      $("#lat, #lng").keydown(function(ev) {
         if (ev.keyCode == 13) {
            var lat = parseFloat($("#lat").val()),
                lng = parseFloat($("#lng").val());
            $this.gmap3({
               map: {
                  options: {
                     center: [lat, lng]
                  }
               },
               latLng: {
                  position: [lat, lng]
               }
            });
         }
      });
   });
})(jQuery);