a=$coroutines.newScope(nil); b=$coroutines.newScope(nil); c=$coroutines.newScope(nil); d=$coroutines.newScope(nil); e=$coroutines.newScope(nil)
timer=$script.getThreads().getMain().getTimer()
a.withTimeout(75,lambda{|s|s.delay(1000)}).catchError(lambda{|s,err|s.resolve("fallback")}).onError(lambda{|err|$logger.info("coroutine:ruby:timeout-cancellation-preserved")})
b.withTimeoutOrNull(75,lambda{|s|s.delay(1000)}).onSuccess(lambda{|v|raise "expected nil" unless v.nil?;$logger.info("coroutine:ruby:timeout-or-null-ok")}).onError(lambda{|err|raise "timeoutOrNull failed: #{err}"}).onComplete(lambda{$logger.info("coroutine:ruby:timeout-or-null-complete")})
timed=[0]
c.loopWithTimeout(75,lambda{|s|timed[0]+=1;s.delay(1000).then(lambda{|inner,v|inner.resolve(true)})}).onError(lambda{|err|raise "timed loop count" unless timed[0]==1;$logger.info("coroutine:ruby:loop-timeout-cancelled-wait")})
count=[0]
d.loop(lambda{|s|count[0]+=1;$logger.info("coroutine:ruby:loop-iteration:"+count[0].to_s);s.resolve(count[0]<3)}).onComplete(lambda{raise "loop count" unless count[0]==3;$logger.info("coroutine:ruby:loop-completed-count:3")})
e.withTimeoutOrNull(500,lambda{|s|s.delay(25).then(lambda{|inner,v|inner.resolve(23)})}).onSuccess(lambda{|v|raise "composed value" if v.nil?||v.to_i!=23;$logger.info("coroutine:ruby:composed-wait-ok")}).onError(lambda{|err|raise "composed failed: #{err}"}).onComplete(lambda{$logger.info("coroutine:ruby:composed-wait-complete")})
timer.setTimeout(lambda{|p|a.cancel("done");$logger.info("coroutine:ruby:cancellation-gate")},3000)
