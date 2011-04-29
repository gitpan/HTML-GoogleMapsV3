

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'HTML::GoogleMapsV3',
    VERSION_FROM => 'lib/HTML/GoogleMapsV3.pm', # finds \$VERSION
    AUTHOR       => 'David Peters (davidp@electronf.com)',
    ABSTRACT     => 'Draw Maps using the Google V3 API',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
		     'Geo::Google' => 0.05,
                    },
);
