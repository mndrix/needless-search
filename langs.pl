#!/usr/bin/env perl
use strict;
use warnings;
use experimental qw( say signatures );
use autodie qw( system );

use File::Slurp qw( read_file );
use Template;
use YAML::XS qw( Load );

# by-products of the linguist file
my $info_by_alias;    # alias => language details

# process linguist data
my $langs = Load( scalar read_file $yaml_file);
while ( my ( $lang, $info ) = each %$langs ) {
    my @aliases = $lang;
    push @aliases, @{ $info->{aliases} // [] };

    for my $alias (@aliases) {
        $info_by_alias->{ nickname($alias) } = $info;
    }
}

# generate corresponding Go code
my $tt = Template->new;
$tt->process( 'langs.tt', { langs => $info_by_alias } )
  or die( $tt->error(), "\n" );

exit;

# convert linguist language name into a nickname used
# for needless search commands
sub nickname($name) {
    $name =~ s/\s+/-/g;
    return lc($name);
}
