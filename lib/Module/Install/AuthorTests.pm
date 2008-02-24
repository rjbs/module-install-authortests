package Module::Install::AuthorTests;

use strict;
use Module::Install::Base;

use vars qw{$VERSION $ISCORE @ISA};
BEGIN {
  $VERSION = '0.001';
  $ISCORE  = 1;
  @ISA     = qw{Module::Install::Base};
}

sub _wanted {
  my $href = shift;
  sub { /\.t$/ and -f $_ and $href->{$File::Find::dir} = 1 }
}

sub _add_author_tests {
  my ($self, $dirs, $recurse) = @_;
  return unless $Module::Install::AUTHOR;

  my @tests = split / /, $self->tests;

  # XXX: pick a default, later
  my @dirs = @$dirs ? @$dirs : die "no dirs given to author_tests";
     @dirs = grep { -d } @dirs;

  if ($recurse) {
    require File::Find;
    my %test_dir;
    File::Find::find(_wanted(\%test_dir), @dirs);
    $self->tests( join ' ', @tests, map { "$_/*.t" } sort keys %test_dir );
  } else {
    $self->tests( join ' ', @tests, map { "$_/*.t" } sort @dirs );
  }
}

sub author_tests {
  my ($self, @dirs) = @_;
  _add_author_tests($self, \@dirs, 0);
}

sub recursive_author_tests {
  my ($self, @dirs) = @_;
  _add_author_tests($self, \@dirs, 1);
}
