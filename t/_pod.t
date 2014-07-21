use strict;
use warnings;
use Test::More;

eval "use Test::Pod";
Test::More->builder->BAIL_OUT(<<EOF) if $@;
Test::Pod required for testing compilation
EOF

all_pod_files_ok();

