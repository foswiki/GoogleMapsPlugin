# Plugin for Foswiki - The Free and Open Source Wiki, https://foswiki.org/
#
# GoogleMapsPlugin is Copyright (C) 2013-2017 Michael Daum https://michaeldaumconsulting.com
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

package Foswiki::Plugins::GoogleMapsPlugin::Core;

use strict;
use warnings;

use Foswiki::Plugins::JQueryPlugin::Plugins ();
use Foswiki::Plugins::JQueryPlugin::Plugin ();
use Foswiki::Plugins ();
use JSON ();
use Error qw(:try);

our @ISA = qw( Foswiki::Plugins::JQueryPlugin::Plugin );

sub new {
  my $class = shift;

  my $this = bless(
    $class->SUPER::new(
      name => 'GoogleMaps',
      version => '6.1.0',
      author => 'Jean-Baptiste Demonte',
      homepage => 'http://v6.gmap3.net/',
      javascript => ['pkg.js'],
      documentation => 'GoogleMapsPlugin',
      puburl => '%PUBURLPATH%/%SYSTEMWEB%/GoogleMapsPlugin',
      dependencies => ['JQUERYPLUGIN::GOOGLEMAPSAPI'],
    ),
    $class
  );

  return $this;
}

sub init {
  my $this = shift;

  return unless $this->SUPER::init();

  my $session = $Foswiki::Plugins::SESSION;
  my $language = $session->i18n->language();
  my $apiKey = $Foswiki::cfg{GoogleMapsPlugin}{APIKey};
  $apiKey = $apiKey?"&key=$apiKey":"";

  Foswiki::Func::addToZone('script', "JQUERYPLUGIN::GOOGLEMAPSAPI", <<"HERE", "JQUERYPLUGIN");
<script type="text/javascript">
function initGoogleApi() {
  jQuery(window).trigger('googleApiLoaded');
  window.googleApiLoaded = true;
}
</script>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?language=$language$apiKey&callback=initGoogleApi" ></script>
HERE

}

sub GOOGLEMAPS {
  my ($this, $params, $theTopic, $theWeb) = @_;

  my %opts = ();
  my $address = $params->{address};
  $opts{map}{address} = $address if defined $address;

  my $center = $params->{center};
  $opts{map}{options}{center} = [split(/\s*,\s*/, $center)] if defined $center;

  my $zoom = $params->{zoom} || 1;
  $opts{map}{options}{zoom} = int($zoom);

  my $markerValuesParam = $params->{markeraddress};
  if (defined $markerValuesParam) {
    foreach my $marker (split(/\s*[\n;]\s*/, $markerValuesParam)) {
      my ($address, $data) = split(/\s*=\s*/, $marker);
      unless ( $data ) {
        $data = $address unless ( $marker =~ m/=/ );
      }  
      push(@{$opts{marker}{values}}, {address => $address, data => $data});
    }
  }

  my $infoWindow = $params->{infowindow};
  $opts{infowindow}{options}{content} = $infoWindow if defined $infoWindow;

  my $infoWindowAddress = $params->{infowindowaddress};
  $opts{infowindow}{address} = $infoWindowAddress if defined $infoWindowAddress;

  my $infoWindowPosition = $params->{infowindowposition};
  $opts{infowindow}{options}{position} = [split(/\s*,\s*/, $infoWindowPosition)] if defined $infoWindowPosition;

  my $mapType = $params->{type};
  $opts{map}{options}{mapTypeId} = $mapType if defined $mapType;

  $opts{map}{options}{mapTypeControl} = _isTrue($params->{typecontrol}, 1);
  $opts{map}{options}{navigationControl} = _isTrue($params->{navigationcontrol}, 1);
  $opts{map}{options}{streetViewControl} = _isTrue($params->{streetviewcontrol}, 1);
  $opts{map}{options}{scrollwheel} = _isTrue($params->{scrollwheel}, 1);

  my $height = $params->{height};
  $height = '350px' unless defined $height;
  my $width = $params->{width};

  my @styles = ();
  push @styles, "height:$height";
  push @styles, "width:$width" if defined $width;

  my $id = $params->{id};
  $id = 'gmap3' . Foswiki::Plugins::JQueryPlugin::Plugins::getRandom() unless defined $id;
 
  return "<div class='gmap3' ".$this->_toHtml5Data(\%opts)." id='$id' style='".join(";", @styles)."'></div>";
}

sub _toHtml5Data {
  my ($this, $opts) = @_;

  my @data = ();
  foreach my $key (keys %$opts) {
    my $val = $opts->{$key};
    if (ref($val)) {
      $val = $this->_json->encode($val);
    } else {
      $val = Foswiki::entityEncode($val);
    }
    push @data, "data-$key='$val'";
  }

  return join(" ", @data);
}

sub _isTrue {
  my ($val, $default) = @_;
  return Foswiki::Func::isTrue($val, $default)?JSON::true:JSON::false;
}

sub _json {
  my $this = shift;

  unless (defined $this->{_json}) {
    $this->{_json} = JSON->new; 
  }

  return $this->{_json};
}

sub _inlineError {
  return "<div class='foswikiAlert'>$_[0]</div>";
}

1;
