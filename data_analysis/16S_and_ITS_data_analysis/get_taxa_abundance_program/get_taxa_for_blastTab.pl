#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use FindBin '$Bin';
use Cwd 'abs_path';
use File::Basename;

our ($in,$out,$id);
GetOptions (
	"i|in=s" => \$in,
	"id:s" => \$id,
	"o:s"    => \$out
);

if (!$in ||!$out || !$id) {
	print STDERR <<USAGE;
=============================================================================
Descriptions: Get the sub matrix
Usage:
	perl $0 [options]
Options:
	* -i          input file.out file [*.out] (blast output)
	* -id	      input subset of 16S or ITS taxa tab (creat by myshu)
	* -o          output file
E.g.:
	perl $0 -i test.out -id test.txt -o out.tab
=============================================================================
USAGE
	exit;
}

my %hash=();
open (LIST,$id) || die "$!";
while (<LIST>) {
	chomp;
	my @id=split/\t/,$_;
	$hash{$id[0]}=@id[1..3];
}close LIST;

open IN,$in || die$!;

open (OUT,">$out") or die $!;
while (<IN>) {
	chomp;
	my @bb=split/\t/,$_;
	if (exists $hash{$bb[1]}) {
		print OUT "$_\t$hash{$bb[1]}\n";
	}
}close IN;close OUT;

