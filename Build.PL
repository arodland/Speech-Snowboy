#!/usr/bin/perl -w
use strict;
use Module::Build::WithXSpp;
 
my $build = Module::Build::WithXSpp->new(
  module_name     => 'Speech::Snowboy::Raw',
  license         => 'perl',
  extra_typemap_modules => {
    'ExtUtils::Typemaps::ObjectMap' => '0.01',
  },
  extra_linker_flags => [ qw(libsnowboy-detect.a) ],
  extra_compiler_flags => [ qw(-std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0) ],
  requires        => {},
  # Provides useful extra C typemaps for opaque objects:
);
 
$build->create_build_script;
