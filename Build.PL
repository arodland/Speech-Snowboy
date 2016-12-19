#!/usr/bin/perl -w
use strict;
use Module::Build::WithXSpp;

my $ARCH = "ubuntu64";

my $build = Module::Build::WithXSpp->new(
  module_name     => 'Speech::Snowboy::Raw',
  license         => 'perl',
  extra_typemap_modules => {
    'ExtUtils::Typemaps::ObjectMap' => '0.01',
  },
  extra_linker_flags => [ "snowboy/lib/$ARCH/libsnowboy-detect.a", "-lcblas" ],
  extra_compiler_flags => [ "-Isnowboy/include", qw(-std=c++11 -D_GLIBCXX_USE_CXX11_ABI=0) ],
  requires        => {},
  # Provides useful extra C typemaps for opaque objects:
);
 
$build->create_build_script;
