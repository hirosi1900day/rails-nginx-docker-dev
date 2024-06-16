#!/usr/bin/env ruby
# frozen_string_literal: true

if $PROGRAM_NAME == __FILE__
  input_dir = ARGV[0] || 'report'
  output_file = ARGV[1] || 'tmp/rspec/merged_rspec_results.json'
  merger = JSONMerger.new(input_dir: input_dir, output_file: output_file)
  merger.merge_files
end