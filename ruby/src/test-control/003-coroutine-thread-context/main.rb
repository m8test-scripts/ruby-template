scope = $coroutines.newScope(nil)
timer = $script.getThreads().getMain().getTimer()
scope.launch(lambda { |context|
  context.setName("script-main")
  context.setDispatcher(lambda { |dispatchers| dispatchers.getScriptMain() })
  raise "coroutine context name mismatch" unless context.getName() == "script-main"
}, nil, lambda { |s|
  raise "script-main dispatcher mismatch" unless $script.getThreads().getCurrent().isCurrent()
  $logger.info("coroutine:ruby:script-main-verified")
})
captured_script_value = "ruby-captured"
other_task_progress = false
timer.setTimeout(lambda { |params| other_task_progress = true; $logger.info("coroutine:ruby:other-task-progressed") }, 50)
scope.launch(lambda { |context| context.setDispatcher(lambda { |dispatchers| dispatchers.getIO() }) }, nil, lambda { |s|
  raise "captured script value mismatch" unless captured_script_value == "ruby-captured"
  $logger.info("coroutine:ruby:io-captured-value-verified")
})
scope.delay(200).onSuccess(lambda { |value|
  raise "delayed script value mismatch" unless captured_script_value == "ruby-captured"
  raise "other task did not progress during delay" unless other_task_progress
  $logger.info("coroutine:ruby:delayed-captured-value-verified")
})
scope.launch(nil, nil, lambda { |s| $logger.info("coroutine:ruby:launch") })
scope._async(nil, nil, lambda { |s| $logger.info("coroutine:ruby:async"); 7 }).onSuccess(
  lambda { |value|
    raise "async value mismatch: #{value}" unless value.to_i == 7
    $logger.info("coroutine:ruby:async-success")
  })
scope.withContext(lambda { |context| }, lambda { |s| $logger.info("coroutine:ruby:with-context"); 9 })
$coroutines.getFlows().of(1, 2).map(lambda { |s, value|
  $logger.info("coroutine:ruby:flow:" + value.to_s)
  s.resolve(value * 2)
}).toList(scope).onSuccess(lambda { |values|
  raise "flow mapped values mismatch" unless values.size == 2 && values.get(0).to_i == 2 && values.get(1).to_i == 4
  $logger.info("coroutine:ruby:flow-complete")
})
scope.delay(5000).onComplete(lambda { $logger.info("coroutine:ruby:cancelled-work-complete") })
timer.setTimeout(lambda { |params| $logger.info("coroutine:ruby:gate"); scope.cancel("done") }, 1500)
