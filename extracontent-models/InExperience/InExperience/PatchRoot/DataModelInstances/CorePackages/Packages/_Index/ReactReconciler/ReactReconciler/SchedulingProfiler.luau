local SchedulingProfiler = {}
local parent = script.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local WeakMap = LuauPolyfill.WeakMap

require(script.Parent.ReactFiberLane)

require(script.Parent.ReactInternalTypes)

require(parent.Shared)

local Shared = require(parent.Shared)
local enableSchedulingProfiler = Shared.ReactFeatureFlags.enableSchedulingProfiler
local Shared2 = require(parent.Shared)
local ReactVersion = Shared2.ReactVersion
local Shared3 = require(parent.Shared)
local getComponentName = Shared3.getComponentName

local v = _G.performance ~= nil
local performance = _G.performance or {
	mark = function(p)
		debug.profilebegin(p)
		debug.profileend()
	end
}

function formatLanes(p)
	return (tostring(p))
end

local v2 = nil
local profilerEventTypes = {
	CommitStart = 0,
	CommitStop = 1,
	LayoutEffectsStart = 2,
	LayoutEffectsStop = 3,
	PassiveEffectsStart = 4,
	PassiveEffectsStop = 5,
	RenderStart = 6,
	RenderYield = 7,
	RenderStop = 8
}

if enableSchedulingProfiler and v then
	performance.mark("--react-init-" .. tostring(ReactVersion))
end

function SchedulingProfiler.markCommitStarted(p)
	if enableSchedulingProfiler then
		if v then
			performance.mark("--commit-start-" .. formatLanes(p))
		end

		if v2 then
			v2(profilerEventTypes.CommitStart)
		end
	end
end

function SchedulingProfiler.markCommitStopped(p)
	if enableSchedulingProfiler then
		if v then
			performance.mark("--commit-stop")
		end

		if v2 then
			v2(profilerEventTypes.CommitStop, p)
		end
	end
end

local v3 = WeakMap.new()
local count = 0
function getWakeableID(p)
	if not v3:has(p) then
		v3:set(p, count)
		count += 1
	end

	return v3:get(p)
end

function SchedulingProfiler.markComponentSuspended(p, object)
	if enableSchedulingProfiler and v then
		local wakeableID = getWakeableID(object)
		local v4 = getComponentName(p.type) or "Unknown"

		performance.mark("--suspense-suspend-" .. tostring(wakeableID) .. "-" .. v4)

		object:andThen(function()
			performance.mark("--suspense-resolved-" .. tostring(wakeableID) .. "-" .. v4)
		end, function()
			performance.mark("--suspense-rejected-" .. tostring(wakeableID) .. "-" .. v4)
		end)
	end
end

function SchedulingProfiler.markLayoutEffectsStarted(p)
	if enableSchedulingProfiler then
		if v then
			performance.mark("--layout-effects-start-" .. formatLanes(p))
		end

		if v2 then
			v2(profilerEventTypes.LayoutEffectsStart)
		end
	end
end

function SchedulingProfiler.markLayoutEffectsStopped()
	if enableSchedulingProfiler then
		if v then
			performance.mark("--layout-effects-stop")
		end

		if v2 then
			v2(profilerEventTypes.LayoutEffectsStop)
		end
	end
end

function SchedulingProfiler.markPassiveEffectsStarted(p)
	if enableSchedulingProfiler then
		if v then
			performance.mark("--passive-effects-start-" .. formatLanes(p))
		end

		if v2 then
			v2(profilerEventTypes.PassiveEffectsStart)
		end
	end
end

function SchedulingProfiler.markPassiveEffectsStopped(p)
	if enableSchedulingProfiler then
		if v then
			performance.mark("--passive-effects-stop")
		end

		if v2 then
			v2(profilerEventTypes.PassiveEffectsStop, p)
		end
	end
end

function SchedulingProfiler.markRenderStarted(p)
	if enableSchedulingProfiler then
		if v then
			performance.mark("--render-start-" .. formatLanes(p))
		end

		if v2 then
			v2(profilerEventTypes.RenderStart)
		end
	end
end

function SchedulingProfiler.markRenderYielded()
	if enableSchedulingProfiler then
		if v then
			performance.mark("--render-yield")
		end

		if v2 then
			v2(profilerEventTypes.RenderYield)
		end
	end
end

function SchedulingProfiler.markRenderStopped()
	if enableSchedulingProfiler then
		if v then
			performance.mark("--render-stop")
		end

		if v2 then
			v2(profilerEventTypes.RenderStop)
		end
	end
end

function SchedulingProfiler.markRenderScheduled(p)
	if enableSchedulingProfiler and v then
		performance.mark("--schedule-render-" .. formatLanes(p))
	end
end

function SchedulingProfiler.markForceUpdateScheduled(p, p2)
	if enableSchedulingProfiler and v then
		local v4 = getComponentName(p.type) or "Unknown"

		performance.mark("--schedule-forced-update-" .. formatLanes(p2) .. "-" .. v4)
	end
end

function SchedulingProfiler.markStateUpdateScheduled(p, p2)
	if enableSchedulingProfiler and v then
		local v4 = getComponentName(p.type) or "Unknown"

		performance.mark("--schedule-state-update-" .. formatLanes(p2) .. "-" .. v4)
	end
end

SchedulingProfiler.profilerEventTypes = profilerEventTypes

function SchedulingProfiler.registerProfilerEventCallback(callback)
	if v2 then
		warn("SchedulingProfiler: Another event callback was already registered.")
	end

	v2 = callback
end

return SchedulingProfiler
