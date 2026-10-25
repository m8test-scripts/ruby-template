timer = $script.getThreads().getMain().getTimer()
timer.setImmediate(lambda { |params|
  $logger.info("thread-context:ruby:timer-error")
  raise "expected timer callback failure"
})
