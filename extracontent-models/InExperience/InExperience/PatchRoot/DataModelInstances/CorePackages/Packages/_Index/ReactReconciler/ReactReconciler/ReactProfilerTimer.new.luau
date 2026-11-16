local parent = script.Parent.Parent

require(script.Parent.ReactInternalTypes)

local Shared = require(parent.Shared)
local ReactFeatureFlags = Shared.ReactFeatureFlags
local enableProfilerTimer = ReactFeatureFlags.enableProfilerTimer
local enableProfilerCommitHooks = ReactFeatureFlags.enableProfilerCommitHooks

local ReactWorkTags = require(script.Parent.ReactWorkTags)
local Profiler = ReactWorkTags.Profiler

local Scheduler = require(parent.Scheduler)

local unstable_now = Scheduler.unstable_now

local commitTime = 0
local v = -1
local v2 = -1
local v3 = -1

function getCommitTime()
	return commitTime
end

function recordCommitTime()
	if not enableProfilerTimer then
		return
	end

	commitTime = unstable_now()
end

function startProfilerTimer(p)
	if not enableProfilerTimer then
		return
	end

	v2 = unstable_now()

	if p.actualStartTime ~= nil and p.actualStartTime < 0 then
		p.actualStartTime = unstable_now()
	end
end

function stopProfilerTimerIfRunning(_)
	if not enableProfilerTimer then
		return
	end

	v2 = -1
end

function stopProfilerTimerIfRunningAndRecordDelta(p, flag: boolean)
	if not enableProfilerTimer then
		return
	end

	if v2 >= 0 then
		local selfBaseDuration = unstable_now() - v2
		p.actualDuration += selfBaseDuration

		if flag then
			p.selfBaseDuration = selfBaseDuration
		end

		v2 = -1
	end
end

function recordLayoutEffectDuration(p)
	if not (enableProfilerTimer and enableProfilerCommitHooks) then
		return
	end

	if v >= 0 then
		local v4 = unstable_now() - v

		v = -1

		local return_ = p.return_

		while return_ ~= nil do
			if return_.tag == Profiler then
				return_.stateNode.effectDuration += v4
				return
			end

			return_ = return_.return_
		end
	end
end

function recordPassiveEffectDuration(p)
	if not (enableProfilerTimer and enableProfilerCommitHooks) then
		return
	end

	if v3 >= 0 then
		local v4 = unstable_now() - v3

		v3 = -1

		local return_ = p.return_

		while return_ ~= nil do
			if return_.tag == Profiler then
				local stateNode = return_.stateNode

				if stateNode == nil then
					break
				end

				stateNode.passiveEffectDuration += v4

				return
			end

			return_ = return_.return_
		end
	end
end

function startLayoutEffectTimer()
	if enableProfilerTimer and enableProfilerCommitHooks then
		v = unstable_now()
	end
end

function startPassiveEffectTimer()
	if enableProfilerTimer and enableProfilerCommitHooks then
		v3 = unstable_now()
	end
end

function transferActualDuration(state)
	local v4 = state.child

	while v4 do
		state.actualDuration += v4.actualDuration
		v4 = v4.sibling
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
