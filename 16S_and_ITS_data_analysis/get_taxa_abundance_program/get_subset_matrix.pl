#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use FindBin '$Bin';
use Cwd 'abs_path';
use File::Basename;

#my $fq="/lustre/Work/public_data/database/genome_DB/NCBI/accession2taxid/prot.accession2taxid.gz";

our ($in,$out,$n,$list);
GetOptions (
	"i|in=s" => \$in,
	"list:s" => \$list,
	"n:i"    => \$n,
	"o:s"    => \$out
);

if (!$in ||!$out || !$list ||!$n) {
	print STDERR <<USAGE;
=============================================================================
 Contact:1291016966\@qq.com
    Data:2018-05-03
Descriptions: Get the sub matrix
Usage:
	perl $0 [options]
Options:
	* -i          input file.tab file [*.tab]
	* -list	      input list
	* -n	      which colnume to matching
	* -o          output file
E.g.:
	perl $0 -i seqs.fa -conf para.conf -map maps.tsv -outdir outdir
=============================================================================
USAGE
	exit;
}

my %hash=();
open (LIST,$list) || die "$!";
while (<LIST>) {
	chomp;
	$hash{$_}=1;
}close LIST;

($in =~ /\.gz$/) ? open IN,"<:gzip",$in || die$! : open IN,$in || die$!;
open (OUT,">$out") or die $!;
while (<IN>) {
	chomp;
	my @bb=split/\t/,$_;
	my $m=$n-1;
	if (exists $hash{$bb[$m]}) {
		print OUT "$_\n";
	}
}close IN;close OUT;
