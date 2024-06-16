#!/usr/bin/env ruby
# frozen_string_literal: true

require 'nokogiri'

# 結合するXMLファイルのパスを配列で指定
xml_files = Dir.glob('rspec_results/rspec-*.xml')

# 最初のファイルをベースとして読み込む
combined_doc = Nokogiri::XML(File.read(xml_files.shift))

# <testsuite> 要素を取得
testsuite = combined_doc.at_xpath('//testsuite')

# 残りのファイルを順次読み込んで結合
xml_files.each do |file|
  doc = Nokogiri::XML(File.read(file))
  # 各ファイルの <testcase> 要素を <testsuite> の中に追加
  doc.xpath('//testcase').each do |testcase|
    testsuite.add_child(testcase)
  end

  # 必要に応じて <testsuite> 属性の更新（例：tests数の更新）
  original_tests = testsuite['tests'].to_i
  additional_tests = doc.at_xpath('//testsuite')['tests'].to_i
  testsuite['tests'] = (original_tests + additional_tests).to_s

  original_failures = testsuite['failures'].to_i
  additional_failures = doc.at_xpath('//testsuite')['failures'].to_i
  testsuite['failures'] = (original_failures + additional_failures).to_s

  original_errors = testsuite['errors'].to_i
  additional_errors = doc.at_xpath('//testsuite')['errors'].to_i
  testsuite['errors'] = (original_errors + additional_errors).to_s

  original_time = testsuite['time'].to_f
  additional_time = doc.at_xpath('//testsuite')['time'].to_f
  testsuite['time'] = (original_time + additional_time).to_s
end

# 結合結果をフォーマットして出力
formatted_xml = Nokogiri::XML::Builder.new do |xml|
  xml.testsuite(name: testsuite['name'], tests: testsuite['tests'], skipped: testsuite['skipped'], failures: testsuite['failures'], errors: testsuite['errors'], time: testsuite['time'], timestamp: testsuite['timestamp'], hostname: testsuite['hostname']) do
    xml.properties do
      combined_doc.xpath('//property').each do |property|
        xml.property(name: property['name'], value: property['value'])
      end
    end
    combined_doc.xpath('//testcase').each do |testcase|
      xml.testcase(classname: testcase['classname'], name: testcase['name'], file: testcase['file'], time: testcase['time'])
    end
  end
end

# フォーマットされたXMLをファイルに書き出す
File.write('tmp/rspec/combined_rspec_results.xml', formatted_xml.to_xml(indent: 2))

puts 'XML files have been successfully combined into tmp/combined_rspec_results.xml'
