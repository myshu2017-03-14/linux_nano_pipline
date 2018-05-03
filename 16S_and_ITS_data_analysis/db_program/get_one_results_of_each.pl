
use strict;
use warnings;
use Cwd qw(abs_path);     
use Getopt::Long;         
use Data::Dumper;         
use FindBin qw($Bin $Script); 
use File::Basename qw(basename dirname);  
my $BEGIN_TIME=time();    
my $version="1.0.0";

#---------------------------------------------------------------------------
#GetOptions
#---------------------------------------------------------------------------
my($input_file,$output_file);  #ѡ���hash��
GetOptions(
  "in=s"  => \$input_file,     #�����ļ�
  "out=s" => \$output_file,    #����ļ�
  "help|?"=> \&USAGE,
 ) or &USAGE;
&USAGE unless (defined $input_file and $output_file);  #�ж�ѡ��ĺϷ���
&log_current_time("\n$output_file\n$Script start����");    #����ʱ�亯��

#----------------------------------------------------------------------------
#load input file,save the result
#----------------------------------------------------------------------------

my %hash=();
open I,"$input_file"||die "can't open the file: $!\n";  
open O,">$output_file"||die "can't open the file: $!\n";
while(<I>){
	#chomp;
	if(/^(\S+?)\s(.*)/){
		if($hash{$1}){next;}
		$hash{$1}=$_;
		#print O $1."\t".$2."\n";
	}
}

foreach (sort keys %hash){
	print O $hash{$_};
}

close I;
close O;
#----------------------------------------------------------------------------------
#ending of work
#----------------------------------------------------------------------------------
&log_current_time("\n$output_file\n$Script end����");    #����ʱ�亯��
my $run_time=time()-$BEGIN_TIME;
print "$Script run time :$run_time\.s\n";


#----------------------------------------------------------------------------------
#function 
#----------------------------------------------------------------------------------
sub log_current_time {     
	my ($info) = @_;   
	my $curr_time = &date_time_format(localtime(time())); 
	print "[$curr_time] $info\n";   
}
##########################################################################################################################
sub date_time_format {
	my ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst)=localtime(time());
	return sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec); 
}
########################################################################################################################## 
sub USAGE{  
	my $usage=<<"__USAGE__";
#-----------------------------------------------------------
 Program:$Script
 Version:$version
 Contact:1291016966\@qq.com
    Data:2018-05-03
Function: get one read to one results
   USAGE:
         -in    <STR>   input file [Must]
         -out   <STR>   output file   [Optional]
         -help          show the docment and exit
 Example:
    perl $Script -in file1 -out file2
#---------------------------------------------------------
__USAGE__
   print $usage;  
   exit;      
 	} 
