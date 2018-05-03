
use strict;
use warnings;
use Cwd qw(abs_path);      #获取工作路径，即当前目标所在的路径（函数括号里的东西）
use Getopt::Long;          #获取选项
use Data::Dumper;          #可打印引用的东西。eg：print Dumper(\%hash \@array);
use FindBin qw($Bin $Script);  #$Bin  调用脚本的bin目录的路径，$Script  脚本名称  $RealBin 调用脚本的绝对路径  $RealScript  与脚本相关的脚本（用不着）
use File::Basename qw(basename dirname);  #basename函数获取文件名  dirname函数获取路径  fileparse函数获取扩展名
use List::Util qw/sum max min maxstr minstr/; #对数组进行求和，求最大值最小值
my $BEGIN_TIME=time();    #获取系统时间，可两者做差得到运行时间，单位为秒（s）
my $version="1.0.0";

#core Perl modules
use Getopt::Long;
#Carp模块提供了carp(),croak(),confess(),cluck(),shortmess(),longmess()六个函数，
#这些函数产生的错误信息与warn()，die()类似。不同之处在于，后者标识的是出现错误的行号，前者产生调用错误的子程序命令行位置。
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
sub log_current_time {     #获取时间的函数，格式化输出
	my ($info) = @_;    #获取参数（一般为    XXX程序开始执行…………）
	my $curr_time = &date_time_format(localtime(time()));   #格式化获取时间表示方法
	print "[$curr_time] $info\n";    #输出打印
}
##########################################################################################################################
sub date_time_format {
	my ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst)=localtime(time());
	return sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);  #获取格式化的时间信息，不打印（sprintf的用法）
}
########################################################################################################################## 
sub USAGE{   #选项帮助函数
	my $usage=<<"__USAGE__";#从下一行开始，知道碰到__USAGE__为止，所有的东西按统一的格式存入变量中（包括注释），#__USAGE__为结束符号，类似用eof，不会输出也不会输入，仅仅只是作为结束标志
#-----------------------------------------------------------
 Program:$Script
 Version:$version
 Contact:1291016966\@qq.com
    Data:2018-02-24
Function:
   USAGE:
         -in    <STR>   input file [Must]
         -old   <STR>   input old file (may be a new file or inculde header file)
	 -out   <STR>   output file   [Optional]
         -help          show the docment and exit
 Example:
    perl $Script -in file1 -out file2
#---------------------------------------------------------
__USAGE__
   print $usage;  #打印帮助信息
   exit;      #当调用该子程序时表示程序无法正常执行，使用exit函数强行退出该程序
 	} 
