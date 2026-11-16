local parent = script.Parent
local ReactGlobals = require(parent.ReactGlobals)

local Scheduler = require(script.Scheduler)

local function onlyInTestError(p: string) -- 9 equivalent calls inferred from this helper
	return function()
		error(p .. " is only available in tests, not in production")
	end
end

local scheduler = Scheduler(nil)
local Tracing = require(script.Tracing)
local TracingSubscriptions = require(script.TracingSubscriptions)

if ReactGlobals.__ROACT_17_MOCK_SCHEDULER__ then
	return require(script.unstable_mock)
end

local Scheduler2 = {
	unstable_ImmediatePriority = scheduler.unstable_ImmediatePriority,
	unstable_UserBlockingPriority = scheduler.unstable_UserBlockingPriority,
	unstable_NormalPriority = scheduler.unstable_NormalPriority,
	unstable_IdlePriority = scheduler.unstable_IdlePriority,
	unstable_LowPriority = scheduler.unstable_LowPriority,
	unstable_runWithPriority = scheduler.unstable_runWithPriority,
	unstable_next = scheduler.unstable_next,
	unstable_scheduleCallback = scheduler.unstable_scheduleCallback,
	unstable_cancelCallback = scheduler.unstable_cancelCallback,
	unstable_wrapCallback = scheduler.unstable_wrapCallback,
	unstable_getCurrentPriorityLevel = scheduler.unstable_getCurrentPriorityLevel,
	unstable_shouldYield = scheduler.unstable_shouldYield,
	unstable_requestPaint = scheduler.unstable_requestPaint,
	unstable_continueExecution = scheduler.unstable_continueExecution,
	unstable_pauseExecution = scheduler.unstable_pauseExecution,
	unstable_getFirstCallbackNode = scheduler.unstable_getFirstCallbackNode,
	unstable_now = scheduler.unstable_now,
	unstable_forceFrameRate = scheduler.unstable_forceFrameRate,
	unstable_setSchedulerFlags = scheduler.unstable_setSchedulerFlags,
	unstable_getSchedulerFlags = scheduler.unstable_getSchedulerFlags,
	unstable_flushAllWithoutAsserting = onlyInTestError("unstable_flushAllWithoutAsserting"), -- inferred equivalent call
	unstable_flushAll = onlyInTestError("unstable_flushAll"), -- inferred equivalent call
	unstable_flushNumberOfYields = onlyInTestError("unstable_flushNumberOfYields"), -- inferred equivalent call
	unstable_clearYields = onlyInTestError("unstable_clearYields"), -- inferred equivalent call
	unstable_flushUntilNextPaint = onlyInTestError("unstable_clearYields"), -- inferred equivalent call
	unstable_advanceTime = onlyInTestError("unstable_advanceTime"), -- inferred equivalent call
	unstable_flushExpired = onlyInTestError("unstable_flushExpired"), -- inferred equivalent call
	unstable_yieldValue = onlyInTestError("unstable_yieldValue"), -- inferred equivalent call
	tracing = {
		unstable_wrap = onlyInTestError("unstable_wrap"), -- inferred equivalent call
		__interactionsRef = {},
		__subscriberRef = {}
	}
}

for k, v in Tracing do
	Scheduler2.tracing[k] = v
end

for k, tracingSubscription in TracingSubscriptions do
	Scheduler2.tracing[k] = tracingSubscription
end

return Scheduler2
