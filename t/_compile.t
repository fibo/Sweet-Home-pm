use strict;
use warnings;
use Test::More;

eval "use Test::Compile";
Test::More->builder->BAIL_OUT(<<EOF) if $@;
Test::Compile required for testing compilation
EOF

all_pm_files_ok();

