#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'fileutils'

class MergeRspecResults
  def initialize(input_dir:, output_file:)
    @input_dir = input_dir
    @output_file = output_file
  end

  def merge_files
    file_paths = Dir.glob(File.join(@input_dir, '*.json'))
    return if file_paths.empty?

    merged_data = JSON.parse(File.read(file_paths.shift))

    file_paths.each do |file_path|
      data = JSON.parse(File.read(file_path))
      
      merged_data['examples'] += data['examples']
      merged_data['summary']['duration'] += data['summary']['duration']
      merged_data['summary']['example_count'] += data['summary']['example_count']
      merged_data['summary']['failure_count'] += data['summary']['failure_count']
      merged_data['summary']['pending_count'] += data['summary']['pending_count']
      merged_data['summary']['errors_outside_of_examples_count'] += data['summary']['errors_outside_of_examples_count']
    end

    merged_data['summary_line'] = "#{merged_data['summary']['example_count']} examples, #{merged_data['summary']['failure_count']} failures, #{merged_data['summary']['pending_count']} pending"

    FileUtils.mkdir_p(File.dirname(@output_file))
    File.open(@output_file, 'w') do |file|
      file.write(JSON.pretty_generate(merged_data))
    end

    puts 'Merged JSON files successfully!'
  end
end