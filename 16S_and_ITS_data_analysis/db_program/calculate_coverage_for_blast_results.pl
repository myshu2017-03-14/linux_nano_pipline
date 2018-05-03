
use strict;
use warnings;
use Cwd qw(abs_path);     
use Getopt::Long;        
use Data::Dumper;         
use FindBin qw($Bin $Script);  
use File::Basename qw(basename dirname);
use List::Util qw/sum max min maxstr minstr/;
my $BEGIN_TIME=time();   
my $version="1.0.0";

#core Perl modules
use Getopt::Long;
use Carp;  

#CPAN modules
use Bio::SeqIO;
use Bio::Perl;

#---------------------------------------------------------------------------
#GetOptions
#---------------------------------------------------------------------------
my($input_file,$output_file,$length_file);  #选项的hash表
GetOptions(
  "in=s"  => \$input_file,     #输入文件
  "len=s" => \$length_file,
  "out=s" => \$output_file,    #输出文件
  "help|?"=> \&USAGE,
 ) or &USAGE;
&USAGE unless (defined $input_file and $output_file);  #判断选项的合法性
&log_current_time("\n$output_file\n$Script start……");    #调用时间函数

#----------------------------------------------------------------------------
#load input file,save the result
#----------------------------------------------------------------------------
my ($cov,%len);

open I,"$input_file"||die "can't open the file: $!\n";  
open L,"$length_file"||die "can't open the file: $!\n"; 
open O,">$output_file"||die "can't open the file: $!\n";

while(<L>){
	chomp;
	if(/^(\S+)\s(\S+)$/){
		$len{$1}=$2;
	}
}

while(<I>){
	if(/^#/){next;}
	chomp;
	#Query	Subject	Annotation	%Identity 	Length	Mis-match	Gap	q.Start	q.End	s.Start	s.End 	E-value	Bit score
	#02e99665-b63a-4b8d-bead-83a86b26e6fd	NR_137344.1	Ursidibacter arcticus strain Bamse61 16S ribosomal RNA, partial sequence	93.94	33	2	0	20663	20695	4	36	0.011	47.4
	my @tmp=split /\t/,$_;
	$cov=sprintf "%.2f",100*(($tmp[8]-$tmp[7])/$len{$tmp[0]});
	#print $tmp[8]."\t".$tmp[7]."\t".$len{$tmp[0]}."\t".$cov;last;
	print O $_."\t$cov\t$len{$tmp[0]}\n";
}


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
	print "[$curr_time] $info\n";   
}
##########################################################################################################################
sub date_time_format {
	my ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst)=localtime(time());
	return sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);  #获取格式化的时间信息，不打印（sprintf的用法）
}
########################################################################################################################## 
sub USAGE{   
	my $usage=<<"__USAGE__";
#-----------------------------------------------------------
 Program:$Script
 Version:$version
 Contact:1291016966\@qq.com
    Data:2017-09-22
Function: 在比对的最后一列增加coverage的值以及序列长度，coverage= 100*((q.end-q.start)/q.len)
   USAGE:
         -in    <STR>   input blast format file (Add annotation) [Must]
         -len		<STR>   input tab file for seq length [seq_id	seq_len](can be getted by get_all_seq_legth.pl)
         -out   <STR>   output file   [Optional]
                        # Query	Subject	Annotation	%Identity 	Length	Mis-match	Gap	q.Start	q.End	s.Start	s.End 	E-value	Bit score	Coverage	Read Length
         -help          show the docment and exit
 Example:
    perl $Script -in file1 -len file.length -out file2
#---------------------------------------------------------
__USAGE__
   print $usage;  
   exit;     
 	} 
