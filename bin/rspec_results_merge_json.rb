#!/usr/bin/env ruby
# frozen_string_literal: true

# libディレクトリをロードパスに追加
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

# クラスを読み込み
require 'merge_rspec_results'
require 'optparse'


# デフォルトの値を設定
options = {
  input_dir: 'report',
  output_file: 'tmp/rspec/merged_rspec_results.json'
}

# オプションパーサーを定義
OptionParser.new do |opts|
  opts.banner = "Usage: rspec_results_merge_json.rb [options]"

  opts.on("--input_dir DIR", "The input directory containing the report files") do |dir|
    options[:input_dir] = dir
  end

  opts.on("--output_file FILE", "The output file to be generated") do |file|
    options[:output_file] = file
  end
end.parse!

# オプションを使用してMergeRspecResultsインスタンスを作成し、マージを実行
merger = MergeRspecResults.new(input_dir: options[:input_dir], output_file: options[:output_file])
merger.merge_files