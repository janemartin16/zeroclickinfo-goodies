package DDG::Goodie::EmToPx;
# ABSTRACT: em <-> px for font sizes.

use strict;
use warnings;
use DDG::Goodie;

triggers any => "em", "px";

zci answer_type => "conversion";
zci is_cached   => 1;

primary_example_queries '10 px to em';
secondary_example_queries '12.2 px in em assuming a 12.2 font size';
description 'convert from px to em';
name 'EmToPx';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EmToPx.pm';
category 'conversions';
topics 'programming';
attribution twitter => ['crazedpsyc','crazedpsyc'],
            cpan    => ['CRZEDPSYC','crazedpsyc'];

handle query_raw => sub {
    my $q = lc $_;
    $q =~ s/(?![\.\s])\W//g;
    return unless $q =~ /^(?:convert|change|what\s*(?:s|is|are)\s+)?(?<num>\d+\.\d*|\d*\.\d+|\d+)\s*(?<source>em|px)\s+(?:in|to)\s+(?<target>em|px)(?:\s+(?:with|at|using|assuming)(?:\s+an?)?\s+(?<fs>\d+\.\d*|\d*\.\d+|\d+)\s*px)?/;
    my ($target, $num, $source, $fontsize) = map { $+{$_} } qw(target num source fs);
    $fontsize ||= 16;

    return if ($target eq $source || !$num);

    my $result = ($target eq 'px') ? $num * $fontsize : $num / $fontsize;
    my $plur   = $result == 1      ? "is"             : "are";

    return $result,
        structured_answer => {
            id   => 'em_to_px',
            name => 'Answer',
            data => {
                title    => $result,
                subtitle => $formatted_input,
            },
            templates => {
                group  => 'text',
                moreAt => 0,
            },
        };
};

1;
