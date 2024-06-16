#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

# マージするファイルのパスを取得
file_paths = Dir.glob('report/*.json')

# 最初のファイルを読み込む
merged_data = JSON.parse(File.read(file_paths.shift))

# 残りのファイルを順次マージ
file_paths.each do |file_path|
  data = JSON.parse(File.read(file_path))
  
  merged_data['examples'] += data['examples']
  merged_data['summary']['duration'] += data['summary']['duration']
  merged_data['summary']['example_count'] += data['summary']['example_count']
  merged_data['summary']['failure_count'] += data['summary']['failure_count']
  merged_data['summary']['pending_count'] += data['summary']['pending_count']
  merged_data['summary']['errors_outside_of_examples_count'] += data['summary']['errors_outside_of_examples_count']
end

# summary_line を更新
merged_data['summary_line'] = "#{merged_data['summary']['example_count']} examples, #{merged_data['summary']['failure_count']} failures"

# マージ結果をファイルに保存
File.open('tmp/rspec/merged_rspec_results.json', 'w') do |file|
  file.write(JSON.pretty_generate(merged_data))
end

puts 'Merged JSON files successfully!'