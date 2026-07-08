local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local Array = require(ParentParent.LuauPolyfill).Array

require(script.Parent.ReactInternalTypes)

local Scheduler = require(ParentParent.Scheduler)
local decoupleUpdatePriorityFromScheduler = require(ParentParent.Shared).ReactFeatureFlags.decoupleUpdatePriorityFromScheduler
local invariant = require(ParentParent.Shared).invariant
local describeError = require(ParentParent.Shared).describeError
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
local lib = require(script.Parent["ReactFiberSchedulerPriorities.roblox"])
local ImmediatePriority = lib.ImmediatePriority
local UserBlockingPriority = lib.UserBlockingPriority
local NormalPriority = lib.NormalPriority
local LowPriority = lib.LowPriority
local IdlePriority = lib.IdlePriority
local NoPriority = lib.NoPriority
local u31 = nil
local t1 = {}
local v33 = unstable_requestPaint == nil and function() -- line: 94
end or unstable_requestPaint
local u34 = nil
local u35 = nil
local u36 = false
local v37 = unstable_now()

function reactPriorityToSchedulerPriority(p1) -- line: 141
	-- upvalues: ImmediatePriority (copy), unstable_ImmediatePriority (copy), UserBlockingPriority (copy), unstable_UserBlockingPriority (copy), NormalPriority (copy), unstable_NormalPriority (copy), LowPriority (copy), unstable_LowPriority (copy), IdlePriority (copy), unstable_IdlePriority (copy), invariant (copy)
	if p1 == ImmediatePriority then
		return unstable_ImmediatePriority
	end

	if p1 == UserBlockingPriority then
		return unstable_UserBlockingPriority
	end

	if p1 == NormalPriority then
		return unstable_NormalPriority
	end

	if p1 == LowPriority then
		return unstable_LowPriority
	end

	if p1 == IdlePriority then
		return unstable_IdlePriority
	end

	invariant(false, "Unknown priority level.")

	return nil
end

local function runWithPriority(p2, p3: ((...any) -> ...any)) -- line: 160
	-- upvalues: unstable_runWithPriority (copy)
	local v44 = reactPriorityToSchedulerPriority(p2)

	return unstable_runWithPriority(v44, p3)
end
local function flushSyncCallbackQueue() -- line: 202
	-- upvalues: u35 (ref), unstable_cancelCallback (copy), u31 (ref)
	if u35 ~= nil then
		local v51 = u35

		u35 = nil
		unstable_cancelCallback(v51)
	end

	return u31()
end

function u31() -- line: 211
	-- upvalues: u36 (ref), u34 (ref), decoupleUpdatePriorityFromScheduler (copy), getCurrentUpdateLanePriority (copy), ReactGlobals (copy), setCurrentUpdateLanePriority (copy), SyncLanePriority (copy), runWithPriority (copy), describeError (copy), ImmediatePriority (copy), unstable_runWithPriority (copy), Array (copy), unstable_scheduleCallback (copy), unstable_ImmediatePriority (copy), flushSyncCallbackQueue (copy)
	if not u36 and u34 ~= nil then
		u36 = true

		local n1 = 1

		if decoupleUpdatePriorityFromScheduler then
			local v53 = getCurrentUpdateLanePriority()
			local result = nil
			local ok

			if not ReactGlobals.__YOLO__ then
				local v55 = u34

				setCurrentUpdateLanePriority(SyncLanePriority)
				ok, result = xpcall(runWithPriority, describeError, ImmediatePriority, function() -- line: 232
					-- upvalues: v55 (copy), n1 (ref)
					for v66, v67 in v55 do
						local v68 = v67

						n1 = v66

						repeat
							v68 = v68(true)
						until v68 == nil
					end
				end)
				u34 = nil
			else
				ok = true

				local v57 = u34

				setCurrentUpdateLanePriority(SyncLanePriority)

				local v58 = ImmediatePriority
				local v59 = reactPriorityToSchedulerPriority(v58)

				unstable_runWithPriority(v59, function() -- line: 250
					-- upvalues: v57 (copy), n1 (ref)
					for v69, v70 in v57 do
						local v71 = v70

						n1 = v69

						repeat
							v71 = v71(true)
						until v71 == nil

						n1 += 1
					end
				end)
				u34 = nil
			end

			setCurrentUpdateLanePriority(v53)
			u36 = false

			if not ok then
				if u34 ~= nil then
					u34 = Array.slice(u34, n1 + 1)
				end

				unstable_scheduleCallback(unstable_ImmediatePriority, flushSyncCallbackQueue)
				error(result)
			end
		else
			local result = nil
			local ok

			if not ReactGlobals.__YOLO__ then
				local v61 = u34

				ok, result = xpcall(runWithPriority, describeError, ImmediatePriority, function() -- line: 292
					-- upvalues: v61 (copy), n1 (ref)
					for v72, v73 in v61 do
						local v74 = v73

						n1 = v72

						repeat
							v74 = v74(true)
						until v74 == nil
					end
				end)
				u34 = nil
			else
				ok = true

				local v63 = u34
				local v64 = ImmediatePriority
				local v65 = reactPriorityToSchedulerPriority(v64)

				unstable_runWithPriority(v65, function() -- line: 308
					-- upvalues: v63 (copy), n1 (ref)
					for v75, v76 in v63 do
						local v77 = v76

						n1 = v75

						repeat
							v77 = v77(true)
						until v77 == nil
					end
				end)
				u34 = nil
			end

			u36 = false

			if not ok then
				if u34 ~= nil then
					u34 = Array.slice(u34, n1 + 1)
				end

				unstable_scheduleCallback(unstable_ImmediatePriority, flushSyncCallbackQueue)
				error(result)
			end
		end

		return true
	end

	return false
