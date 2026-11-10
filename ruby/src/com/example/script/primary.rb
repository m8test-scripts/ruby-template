# encoding: utf-8
require 'com/example/tool/ToolB'
ToolB.new.methodB($logger)
$logger.info("RUBY_PRIMARY_STARTED", "Ruby primary script started")

# 使用 Compose API 创建脚本界面，并验证 Ruby 的回调桥接。
$composeView.create do |slot|
  state = slot.remember { slot.mutableStateOf(0) }
  slot.Column do |column|
    column.setHorizontalAlignment { |alignments| alignments.getCenterHorizontally }
    column.setVerticalArrangement { |arrangements| arrangements.getCenter }
    column.setContent do |columnSlot|
      columnSlot.Text do |text|
        text.setText("#{$stringResources.getString('demo.counter.label')}#{state.getValue()}")
        nil
      end
      columnSlot.TextButton do |button|
        button.setContent do |buttonSlot|
          buttonSlot.Text do |text|
            text.setText($stringResources.getString("demo.counter.button"))
            nil
          end
          nil
        end
        button.setOnClick do
          state.setValue(state.getValue() + 1)
          $logger.info("RUBY_UI_CLICK", "count=#{state.getValue()}")
          nil
        end
        nil
      end
      columnSlot.Text do |text|
        text.setText($stringResources.getString("demo.language"))
        nil
      end
      nil
    end
    nil
  end
  nil
end

$activity.start
