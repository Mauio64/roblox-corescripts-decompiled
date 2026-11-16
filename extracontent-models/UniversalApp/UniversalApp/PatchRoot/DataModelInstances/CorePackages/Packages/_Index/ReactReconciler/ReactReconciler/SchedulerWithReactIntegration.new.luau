local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array

require(script.Parent.ReactInternalTypes)

local Scheduler = require(parent.Scheduler)

local Shared = require(parent.Shared)
local ReactFeatureFlags = Shared.ReactFeatureFlags

local decoupleUpdatePriorityFromScheduler = ReactFeatureFlags.decoupleUpdatePriorityFromScheduler
local Shared2 = require(parent.Shared)
local invariant = Shared2.invariant
local Shared3 = require(parent.Shared)
local describeError = Shared3.describeError
local ReactFiberLane = require(script.Parent.ReactFiberLane)
local SyncLanePriority = ReactFiberLane.SyncLanePriority
local getCurrentUpdateLanePriority = ReactFiberLane.getCurrentUpdateLanePriority
local setCurrentUpdateLanePriority = ReactFiberLane.setCurrentUpdateLanePriority

local unstable_runWithPriority = Scheduler.unstable_runWithPriority
local unstable_scheduleCallback = Scheduler.unstable_scheduleCallback
local unstable_cancelCallback = Scheduler.unstable_cancelCallback
local unstable_shouldYield = Scheduler.unstable_shouldYield
local unstable_requestPaint = Scheduler.unstable_requestPaint
local unstable_now = Scheduler.unstable_now
local unstable_getCurrentPriorityLevel = Scheduler.unstable_getCurrentPriorityLevel
local unstable_ImmediatePriority = Scheduler.unstable_ImmediatePriority
local unstable_UserBlockingPriority = Scheduler.unstable_UserBlockingPriority
local unstable_NormalPriority = Scheduler.unstable_NormalPriority
local unstable_LowPriority = Scheduler.unstable_LowPriority
local unstable_IdlePriority = Scheduler.unstable_IdlePriority

local ReactFiberSchedulerPrioritiesroblox = require(script.Parent["ReactFiberSchedulerPriorities.roblox"])
local ImmediatePriority = ReactFiberSchedulerPrioritiesroblox.ImmediatePriority
local UserBlockingPriority = ReactFiberSchedulerPrioritiesroblox.UserBlockingPriority
local NormalPriority = ReactFiberSchedulerPrioritiesroblox.NormalPriority
local LowPriority = ReactFiberSchedulerPrioritiesroblox.LowPriority
local IdlePriority = ReactFiberSchedulerPrioritiesroblox.IdlePriority
local NoPriority = ReactFiberSchedulerPrioritiesroblox.NoPriority

local fn

local v = {}

local fn2 = unstable_requestPaint == nil and function() end or unstable_requestPaint

local v2 = nil
local v3 = nil
local v4 = false
local v5 = unstable_now()

function reactPriorityToSchedulerPriority(p)
	if p == ImmediatePriority then
		return unstable_ImmediatePriority
	end

	if p == UserBlockingPriority then
		return unstable_UserBlockingPriority
	end

	if p == NormalPriority then
		return unstable_NormalPriority
	end

	if p == LowPriority then
		return unstable_LowPriority
	end

	if p == IdlePriority then
		return unstable_IdlePriority
	end

	invariant(false, "Unknown priority level.")

	return nil
end

local function runWithPriority(immediatePriority, fn3) -- 2 equivalent calls inferred from this helper
	return unstable_runWithPriority(reactPriorityToSchedulerPriority(immediatePriority), fn3)
end

local function scheduleSyncCallback(callback)
	if v2 == nil then
		v2 = { callback }

		v3 = unstable_scheduleCallback(unstable_ImmediatePriority, fn)
	else
		table.insert(v2, callback)
	end

	return v
end

local function flushSyncCallbackQueue()
	if v3 ~= nil then
		local v6 = v3
		v3 = nil
		unstable_cancelCallback(v6)
	end

	return fn()
