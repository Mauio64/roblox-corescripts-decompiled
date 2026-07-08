local scriptParent = script.Parent
local ReactGlobals = require(scriptParent.ReactGlobals)

local function onlyInTestError(s1: string) -- line: 17
	return function() -- line: 18
		-- upvalues: s1 (copy)
		error(s1 .. " is only available in tests, not in production")
	end
end

local v4 = require(script.Scheduler)(nil)
local Tracing = require(script.Tracing)
local TracingSubscriptions = require(script.TracingSubscriptions)

if ReactGlobals.__ROACT_17_MOCK_SCHEDULER__ then
	return require(script.unstable_mock)
end

local t1 = {
	unstable_ImmediatePriority = v4.unstable_ImmediatePriority,
	unstable_UserBlockingPriority = v4.unstable_UserBlockingPriority,
	unstable_NormalPriority = v4.unstable_NormalPriority,
	unstable_IdlePriority = v4.unstable_IdlePriority,
	unstable_LowPriority = v4.unstable_LowPriority,
	unstable_runWithPriority = v4.unstable_runWithPriority,
	unstable_next = v4.unstable_next,
	unstable_scheduleCallback = v4.unstable_scheduleCallback,
	unstable_cancelCallback = v4.unstable_cancelCallback,
	unstable_wrapCallback = v4.unstable_wrapCallback,
	unstable_getCurrentPriorityLevel = v4.unstable_getCurrentPriorityLevel,
	unstable_shouldYield = v4.unstable_shouldYield,
	unstable_requestPaint = v4.unstable_requestPaint,
	unstable_continueExecution = v4.unstable_continueExecution,
	unstable_pauseExecution = v4.unstable_pauseExecution,
	unstable_getFirstCallbackNode = v4.unstable_getFirstCallbackNode,
	unstable_now = v4.unstable_now,
	unstable_forceFrameRate = v4.unstable_forceFrameRate,
	unstable_setSchedulerFlags = v4.unstable_setSchedulerFlags,
	unstable_getSchedulerFlags = v4.unstable_getSchedulerFlags
}
local s2 = "unstable_flushAllWithoutAsserting"

function t1.unstable_flushAllWithoutAsserting() -- line: 18
	-- upvalues: s2 (copy)
	error(s2 .. " is only available in tests, not in production")
end

local s3 = "unstable_flushAll"

function t1.unstable_flushAll() -- line: 18
	-- upvalues: s3 (copy)
	error(s3 .. " is only available in tests, not in production")
end

local s4 = "unstable_flushNumberOfYields"

function t1.unstable_flushNumberOfYields() -- line: 18
	-- upvalues: s4 (copy)
	error(s4 .. " is only available in tests, not in production")
end

local s5 = "unstable_clearYields"

function t1.unstable_clearYields() -- line: 18
	-- upvalues: s5 (copy)
	error(s5 .. " is only available in tests, not in production")
end

local s6 = "unstable_clearYields"

function t1.unstable_flushUntilNextPaint() -- line: 18
	-- upvalues: s6 (copy)
	error(s6 .. " is only available in tests, not in production")
end

local s7 = "unstable_advanceTime"

function t1.unstable_advanceTime() -- line: 18
	-- upvalues: s7 (copy)
	error(s7 .. " is only available in tests, not in production")
end

local s8 = "unstable_flushExpired"

function t1.unstable_flushExpired() -- line: 18
	-- upvalues: s8 (copy)
	error(s8 .. " is only available in tests, not in production")
end

local s9 = "unstable_yieldValue"

function t1.unstable_yieldValue() -- line: 18
	-- upvalues: s9 (copy)
	error(s9 .. " is only available in tests, not in production")
end

local t2 = {}
local s10 = "unstable_wrap"

function t2.unstable_wrap() -- line: 18
	-- upvalues: s10 (copy)
	error(s10 .. " is only available in tests, not in production")
end

t2.__interactionsRef = {}
t2.__subscriberRef = {}
t1.tracing = t2

for v18, v19 in Tracing do
	t1.tracing[v18] = v19
end

for v20, v21 in TracingSubscriptions do
	t1.tracing[v20] = v21
end

return t1
