#!/usr/bin/env ruby
# frozen_string_literal: true

require 'merge_rspec_results'

if $PROGRAM_NAME == __FILE__
  input_dir = ARGV[0] || 'report'
  output_file = ARGV[1] || 'tmp/rspec/merged_rspec_results.json'
  merger = MergeRspecResults.new(input_dir:, output_file:)
  merger.merge_files
end