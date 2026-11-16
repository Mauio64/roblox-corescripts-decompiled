local Tracing = require(script.Parent.Tracing)
local TracingSubscriptions = require(script.Parent.TracingSubscriptions)

local Scheduler = require(script.Parent.Scheduler)
local SchedulerHostConfigmock = require(script.Parent.forks["SchedulerHostConfig.mock"])

local scheduler = Scheduler(SchedulerHostConfigmock)

local UnstableMock = {}
UnstableMock.tracing = {}

for k, v in scheduler do
	UnstableMock[k] = v
end

for k, v in Tracing do
	UnstableMock.tracing[k] = v
end

for k, tracingSubscription in TracingSubscriptions do
	UnstableMock.tracing[k] = tracingSubscription
end

UnstableMock.unstable_flushAllWithoutAsserting = SchedulerHostConfigmock.unstable_flushAllWithoutAsserting
UnstableMock.unstable_flushNumberOfYields = SchedulerHostConfigmock.unstable_flushNumberOfYields
UnstableMock.unstable_flushExpired = SchedulerHostConfigmock.unstable_flushExpired
UnstableMock.unstable_clearYields = SchedulerHostConfigmock.unstable_clearYields
UnstableMock.unstable_flushUntilNextPaint = SchedulerHostConfigmock.unstable_flushUntilNextPaint
UnstableMock.unstable_flushAll = SchedulerHostConfigmock.unstable_flushAll
UnstableMock.unstable_yieldValue = SchedulerHostConfigmock.unstable_yieldValue
UnstableMock.unstable_advanceTime = SchedulerHostConfigmock.unstable_advanceTime
UnstableMock.unstable_Profiling = scheduler.unstable_Profiling

return UnstableMock
