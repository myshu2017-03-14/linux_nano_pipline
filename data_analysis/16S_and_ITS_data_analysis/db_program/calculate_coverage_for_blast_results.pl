
use strict;
use warnings;
use Cwd qw(abs_path);      #��ȡ����·��������ǰĿ�����ڵ�·��������������Ķ�����
use Getopt::Long;          #��ȡѡ��
use Data::Dumper;          #�ɴ�ӡ���õĶ�����eg��print Dumper(\%hash \@array);
use FindBin qw($Bin $Script);  #$Bin  ���ýű���binĿ¼��·����$Script  �ű�����  $RealBin ���ýű��ľ���·��  $RealScript  ��ű���صĽű����ò��ţ�
use File::Basename qw(basename dirname);  #basename������ȡ�ļ���  dirname������ȡ·��  fileparse������ȡ��չ��
use List::Util qw/sum max min maxstr minstr/; #�����������ͣ������ֵ��Сֵ
my $BEGIN_TIME=time();    #��ȡϵͳʱ�䣬����������õ�����ʱ�䣬��λΪ�루s��
my $version="1.0.0";

#core Perl modules
use Getopt::Long;
#Carpģ���ṩ��carp(),croak(),confess(),cluck(),shortmess(),longmess()����������
#��Щ���������Ĵ�����Ϣ��warn()��die()���ơ���֮ͬ�����ڣ����߱�ʶ���ǳ��ִ�����кţ�ǰ�߲������ô�����ӳ���������λ�á�
use Carp;  

#CPAN modules
use Bio::SeqIO;
use Bio::Perl;

#---------------------------------------------------------------------------
#GetOptions
#---------------------------------------------------------------------------
my($input_file,$output_file,$length_file);  #ѡ���hash��
GetOptions(
  "in=s"  => \$input_file,     #�����ļ�
  "len=s" => \$length_file,
  "out=s" => \$output_file,    #����ļ�
  "help|?"=> \&USAGE,
 ) or &USAGE;
&USAGE unless (defined $input_file and $output_file);  #�ж�ѡ��ĺϷ���
&log_current_time("\n$output_file\n$Script start����");    #����ʱ�亯��

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
    Data:2017-09-22
Function: �ڱȶԵ����һ������coverage��ֵ�Լ����г��ȣ�coverage= 100*((q.end-q.start)/q.len)
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
   print $usage;  #��ӡ������Ϣ
   exit;      #�����ø��ӳ���ʱ��ʾ�����޷�����ִ�У�ʹ��exit����ǿ���˳��ó���
 	} 
