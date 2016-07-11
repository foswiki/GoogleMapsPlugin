# ---+ Extensions
# ---++ GoogleMapsPlugin
# **STRING**
# An application key to be used to access the Google Maps JavaScript API from a browser.
$Foswiki::cfg{GoogleMapsPlugin}{APIKey} = '';
# ---++ JQueryPlugin
# ---+++ Extra plugins
# **STRING**
$Foswiki::cfg{JQueryPlugin}{Plugins}{GoogleMaps}{Module} = 'Foswiki::Plugins::GoogleMapsPlugin::Core';
# **BOOLEAN**
$Foswiki::cfg{JQueryPlugin}{Plugins}{GoogleMaps}{Enabled} = 1;
1;
