scope = $coroutines.newScope(nil)
timer = $script.getThreads().getMain().getTimer()
captured = "ruby-nested"
other_task_progress = [false]
timer.setTimeout(lambda { |params| other_task_progress[0] = true; $logger.info("nest:ruby:other-task-progressed") }, 50)
scope.launch(lambda { |context| context.setDispatcher(lambda { |dispatchers| dispatchers.getIO() }) }, nil, lambda { |outer|
  raise "outer capture unavailable" unless captured == "ruby-nested"
  $logger.info("nest:ruby:outer-started")
  scope.launch(lambda { |context| context.setDispatcher(lambda { |dispatchers| dispatchers.getScriptMain() }) }, nil, lambda { |inner|
    raise "nested capture unavailable" unless captured == "ruby-nested"
    $logger.info("nest:ruby:inner-callback")
  })
  raise "outer capture not restored" unless captured == "ruby-nested"
  $logger.info("nest:ruby:outer-resumed")
})
scope.delay(200).onSuccess(lambda { |value|
  raise "delay state mismatch" unless other_task_progress[0] && captured == "ruby-nested"
  $logger.info("nest:ruby:delay-resumed")
})
timer.setTimeout(lambda { |params| $logger.info("nest:ruby:gate"); scope.cancel("done") }, 1500)
