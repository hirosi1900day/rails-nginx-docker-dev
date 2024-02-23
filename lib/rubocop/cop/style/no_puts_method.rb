require 'rubocop-rails'

module RuboCop
  module Cop
    module Style
      class NoPutsMethod < RuboCop::Cop::Base
        extend RuboCop::Cop::AutoCorrector

        def_node_search :puts_method?, <<~PATTERN
          (send (send (const nil? :Rails) :logger) :debug ...)
        PATTERN

        MSG = '直接の`Rails.logger.debug`メソッドの使用は避けてください。代わりに`Rollbar.warn`を使用してください。'.freeze
        RESTRICT_ON_SEND = [:Rails, :logger, :debug].freeze


        def on_send(node)
          return unless puts_method?(node)

          add_offense(node, message: MSG) do |corrector|
            # `puts`メソッドの呼び出しを`Rollbar.warn`に置換します。
            # この例では、引数をそのまま`Rollbar.warn`に渡すことを想定しています。
            corrector.replace(node, "Rails.error(#{node.arguments.map(&:source).join(', ')})")
          end
        end
      end
    end
  end
end
