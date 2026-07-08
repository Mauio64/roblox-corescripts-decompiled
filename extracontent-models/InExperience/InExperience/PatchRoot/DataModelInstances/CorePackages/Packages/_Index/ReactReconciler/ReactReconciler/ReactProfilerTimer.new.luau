local ParentParent = script.Parent.Parent

require(script.Parent.ReactInternalTypes)

local ReactFeatureFlags = require(ParentParent.Shared).ReactFeatureFlags
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
local enableProfilerCommitHooks = ReactFeatureFlags.enableProfilerCommitHooks
local Profiler = require(script.Parent.ReactWorkTags).Profiler
local unstable_now = require(ParentParent.Scheduler).unstable_now
local n1 = 0
local n2 = -1
local n3 = -1
local n4 = -1

function getCommitTime() -- line: 43
	-- upvalues: n1 (ref)
	return n1
end
function recordCommitTime() -- line: 47
	-- upvalues: enableProfilerTimer (copy), n1 (ref), unstable_now (copy)
	if not enableProfilerTimer then
		return
	end

	n1 = unstable_now()
end
function startProfilerTimer(p1) -- line: 54
	-- upvalues: enableProfilerTimer (copy), n3 (ref), unstable_now (copy)
	if not enableProfilerTimer then
		return
	end

	n3 = unstable_now()

	if p1.actualStartTime ~= nil and p1.actualStartTime < 0 then
		p1.actualStartTime = unstable_now()
	end
end
function stopProfilerTimerIfRunning(_) -- line: 67
	-- upvalues: enableProfilerTimer (copy), n3 (ref)
	if not enableProfilerTimer then
		return
	end

	n3 = -1
end
function stopProfilerTimerIfRunningAndRecordDelta(p3, b1: boolean) -- line: 74
	-- upvalues: enableProfilerTimer (copy), n3 (ref), unstable_now (copy)
	if not enableProfilerTimer then
		return
	end

	if n3 >= 0 then
		local v15 = unstable_now() - n3

		p3.actualDuration = p3.actualDuration + v15

		if b1 then
			p3.selfBaseDuration = v15
		end

		n3 = -1
	end
end
function recordLayoutEffectDuration(p4) -- line: 92
	-- upvalues: enableProfilerTimer (copy), enableProfilerCommitHooks (copy), n2 (ref), unstable_now (copy), Profiler (copy)
	if not enableProfilerTimer or not enableProfilerCommitHooks then
		return
	end

	if n2 >= 0 then
		local v17 = unstable_now() - n2

		n2 = -1

		local return_ = p4.return_

		while return_ ~= nil do
			if return_.tag == Profiler then
				local stateNode = return_.stateNode

				stateNode.effectDuration = stateNode.effectDuration + v17

				return
			end

			return_ = return_.return_
		end
	end
end
function recordPassiveEffectDuration(p5) -- line: 115
	-- upvalues: enableProfilerTimer (copy), enableProfilerCommitHooks (copy), n4 (ref), unstable_now (copy), Profiler (copy)
	if not enableProfilerTimer or not enableProfilerCommitHooks then
		return
	end

	if n4 >= 0 then
		local v21 = unstable_now() - n4

		n4 = -1

		local return_ = p5.return_

		while return_ ~= nil do
			if return_.tag == Profiler then
				local stateNode = return_.stateNode

				if stateNode == nil then
					return
				end

				stateNode.passiveEffectDuration = stateNode.passiveEffectDuration + v21

				return
			end

			return_ = return_.return_
		end
	end
end
function startLayoutEffectTimer() -- line: 143
	-- upvalues: enableProfilerTimer (copy), enableProfilerCommitHooks (copy), n2 (ref), unstable_now (copy)
	if not enableProfilerTimer or not enableProfilerCommitHooks then
		return
	end

	n2 = unstable_now()
end
function startPassiveEffectTimer() -- line: 150
	-- upvalues: enableProfilerTimer (copy), enableProfilerCommitHooks (copy), n4 (ref), unstable_now (copy)
	if not enableProfilerTimer or not enableProfilerCommitHooks then
		return
	end

	n4 = unstable_now()
end
function transferActualDuration(p6) -- line: 157
	local child = p6.child

	while child do
		p6.actualDuration = p6.actualDuration + child.actualDuration
		child = child.sibling
	end
end

return {
	getCommitTime = getCommitTime,
	recordCommitTime = recordCommitTime,
	recordLayoutEffectDuration = recordLayoutEffectDuration,
	recordPassiveEffectDuration = recordPassiveEffectDuration,
	startLayoutEffectTimer = startLayoutEffectTimer,
	startPassiveEffectTimer = startPassiveEffectTimer,
	startProfilerTimer = startProfilerTimer,
	stopProfilerTimerIfRunning = stopProfilerTimerIfRunning,
	stopProfilerTimerIfRunningAndRecordDelta = stopProfilerTimerIfRunningAndRecordDelta,
	transferActualDuration = transferActualDuration
}
