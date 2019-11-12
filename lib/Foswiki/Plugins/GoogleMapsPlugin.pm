# Plugin for Foswiki - The Free and Open Source Wiki, https://foswiki.org/
#
# GoogleMapsPlugin is Copyright (C) 2013-2019 Michael Daum https://michaeldaumconsulting.com
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details, published at
# http://www.gnu.org/copyleft/gpl.html

package Foswiki::Plugins::GoogleMapsPlugin;

use strict;
use warnings;

use Foswiki::Func ();
use Foswiki::Plugins::JQueryPlugin ();

our $VERSION = '3.12';
our $RELEASE = '12 Nov 2019';
our $SHORTDESCRIPTION = 'Google Maps for Foswiki';
our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {

  Foswiki::Func::registerTagHandler('GOOGLEMAPS', \&GOOGLEMAPS);

  return 1;
}

sub GOOGLEMAPS {
  my $session = shift;

  my $plugin = Foswiki::Plugins::JQueryPlugin::createPlugin('GoogleMaps');
  return $plugin->GOOGLEMAPS(@_) if $plugin;
  return '';
}

1;
