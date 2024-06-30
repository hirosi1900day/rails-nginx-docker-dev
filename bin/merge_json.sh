#!/bin/bash

# ファイル名を引数として受け取る
file1=$1
file2=$2

# JSONデータを読み込み、examples配列を結合し、example_countを計算して新しいJSONを作成
merged_json=$(jq -s '
  . as [$json1, $json2] |
  {
    version: $json1[0].version,
    examples: ($json1[0].examples + $json2[0].examples),
    summary: {
      duration: ($json1[0].summary.duration + $json2[0].summary.duration),
      example_count: ($json1[0].summary.example_count + $json2[0].summary.example_count),
      failure_count: ($json1[0].summary.failure_count + $json2[0].summary.failure_count),
      pending_count: ($json1[0].summary.pending_count + $json2[0].summary.pending_count),
      errors_outside_of_examples_count: ($json1[0].summary.errors_outside_of_examples_count + $json2[0].summary.errors_outside_of_examples_count)
    },
    summary_line: "\((($json1[0].summary.example_count + $json2[0].summary.example_count)) | tostring) examples, 0 failures"
  }
' "$file1" "$file2")

# マージされたJSONを表示または保存
echo "$merged_json"
