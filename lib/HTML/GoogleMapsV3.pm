package HTML::GoogleMapsV3;


use Geo::Coder::Google;
use XML::Simple;
use Data::Dumper;
#use Geo::Inverse;
use GPS::Point;
use strict;
no strict "refs";

BEGIN {
    use Exporter ();
    use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
    $VERSION     = '0.01';
    @ISA         = qw(Exporter);
    #Give a hoot don't pollute, do not export more than needed by default
    @EXPORT      = qw();
    @EXPORT_OK   = qw();
    %EXPORT_TAGS = ();
}


#################### subroutine header begin ####################

=head2 sample_function

 Usage     : How to use this function/method
 Purpose   : What it does
 Returns   : What it returns
 Argument  : What it wants to know
 Throws    : Exceptions and other anomolies
 Comment   : This is a sample subroutine header.
           : It is polite to include more pod and fewer comments.

See Also   : 

=cut

#################### subroutine header end ####################


sub new
{
    my ($class, $parm) = @_;

    my $self = bless ({}, ref ($class) || $class);


	$self->{'apikey'} = $parm->{'apikey'};
	
    return $self;
    
    
}


sub onload_render 
{
	my $self = shift;
	#map_canvas { height: 100% }
	
	my $header='
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<style type="text/css">
  		html { height: 95% }
  		body { height: 95%; margin: 0px; padding: 0px }
  		#map_canvas { height: 100% }
	</style>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?libraries=panoramio,geometry&v=3.4&sensor=false">
	</script>
	<script type="text/javascript">
  	var lengthLine=0;
  	function html_googlemaps_initialize() {
    var latlng = new google.maps.LatLng(' .$self->{latitude} . ',' . $self->{longitude} . ');
    var myOptions = {
      zoom: 14,
      center: latlng,
      rotateControl: true,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    
    map = new google.maps.Map(document.getElementById("map_canvas"),
        myOptions);
    
    map.setOptions( {rotateControl : true });
    

	';
	
	if( defined $self->{polyline} ) {
		foreach my $polyline ( keys %{$self->{polyline}} ) {
			$header .= $self->{polyline}->{$polyline} . "\n";
		}
	}
	
	$header .= '}
	</script>';
	
	
	my $div = '<div id="map_canvas" style="width:80%; height:75%"></div>';


	$header .= "<SCRIPT>
	
	panoramioLayer = new google.maps.panoramio.PanoramioLayer();
	
	function panoramioOn(){ 
								panoramioLayer.setMap(map);
	}
	function panoramioOff() {
		panoramioLayer.setMap(null);
	}
	
	function panoramioToggle() {
		if( panoramioLayer.getMap() == null ) {
			panoramioOn(); 
		} else {
			panoramioOff();
		}
	}	
	

		
	</SCRIPT>";

	return ($header,$div)
	
}

sub center
{
	my $self = shift;
	my $location = shift;
	my $geo = Geo::Coder::Google->new(apikey=>$self->{apikey});
	my $loc = $geo->geocode( location => $location );

	$self->{latitude} = $loc->{Point}->{coordinates}[1];
	$self->{longitude} = $loc->{Point}->{coordinates}[0];
	
}

sub load_kml
{
	my ($this, $fname) = @_;
	
	my $kml = XMLin($fname,ForceArray => 1);
	
	$this->{kml} = $kml;
	
}

sub del_polyline {
	
	
	
}

sub add_polyline {
 
 	my($this, $name, @polyline) = @_;
 	
 	$this->{polyline}->{$name} .= $name . ' = [';
 	
 	my $length;
 	my $lastpoint;
 	my $thispoint;
	foreach my $segment ( @polyline ) {
		
		$this->{polyline}->{$name} .= '	new google.maps.LatLng(';
		$this->{polyline}->{$name} .= @$segment[0] . ',' . @$segment[1] . "),\n";
		
		$thispoint = GPS::Point->newMulti(@$segment[0],	@$segment[1],@$segment[2]);
					
		if( defined $lastpoint ) {
			$length += $thispoint->distance($lastpoint);
		}
		$lastpoint = $thispoint;
	}; 
		
	$this->{pathLength}->{$name} = $length; 	
  	$this->{polyline}->{$name} .='];
  	
  	  
	gPath'. $name .' = new google.maps.Polyline({
	    path: '.$name.',
	    strokeColor: "#0000FF",
	    strokeOpacity: 1.0,
	    strokeWeight: 2
	});
	
	  
	gPath'.$name. '.setMap(map);
	  
	var bounds = new google.maps.LatLngBounds();
	
	for (var i = 0; i < '.$name.'.length; i++) {
	 	
	 	bounds.extend('.$name.'[i]);
	}
	
	
	map.fitBounds(bounds);

	';

	return $this->{polyline}->{$name} ;
 	
}




#################### main pod documentation begin ###################
## Below is the stub of documentation for your module. 
## You better edit it!


=head1 NAME

HTML::GoogleMapsV3 - Draw Maps using the Google V3 API

=head1 SYNOPSIS

  use HTML::GoogleMapsV3;
  blah blah blah


=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.


=head1 USAGE



=head1 BUGS



=head1 SUPPORT



=head1 AUTHOR

    David Peters
    CPAN ID: DAVIDP
    davidp@electronf.com

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################


1;
# The preceding line will help the module return a true value

