#!/usr/bin/perl -w

use strict;
use File::Basename;

my $target = "/BiO3/shoot/Projects/NGS_Genome/g16.NCC-LiverCancer/ori/TG*/Rawdata/*.gz";
my $prefix = "NCC_LiverCancer";
#my $pattern = qq(Liv\\d+);
my $pattern = "(TG[D\\d]+)";

my $des_dir = "/home/hmkim87/SRA_Upload/$prefix";
if (!-d $des_dir){
	system("mkdir -p $des_dir") and die;
}

my $md5sum_fn = $des_dir."/md5sum.txt";

my @files = glob($target);

for (my $i=0; $i<@files; $i++){
	my $file = $files[$i];
	if ($file !~ /TG1104D0028/ and $file !~ /TG1104D0029/ and $file !~ /TG1104D003/){
		next;
	}

	my ($filename,$dir,$ext) = fileparse($file, qr/\.[^.]*/);

	my $targetFolder = $dir;
	if ($targetFolder =~ $pattern){
		my $key = $1;
		$targetFolder = $des_dir."/$key";
		if (!-d $targetFolder){
			system("mkdir -p $targetFolder");
		}
		my $targetFile = $targetFolder."/".$key.".".$filename.$ext;
		print "ln -s $file $targetFile\n";
		md5sum($targetFile, $md5sum_fn);
	}else{
		die "ERROR! No exist pattern <$pattern>\n";
	}
}

sub md5sum{
	my $open_file = $_[0];
	my $result_file = $_[1];

	print "md5sum $open_file >> $result_file\n";
}
