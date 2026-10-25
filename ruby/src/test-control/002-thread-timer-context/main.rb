timer = $script.getThreads().getMain().getTimer()
timeout_args = [false]
immediate_done = [false]
worker = [false]
timer.setImmediate(lambda { |params| immediate_done[0] = true; $logger.info("thread-context:ruby:immediate") })
timer.setTimeout(lambda { |params|
  raise "timeout arguments mismatch" unless params.length == 2 && params[0] == "payload" && params[1].nil?
  timeout_args[0] = true
  $logger.info("thread-context:ruby:timeout")
}, 100, "payload", nil)
cancelled_timeout = timer.setTimeout(lambda { |params| raise "cleared timeout ran" }, 1000)
timer.clearTimeout(cancelled_timeout)
cancelled_immediate = timer.setImmediate(lambda { |params| raise "cleared immediate ran" })
timer.clearImmediate(cancelled_immediate)
count = [0]
interval = [0]
interval[0] = timer.setInterval(lambda { |params|
  raise "interval arguments mismatch" unless params.length == 1 && params[0] == "tick"
  count[0] += 1
  if count[0] == 2
    timer.clearInterval(interval[0])
    $logger.info("thread-context:ruby:interval")
  end
}, 75, "tick")
$script.getThreads().onStart(lambda { |thread|
  raise "thread start context mismatch" unless thread.isCurrent() && !thread.isMain() && thread.isAlive() && !thread.isInterrupted() && thread.getName().to_s == "thread-context-worker"
  $logger.info("thread-context:ruby:thread-start")
})
$script.getThreads().onExit(lambda { |thread|
  raise "thread exit context mismatch" unless thread.isCurrent() && !thread.isMain() && thread.isAlive() && !thread.isInterrupted() && thread.getName().to_s == "thread-context-worker"
  $logger.info("thread-context:ruby:thread-exit")
})
$script.getThreads().start("thread-context-worker", lambda { |thread| worker[0] = true; $logger.info("thread-context:ruby:thread") })
timer.setTimeout(lambda { |params|
  raise "timer callback state mismatch" unless timeout_args[0] && immediate_done[0] && worker[0] && count[0] == 2
  $logger.info("thread-context:ruby:verified")
}, 500)
