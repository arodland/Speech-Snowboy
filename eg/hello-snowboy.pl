#!/usr/bin/perl
use strict;
use warnings;
use Audio::PortAudio;
use Speech::Snowboy::Raw;
use IO::Async::Loop;
use IO::Async::PortAudio;
use FindBin;

my $resources = "$FindBin::Bin/../snowboy/resources";

my $loop = IO::Async::Loop->new;

my $snowboy = Speech::Snowboy::Raw->new("$resources/common.res", "$resources/snowboy.umdl");
my $sample_rate = $snowboy->SampleRate;
my $bits = $snowboy->BitsPerSample;
my $channels = $snowboy->NumChannels;
warn "Loaded model (${sample_rate}Hz, ${bits}bit, ${channels}ch)\n";

my $frames_per_buffer = int($sample_rate / 10);

my $portaudio = Audio::PortAudio::default_host_api();

my $input = IO::Async::PortAudio->new(
  stream => $portaudio->default_input_device->open_read_stream(
    {
      channel_count => $channels,
      sample_format => "int${bits}",
    },
    $sample_rate,
    $frames_per_buffer,
    0,
  ),
  stream_type => 'r',
  sample_rate => $sample_rate,
  frames_per_buffer => $frames_per_buffer,
  on_read => \&on_read,
);

$loop->add($input);
$loop->run;

sub on_read {
  my ($stream, $data) = @_;
  my $pack_format = {
    16 => "s",
    32 => "l",
  }->{$bits};
  my @samples = unpack "${pack_format}*", $data;
  my $ret = $snowboy->${\"RunDetectionInt${bits}"}(\@samples);
  if ($ret == 0) {
    print "Non-hotword speech\n";
  } elsif ($ret > 0) {
    print "Hotword $ret\n";
  } elsif ($ret != -2) { # -2 is silence
    print "Error $ret\n";
  }
}
