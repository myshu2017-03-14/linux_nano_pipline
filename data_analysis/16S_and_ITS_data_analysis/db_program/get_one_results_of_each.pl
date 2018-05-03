
use strict;
use warnings;
use Cwd qw(abs_path);      #获取工作路径，即当前目标所在的路径（函数括号里的东西）
use Getopt::Long;          #获取选项
use Data::Dumper;          #可打印引用的东西。eg：print Dumper(\%hash \@array);
use FindBin qw($Bin $Script);  #$Bin  调用脚本的bin目录的路径，$Script  脚本名称  $RealBin 调用脚本的绝对路径  $RealScript  与脚本相关的脚本（用不着）
use File::Basename qw(basename dirname);  #basename函数获取文件名  dirname函数获取路径  fileparse函数获取扩展名
my $BEGIN_TIME=time();    #获取系统时间，可两者做差得到运行时间，单位为秒（s）
my $version="1.0.0";

#---------------------------------------------------------------------------
#GetOptions
#---------------------------------------------------------------------------
my($input_file,$output_file);  #选项的hash表
GetOptions(
  "in=s"  => \$input_file,     #输入文件
  "out=s" => \$output_file,    #输出文件
  "help|?"=> \&USAGE,
 ) or &USAGE;
&USAGE unless (defined $input_file and $output_file);  #判断选项的合法性
&log_current_time("\n$output_file\n$Script start……");    #调用时间函数

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
    Data:2015-12-08
Function:get SP annotations of best hits
   USAGE:
         -in    <STR>   input file [Must]
         -out   <STR>   output file   [Optional]
         -help          show the docment and exit
 Example:
    perl $Script -in file1 -out file2
#---------------------------------------------------------
__USAGE__
   print $usage;  #打印帮助信息
   exit;      #当调用该子程序时表示程序无法正常执行，使用exit函数强行退出该程序
 	} 
