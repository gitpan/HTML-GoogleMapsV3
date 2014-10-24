# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'HTML::GoogleMapsV3' ); }

my $object = HTML::GoogleMapsV3->new ();
isa_ok ($object, 'HTML::GoogleMapsV3');


