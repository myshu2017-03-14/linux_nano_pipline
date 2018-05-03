
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
my($input_file,$output_file,$tab_file);  #选项的hash表
GetOptions(
  "in=s"  => \$input_file,     #输入文件
  "tab=s" => \$tab_file,
  "out=s" => \$output_file,    #输出文件
  "help|?"=> \&USAGE,
 ) or &USAGE;
&USAGE unless (defined $input_file and $output_file);  #判断选项的合法性
&log_current_time("\n$output_file\n$Script start……");    #调用时间函数

#----------------------------------------------------------------------------
#load input file,save the result
#----------------------------------------------------------------------------
my (%annotation,$k);

open I1,"$tab_file";  #<Entry>	<Protein names>
open I,"$input_file"||die "can't open the file: $!\n";  
open O,">$output_file"||die "can't open the file: $!\n";
while(<I1>){
#	chomp;
	if(/^(\S+?)\s(.*)$/){
	$annotation{$1}=$2;  #gi =>ref_genome name
 }
}

while(<I>){
#	chomp;
	#ST-E00291:185:HGVTNALXX:6:2216:13798:67410/1	NC_014644.1	77.61	134	30	0	14	147	808108	807975	3.00E-17	82.4
	if(/^(\S+?)\s(\S+?)\s(\S+?.*)$/){

		if($annotation{$2}){
			$k=$annotation{$2};
		print O "$1\t$2\t$k\t$3\n"; 
		}
	}
}
close I1;
close I;
close O;
#----------------------------------------------------------------------------------
#ending of work
#----------------------------------------------------------------------------------
&log_current_time("\n$output_file\n$Script end……");    #调用时间函数
my $run_time=time()-$BEGIN_TIME;
print "$Script run time :$run_time\.s\n";


#----------------------------------------------------------------------------------
#function 
#----------------------------------------------------------------------------------
sub log_current_time {
	my ($info) = @_;    
	my $curr_time = &date_time_format(localtime(time()));  
	print "[$curr_time] $info\n";    #输出打印
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
    Data:2018-01-22
Function:get annotation from blast tab file(m6)
   USAGE:
         -in    <STR>   input file [Must]
         -tab   <STR>   input tab file
	 -out   <STR>   output file   [Optional]
         -help          show the docment and exit
 Example:
    perl $Script -in file1 -out file2
#---------------------------------------------------------
__USAGE__
   print $usage;  
   exit;      
}
