local Tracing = require(script.Parent.Tracing)
local TracingSubscriptions = require(script.Parent.TracingSubscriptions)
local Scheduler = require(script.Parent.Scheduler)
local lib = require(script.Parent.forks["SchedulerHostConfig.mock"])
local v5 = Scheduler(lib)
local t1 = {
	tracing = {}
}

for v7, v8 in v5 do
	t1[v7] = v8
end

for v9, v10 in Tracing do
	t1.tracing[v9] = v10
end

for v11, v12 in TracingSubscriptions do
	t1.tracing[v11] = v12
end

t1.unstable_flushAllWithoutAsserting = lib.unstable_flushAllWithoutAsserting
t1.unstable_flushNumberOfYields = lib.unstable_flushNumberOfYields
t1.unstable_flushExpired = lib.unstable_flushExpired
t1.unstable_clearYields = lib.unstable_clearYields
t1.unstable_flushUntilNextPaint = lib.unstable_flushUntilNextPaint
t1.unstable_flushAll = lib.unstable_flushAll
t1.unstable_yieldValue = lib.unstable_yieldValue
t1.unstable_advanceTime = lib.unstable_advanceTime
t1.unstable_Profiling = v5.unstable_Profiling

return t1
