# frozen_string_literal: true

SimpleCov.start 'rails' do
  enable_coverage :branch
  primary_coverage :branch

  add_group 'Admin', 'app/admin'
  add_group 'Decorators', 'app/decorators'
  add_group 'Factories', 'app/factories'
  add_group 'Serializers', 'app/serializers'
  add_group 'Services', 'app/services'
  add_group 'Uploaders', 'app/uploaders'
  add_group 'Validators', 'app/validators'
  add_group 'Workers', 'app/workers'

  # デフォルトだと *.rake が対象に含まれていないため上書き
  # refs: https://github.com/simplecov-ruby/simplecov/blob/v0.22.0/lib/simplecov/profiles/rails.rb#L17
  track_files '{app,lib}/**/*.{rb,rake}'

  # tmpのrakeタスクはテストカバレッジ取得の対象から外す
  # 理由:
  # - 対象から外すことでテストカバレッジがより実態に近くなる
  # - tmpのrakeタスクをテストカバレッジの対象から外すデメリットが軽微
  add_filter '/lib/tasks/tmp/'

  # appやlib にある `test` ディレクトリのカバレッジを計測できるようにフィルタから削除する
  filters.reject! { |f| f.filter_argument == '/test/' }

  if ENV['CODECOV_TOKEN']
    require 'simplecov-cobertura'
    formatter SimpleCov::Formatter::MultiFormatter.new([
                                                         SimpleCov::Formatter::SimpleFormatter,
                                                         SimpleCov::Formatter::HTMLFormatter,
                                                         SimpleCov::Formatter::CoberturaFormatter
                                                       ])
  end
end
