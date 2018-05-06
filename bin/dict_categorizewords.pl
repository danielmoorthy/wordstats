#!/usr/bin/perl

use strict;
use Getopt::Long;

$|=1;

# Program configurations
our %config = getConfig();
my $optResult = GetOptions (
	'dictfile=s'	=> \$config{dictfile},
	'minlen=i'	=> \$config{minlen},
	'debug'		=> \$config{debug},
	'help'		=> \$config{help},
);

unless ($optResult) {
	usage();
	exit(1);
}

if ($config{help}) {
	usage();
	exit(0);
}

debugPrint("Current Configurations are .. \n");
foreach my $key (keys (%config)) {
	debugPrint("   $key\t=>\t$config{$key}\n");
}

my (@wordList, @topWordList);
my (%wordDict);
my ($startTime, $endTime, $prepareTime, $processTime, $topWordCount);

##############################
# Step 1: Load the dict file #
##############################
debugPrint("Step 1: Opening Dict file [$config{dictfile}] .. \n");
$startTime = time();
open (my $inFH, $config{dictfile}) or die "ERROR: File open error. Reason: $!";
while(<$inFH>) {
	my $buf = $_;
	chomp($buf); $buf =~ s/\r//g;
	next if (!$buf);

	# Extract all word groups from the input buffer
	my @_wordList = $buf =~ /([a-zA-Z]+)/g;
	push (@wordList, @_wordList);
}
close ($inFH);
$endTime = time();
$prepareTime = $endTime - $startTime;
debugPrint("Step 1: Done reading dict file $config{dictfile}\n");

#########################################################
# Step 2: Get all unique sequential word from word list #
#########################################################
debugPrint("Step 2: Start processing the dict file contents .. \n");
$startTime = time();
foreach my $matchWord (@wordList) {
	for (my $matchLen = $config{minlen}; $matchLen <= length($matchWord); 
		$matchLen++) {
		next if (length($matchWord) < $matchLen);
		my @parts = getWordParts($matchWord, $matchLen);
		debugPrint("Word [$matchWord] has " . scalar(@parts) . 
			" sequential words when sliced by $matchLen chars\n");
		map {
			$wordDict{$_}++;
		} (@parts);
	}
}
$endTime = time();
$processTime = $endTime - $startTime;
debugPrint("Step 2: Done processing the dict file contents\n");

#############################
# Step 3: Find Median count #
#############################
#  * Get all unique counts to find median
my %_tmpHash = ();
@_tmpHash{values(%wordDict)} = ();
my @matchCountList = sort( { $b <=> $a } keys (%_tmpHash));
$topWordCount = $matchCountList[0];

my ($medianCount, $matchCount);
# * If Odd number of matchCountList, then the center element is mean value
# * If Even number of matchCountList, then average of center 2 elements is
#   mean value
$matchCount = scalar(@matchCountList);
if ($matchCount % 2) {
	$medianCount    = $matchCountList[int($matchCount/2)];
} else {
	$medianCount    = ($matchCountList[int($matchCount/2)] + 
				$matchCountList[int(($matchCount - 1)/2)]) / 2;
}
debugPrint("Step 3: Done calculating the median count\n");

#############################################
# Step 4: Now it is time to display results #
#############################################
# * Display Summary
print "
Summary
-------
    Input File name         : $config{dictfile}
    Minimum word slice size : $config{minlen}
    Total Words processed   : " . scalar(@wordList) . "
    Time taken to process   : " . $processTime . " secs
    Total Unique Seq. words : " . scalar(keys(%wordDict)) . "
    Median word count is    : $medianCount

";

# * Display All Word Counts above median count value
print "Word Count\n----------\n";
foreach my $word (sort( { length($b) <=> length($a) } keys(%wordDict))) {
	my $wordCount = $wordDict{$word};
	next if ($wordCount < $medianCount);
	print "    $word      =>  $wordCount\n";
	push (@topWordList, $word) if ($wordCount == $topWordCount);
}
print "\n";

# * Display Top Word Count
print "Top Word Count\n--------------\n";
foreach my $topWord (sort(@topWordList)) {
	my $topWordCount = $wordDict{$topWord};
	print "    $topWord      =>  $topWordCount\n";
}
print "\n";

sub usage {
	my %cnf = getConfig();
	print "\n";
	print "Usage: $0 --dictfile <file> --minlen <number> --debug\n";
	print "  --dictfile   :  Specific the dict file path. Default = " .  
		$cnf{dictfile} . "\n";
	print "  --minlen     :  Minimum word slice size. Default = " .  
		$cnf{minlen} . "\n";
	print "  --debug      :  Show debug messages. Default=0\n";
	print "\n";

	return;
}

sub debugPrint {
	print STDERR "DEBUG: ", @_ if ($config{debug});
}

# Given a string and length, slice the string with equal length and return all
# string parts
sub getWordParts {
	my ($word, $partLen) = @_;

	my @parts = map {
		substr($word, $_, $partLen);
	} (0 .. length($word)-$partLen);

	return @parts;
}

# This function should eventually get the configuration from a file
# I am hardcoding for just this exercise
sub getConfig {
	my %config = (
		dictfile  => "/usr/share/dict/words",
		minlen    => 2,
		debug     => 0,
	);

	return %config;
}

__END__
