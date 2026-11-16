local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)

local Set = LuauPolyfill.Set

local Shared = require(parent.Shared)
local enableSchedulerTracing = Shared.ReactFeatureFlags.enableSchedulerTracing

local count = 0
local count2 = 0
local interactionsRef, subscriberRef

if enableSchedulerTracing then
	interactionsRef = { current = Set.new() }

	subscriberRef = { current = nil }
else
	interactionsRef = nil
	subscriberRef = nil
end

local Tracing = {}
Tracing.__interactionsRef = interactionsRef
Tracing.__subscriberRef = subscriberRef

function Tracing.unstable_clear(callback)
	if not enableSchedulerTracing then
		return callback()
	end

	local current = interactionsRef.current
	interactionsRef.current = Set.new()

	local success, result = pcall(callback)

	interactionsRef.current = current

	if not success then
		error(result)
	end

	return result
end

function Tracing.unstable_getCurrent()
	if enableSchedulerTracing then
		return interactionsRef.current
	end

	return nil
end

function Tracing.unstable_getThreadID()
	count2 += 1
	return count2
end

function Tracing.unstable_trace(name: string, timestamp: number, callback, p: number?)
	local v = p == nil and 0 or p

	if not enableSchedulerTracing then
		return callback()
	end

	local v2 = { __count = 1, id = count, name = name, timestamp = timestamp }

	count += 1

	local current = interactionsRef.current

	local current3 = Set.new(current)
	current3:add(v2)
	interactionsRef.current = current3

	local current2 = subscriberRef.current
	local v3 = nil

	local success, result = pcall(function()
		if current2 ~= nil then
			current2.onInteractionTraced(v2)
		end
	end)

	local success2, result2 = pcall(function()
		if current2 ~= nil then
			current2.onWorkStarted(current3, v)
		end
	end)

	local success3, result3 = pcall(function()
		v3 = callback()
	end)

	interactionsRef.current = current

	local success4, result4 = pcall(function()
		if current2 ~= nil then
			current2.onWorkStopped(current3, v)
		end
	end)

	v2.__count -= 1

	if current2 ~= nil and v2.__count == 0 then
		current2.onInteractionScheduledWorkCompleted(v2)
	end

	if not success4 then
		error(result4)
	end

	if not success3 then
		error(result3)
	end

	if not success2 then
		error(result2)
	end

	if not success then
		error(result)
	end

	return v3
end

function Tracing.unstable_wrap(callback, p: number)
	local v = p == nil and 0 or p

	if not enableSchedulerTracing then
		return callback
	end

	local current = interactionsRef.current

	local current2 = subscriberRef.current

	if current2 ~= nil then
		current2.onWorkScheduled(current, v)
	end

	for _, v2 in current do
		v2.__count += 1
	end

	local v2 = false

	local function _wrapped(_, ...)
		local current3 = interactionsRef.current
		interactionsRef.current = current

		current2 = subscriberRef.current

		local success, result = pcall(function(...)
			local v3 = nil

			local success, result = pcall(function()
				if current2 ~= nil then
					current2.onWorkStarted(current, v)
				end
			end)

			local success2, result2 = pcall(function(...)
				v3 = callback(...)
			end, ...)

			interactionsRef.current = current3

			if current2 ~= nil then
				current2.onWorkStopped(current, v)
			end

			if not success2 then
				error(result2)
			end

			if not success then
				error(result)
			end

			return v3
		end, ...)

		if not v2 then
			v2 = true

			for _, v3 in current do
				v3.__count -= 1

				if current2 ~= nil and v3.__count == 0 then
					current2.onInteractionScheduledWorkCompleted(v3)
				end
			end
		end

		if not success then
			error(result)
		end

		return result
	end

	local function fn()
		current2 = subscriberRef.current

		local success, result = pcall(function()
			if current2 ~= nil then
				current2.onWorkCanceled(current, v)
			end
		end)

		for _, v3 in current do
			v3.__count -= 1

			if current2 ~= nil and v3.__count == 0 then
				current2.onInteractionScheduledWorkCompleted(v3)
			end
		end

		if not success then
			error(result)
		end
	end

	local v3 = {}
	setmetatable(v3, { __call = _wrapped })

	v3.cancel = fn

	return v3
end

return Tracing