end

fn = function(): boolean
	if v4 or v2 == nil then
		return false
	end

	v4 = true
	local v6 = 1

	if decoupleUpdatePriorityFromScheduler then
		local currentUpdateLanePriority = getCurrentUpdateLanePriority()

		local result = nil
		local success

		if ReactGlobals.__YOLO__ then
			success = true

			local v7 = v2

			setCurrentUpdateLanePriority(SyncLanePriority)

			local function fn3()
				for k, v8 in v7 do
					v6 = k

					repeat
						v8 = v8(true)
					until v8 == nil

					v6 += 1
				end
			end

			runWithPriority(ImmediatePriority, fn3) -- inferred equivalent call
			v2 = nil
		else
			local v7 = v2

			setCurrentUpdateLanePriority(SyncLanePriority)
			success, result = xpcall(runWithPriority, describeError, ImmediatePriority, function()
				for k, v8 in v7 do
					v6 = k

					repeat
						v8 = v8(true)
					until v8 == nil
				end
			end)

			if ReactFeatureFlags.keepSyncQueueOnError then
				if success then
					v2 = nil
				end
			else
				v2 = nil
			end
		end

		setCurrentUpdateLanePriority(currentUpdateLanePriority)
		v4 = false

		if not success then
			if v2 ~= nil then
				v2 = Array.slice(v2, v6 + 1)
			end

			unstable_scheduleCallback(unstable_ImmediatePriority, flushSyncCallbackQueue)

			error(result)
		end
	else
		local result = nil
		local success

		if ReactGlobals.__YOLO__ then
			success = true

			local v7 = v2

			local function fn3()
				for k, v8 in v7 do
					v6 = k

					repeat
						v8 = v8(true)
					until v8 == nil
				end
			end

			runWithPriority(ImmediatePriority, fn3) -- inferred equivalent call
			v2 = nil
		else
			local v7 = v2

			success, result = xpcall(runWithPriority, describeError, ImmediatePriority, function()
				for k, v8 in v7 do
					v6 = k

					repeat
						v8 = v8(true)
					until v8 == nil
				end
			end)

			if ReactFeatureFlags.keepSyncQueueOnError then
				if success then
					v2 = nil
				end
			else
				v2 = nil
			end
		end

		v4 = false

		if not success then
			if v2 ~= nil then
				v2 = Array.slice(v2, v6 + 1)
			end

			unstable_scheduleCallback(unstable_ImmediatePriority, flushSyncCallbackQueue)

			error(result)
		end
	end

	return true
end

local New = {}
New.ImmediatePriority = ImmediatePriority
New.UserBlockingPriority = UserBlockingPriority
New.NormalPriority = NormalPriority
New.LowPriority = LowPriority
New.IdlePriority = IdlePriority
New.NoPriority = NoPriority

function New.getCurrentPriorityLevel()
	local v6 = unstable_getCurrentPriorityLevel()

	if v6 == unstable_ImmediatePriority then
		return ImmediatePriority
	end

	if v6 == unstable_UserBlockingPriority then
		return UserBlockingPriority
	end

	if v6 == unstable_NormalPriority then
		return NormalPriority
	end

	if v6 == unstable_LowPriority then
		return LowPriority
	end

	if v6 == unstable_IdlePriority then
		return IdlePriority
	end

	invariant(false, "Unknown priority level.")

	return NoPriority
end

New.flushSyncCallbackQueue = flushSyncCallbackQueue
New.runWithPriority = runWithPriority

function New.scheduleCallback(p, callback, p2)
	return unstable_scheduleCallback(reactPriorityToSchedulerPriority(p), callback, p2)
end

New.scheduleSyncCallback = scheduleSyncCallback

function New.cancelCallback(p)
	if p ~= v then
		unstable_cancelCallback(p)
	end
end

function New.now()
	return unstable_now() - v5
end

New.requestPaint = fn2
New.shouldYield = unstable_shouldYield
return New
