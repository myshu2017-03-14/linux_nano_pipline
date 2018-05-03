
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
#my %len;

#open I,"$input_file"||die "can't open the file: $!\n";  
open O,">$output_file"||die "can't open the file: $!\n";
my $seqio = Bio::SeqIO->new( -file => "$input_file", -format => 'fasta' ) or croak "**ERROR: Could not open FASTA file: $!\n";  #���������fasta�ļ�
while(my $sobj = $seqio->next_seq)
{
    my $seqid = $sobj->id;
    #my $seq = $sobj->seq;
		my $seqlen = $sobj->length;
		print O $seqid."\t".$seqlen."\n";
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
Function:
   USAGE:
         -in    <STR>   input file [Must]
         -out   <STR>   output file   [Optional]
         -help          show the docment and exit
 Example:
    perl $Script -in file1 -out file2
#---------------------------------------------------------
__USAGE__
   print $usage;  #��ӡ������Ϣ
   exit;      #�����ø��ӳ���ʱ��ʾ�����޷�����ִ�У�ʹ��exit����ǿ���˳��ó���
 	} 