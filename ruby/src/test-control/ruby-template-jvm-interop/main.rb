builder = Java::JavaLang::StringBuilder.new("M8Test")
builder.append(" Ruby")
raise "JVM StringBuilder" unless builder.toString == "M8Test Ruby"
raw = $arrays.intArrayOf(3, 1, 2)
values = $objectWrappers.wrapIntArray(raw)
raise "wrapped size" unless values.getSize == 3
values.set(0, 7)
raise "wrapped array" unless values.contains(7)
callback_called = false
$logger.withContext(lambda { |context| callback_called = !context.nil? })
raise "Kotlin function callback" unless callback_called
items = $iterables.listOf("first", "second")
raise "host List factory" unless items.get(1) == "second"
$logger.info("ruby-template-jvm-interop:passed")
