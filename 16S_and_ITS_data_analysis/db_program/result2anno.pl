
use strict;
use warnings;
use Cwd qw(abs_path);      #��ȡ����·��������ǰĿ�����ڵ�·��������������Ķ�����
use Getopt::Long;          #��ȡѡ��
use Data::Dumper;          #�ɴ�ӡ���õĶ�����eg��print Dumper(\%hash \@array);
use FindBin qw($Bin $Script);  #$Bin  ���ýű���binĿ¼��·����$Script  �ű�����  $RealBin ���ýű��ľ���·��  $RealScript  ��ű���صĽű����ò��ţ�
use File::Basename qw(basename dirname);  #basename������ȡ�ļ���  dirname������ȡ·��  fileparse������ȡ��չ��
my $BEGIN_TIME=time();    #��ȡϵͳʱ�䣬����������õ�����ʱ�䣬��λΪ�루s��
my $version="1.0.0";

#---------------------------------------------------------------------------
#GetOptions
#---------------------------------------------------------------------------
my($input_file,$output_file,$tab_file);  #ѡ���hash��
GetOptions(
  "in=s"  => \$input_file,     #�����ļ�
  "tab=s" => \$tab_file,
  "out=s" => \$output_file,    #����ļ�
  "help|?"=> \&USAGE,
 ) or &USAGE;
&USAGE unless (defined $input_file and $output_file);  #�ж�ѡ��ĺϷ���
&log_current_time("\n$output_file\n$Script start����");    #����ʱ�亯��

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
&log_current_time("\n$output_file\n$Script end����");    #����ʱ�亯��
my $run_time=time()-$BEGIN_TIME;
print "$Script run time :$run_time\.s\n";


#----------------------------------------------------------------------------------
#function 
#----------------------------------------------------------------------------------
sub log_current_time {     #��ȡʱ��ĺ�������ʽ�����
	my ($info) = @_;    #��ȡ������һ��Ϊ    XXX����ʼִ�С���������
	my $curr_time = &date_time_format(localtime(time()));   #��ʽ����ȡʱ���ʾ����
	print "[$curr_time] $info\n";    #�����ӡ
}
##########################################################################################################################
sub date_time_format {
	my ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst)=localtime(time());
	return sprintf("%4d-%02d-%02d %02d:%02d:%02d", $year+1900, $mon+1, $day, $hour, $min, $sec);  #��ȡ��ʽ����ʱ����Ϣ������ӡ��sprintf���÷���
}
########################################################################################################################## 
sub USAGE{   #ѡ���������
	my $usage=<<"__USAGE__";#����һ�п�ʼ��֪������__USAGE__Ϊֹ�����еĶ�����ͳһ�ĸ�ʽ��������У�����ע�ͣ���#__USAGE__Ϊ�������ţ�������eof���������Ҳ�������룬����ֻ����Ϊ������־
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
   print $usage;  #��ӡ������Ϣ
   exit;      #�����ø��ӳ���ʱ��ʾ�����޷�����ִ�У�ʹ��exit����ǿ���˳��ó���
}
