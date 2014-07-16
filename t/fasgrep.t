use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 11;
use Test::Script::Run;

my $test_file = 't/data/fasgrep_test.fas';
my $test_file2 = 't/data/fasgrep_test2.fas';

open( my $test1, "<", $test_file ) || die "Can't open $test_file"; 
my @output = <$test1>;
chomp(@output);
close($test1);

open( my $test2, "<", $test_file2 ) || die "Can't open $test_file2";
my @file2 = <$test2>;
chomp(@file2);
close($test2);

my @default_test = @output[-30..-1];
my @sequence_test = @output[-10..-1];
my @field_test = @output[-30..-1];
my @negate_test = @output[0..11];
my @piupac_test = @output[4..21, 32..42];
my @split_test = @output[-30..-1];

run_not_ok('fasgrep', [], 'No input test');

run_output_matches('fasgrep', ['-s', 'TSTTTERAM', $test_file],
		   \@sequence_test, [], 'Checking sequence option');

run_output_matches('fasgrep', ['dbj', $test_file],
		   \@default_test, [], 'Checking default options');

my @temp = @field_test;
run_output_matches('fasgrep', ['-f2', 'Lolium', $test_file],
		   \@field_test, [], 'Checking field options');

@field_test = @temp;
run_output_matches('fasgrep', ['-if2', 'lolium', $test_file],
		   \@temp, [], 'Checking case-insensitivity options');

run_output_matches('fasgrep', ['-if2', 'lolium', $test_file],
		   \@field_test, [], 'Checking case-insensitivity options');

run_output_matches('fasgrep', ['-vif2', 'lolium', $test_file],
		   \@negate_test, [], 'Checking negate options');

@temp = @file2;
run_output_matches('fasgrep', ['-e', 'RYKKMWWWSBDHV', $test_file2],
		   \@temp, [], 'Checking nucleotide iupac options');

run_output_matches('fasgrep', ['-p', 'ZB', $test_file],
		   \@piupac_test, [], 'Checking protein iupac options');

run_output_matches('fasgrep', ['-r', 'AWATCSAT', $test_file2],
		   \@file2, [], 'Checking reverse complement iupac options');

run_output_matches('fasgrep', ['-S', 'i', '-f', '2', 'um r', $test_file],
		   \@split_test, [], 'Checking split options');