end

return {
	ImmediatePriority = ImmediatePriority,
	UserBlockingPriority = UserBlockingPriority,
	NormalPriority = NormalPriority,
	LowPriority = LowPriority,
	IdlePriority = IdlePriority,
	NoPriority = NoPriority,
	getCurrentPriorityLevel = function() -- line: 122
		-- upvalues: unstable_getCurrentPriorityLevel (copy), unstable_ImmediatePriority (copy), ImmediatePriority (copy), unstable_UserBlockingPriority (copy), UserBlockingPriority (copy), unstable_NormalPriority (copy), NormalPriority (copy), unstable_LowPriority (copy), LowPriority (copy), unstable_IdlePriority (copy), IdlePriority (copy), invariant (copy), NoPriority (copy)
		local v40 = unstable_getCurrentPriorityLevel()

		if v40 == unstable_ImmediatePriority then
			return ImmediatePriority
		end

		if v40 == unstable_UserBlockingPriority then
			return UserBlockingPriority
		end

		if v40 == unstable_NormalPriority then
			return NormalPriority
		end

		if v40 == unstable_LowPriority then
			return LowPriority
		end

		if v40 == unstable_IdlePriority then
			return IdlePriority
		end

		invariant(false, "Unknown priority level.")

		return NoPriority
	end,
	flushSyncCallbackQueue = flushSyncCallbackQueue,
	runWithPriority = runWithPriority,
	scheduleCallback = function(p4, p5: ((...any) -> ...any), t2: {[any]: any}?) -- line: 168
		-- upvalues: unstable_scheduleCallback (copy)
		local v48 = reactPriorityToSchedulerPriority(p4)

		return unstable_scheduleCallback(v48, p5, t2)
	end,
	scheduleSyncCallback = function(p6: ((...any) -> ...any)) -- line: 177
		-- upvalues: u34 (ref), u35 (ref), unstable_scheduleCallback (copy), unstable_ImmediatePriority (copy), u31 (ref), t1 (copy)
		if u34 == nil then
			u34 = { p6 }
			u35 = unstable_scheduleCallback(unstable_ImmediatePriority, u31)
		else
			table.insert(u34, p6)
		end

		return t1
	end,
	cancelCallback = function(p7) -- line: 196
		-- upvalues: t1 (copy), unstable_cancelCallback (copy)
		if p7 ~= t1 then
			unstable_cancelCallback(p7)
		end
	end,
	now = function() -- line: 118
		-- upvalues: unstable_now (copy), v37 (copy)
		return unstable_now() - v37
	end,
	requestPaint = v33,
	shouldYield = unstable_shouldYield
}
