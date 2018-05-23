
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
my($input_file,$output_file,$old);  #选项的hash表
GetOptions(
  "in=s"  => \$input_file,     #输入文件
  "old=s" => \$old,
  "out=s" => \$output_file,    #输出文件
  "help|?"=> \&USAGE,
 ) or &USAGE;
&USAGE unless (defined $input_file and $output_file);  #判断选项的合法性
&log_current_time("\n$output_file\n$Script start……");    #调用时间函数

#----------------------------------------------------------------------------
#load input file,save the result
#----------------------------------------------------------------------------
my $flag=1;
my $tag=0;
my $head;
my (@value,$value);
my $length=1;
my (%old,%new);
my $tmp;

open I,"$input_file"||die "can't open the file: $!\n";  
open OLD,"$old"||die "can't open the file: $!\n";
open O,">$output_file"||die "can't open the file: $!\n";
my $old_name=basename($old);
my $name=basename($input_file);
while(<OLD>){
	chomp;
	if($flag==1){
		if(/^taxonomy/){
			$flag++;
			$head=$_;
		#	print $head;
			next;
		}elsif(/^(.*)\t(\S+)$/){
			$head="taxonomy\t$old_name";
			$tag=1;
			$flag++;
			$old{$1}=$2;
#			print $1."\t".$old{$1};
		}
	}elsif(/^(.*)\t(\S+)/){
		if($tag){
			$old{$1}=$2;
			#print $old{$1};
		}else{
			@value=split /\t/,$_;
			$tmp=shift(@value);
			$length=scalar(@value);
			$value=join("\t",@value);
		#	print $value."\t".$length."\n";
			$old{$tmp}=$value;
		#	print $tmp.$value."\n";
		}
	}
}
# print header 
print O "$head\t$name\n";

while(<I>){
	chomp;
	if(/^(.*)\t(\S+)$/){
		$new{$1}=$2;
		if($old{$1}){
			print O "$1\t$old{$1}\t$2\n";
		}else{
			my $tmp="$1";
			for(my $i=0;$i<$length;$i++){
				$tmp.="\t0.00";
			}
			print O "$tmp\t$2\n";
		}
		
	}
}
my $key;
foreach $key(keys %old){
#	print $key."\t".$old{$key}."\n";
	if(!$new{$key}){
		print O "$key\t$old{$key}\t0.00\n";
	}
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
    Data:2018-02-24
Function: cat all sample abundance to one file
   USAGE:
         -in    <STR>   input file [Must]
         -old   <STR>   input old file (may be a new file or inculde header file)
	 -out   <STR>   output file   [Optional]
         -help          show the docment and exit
 Example:
    perl $Script -in file1 -out file2
#---------------------------------------------------------
__USAGE__
   print $usage;  
   exit;      
 	} 
