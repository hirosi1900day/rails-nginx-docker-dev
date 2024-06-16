#!/usr/bin/env ruby
# frozen_string_literal: true

# libディレクトリをロードパスに追加
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

# クラスを読み込み
require 'merge_rspec_results'

input_dir = ARGV[0] || 'report'
output_file = ARGV[1] || 'tmp/rspec/merged_rspec_results.json'
merger = MergeRspecResults.new(input_dir:, output_file:)
merger.merge_files