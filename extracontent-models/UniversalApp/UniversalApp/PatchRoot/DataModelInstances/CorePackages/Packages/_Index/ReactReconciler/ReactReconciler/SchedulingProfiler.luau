local t1 = {}
local ParentParent = script.Parent.Parent
local WeakMap = require(ParentParent.LuauPolyfill).WeakMap

require(script.Parent.ReactFiberLane)
require(script.Parent.ReactInternalTypes)
require(ParentParent.Shared)

local enableSchedulingProfiler = require(ParentParent.Shared).ReactFeatureFlags.enableSchedulingProfiler
local ReactVersion = require(ParentParent.Shared).ReactVersion
local getComponentName = require(ParentParent.Shared).getComponentName
local v7 = _G.performance ~= nil
local v8 = _G.performance or {
	mark = function(p1) -- line: 41
		debug.profilebegin(p1)
		debug.profileend()
	end
}

function formatLanes(p2) -- line: 47
	return (tostring(p2))
end

local u9 = nil
local t2 = {
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

if enableSchedulingProfiler and v7 then
	v8.mark("--react-init-" .. tostring(ReactVersion))
end

function t1.markCommitStarted(p3) -- line: 75
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--commit-start-" .. formatLanes(p3))
		end

		if u9 then
			u9(t2.CommitStart)
		end
	end
end
function t1.markCommitStopped(p4) -- line: 87
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--commit-stop")
		end

		if u9 then
			u9(t2.CommitStop, p4)
		end
	end
end

local v11 = WeakMap.new()
local n1 = 0

function getWakeableID(p5) -- line: 105
	-- upvalues: v11 (copy), n1 (ref)
	if not v11:has(p5) then
		v11:set(p5, n1)
		n1 += 1
	end

	return v11:get(p5)
end
function t1.markComponentSuspended(p6, p7) -- line: 113
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), getComponentName (copy), v8 (copy)
	if enableSchedulingProfiler and v7 then
		local v20 = getWakeableID(p7)
		local v21 = getComponentName(p6.type) or "Unknown"

		v8.mark("--suspense-suspend-" .. tostring(v20) .. "-" .. v21)
		p7:andThen(function() -- line: 122
			-- upvalues: v8 (copy), v20 (copy), v21 (copy)
			v8.mark("--suspense-resolved-" .. tostring(v20) .. "-" .. v21)
		end, function() -- line: 126
			-- upvalues: v8 (copy), v20 (copy), v21 (copy)
			v8.mark("--suspense-rejected-" .. tostring(v20) .. "-" .. v21)
		end)
	end
end
function t1.markLayoutEffectsStarted(p8) -- line: 135
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--layout-effects-start-" .. formatLanes(p8))
		end

		if u9 then
			u9(t2.LayoutEffectsStart)
		end
	end
end
function t1.markLayoutEffectsStopped() -- line: 147
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--layout-effects-stop")
		end

		if u9 then
			u9(t2.LayoutEffectsStop)
		end
	end
end
function t1.markPassiveEffectsStarted(p9) -- line: 159
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--passive-effects-start-" .. formatLanes(p9))
		end

		if u9 then
			u9(t2.PassiveEffectsStart)
		end
	end
end
function t1.markPassiveEffectsStopped(p10) -- line: 171
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--passive-effects-stop")
		end

		if u9 then
			u9(t2.PassiveEffectsStop, p10)
		end
	end
end
function t1.markRenderStarted(p11) -- line: 183
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--render-start-" .. formatLanes(p11))
		end

		if u9 then
			u9(t2.RenderStart)
		end
	end
end
function t1.markRenderYielded() -- line: 195
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--render-yield")
		end

		if u9 then
			u9(t2.RenderYield)
		end
	end
end
function t1.markRenderStopped() -- line: 207
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy), u9 (ref), t2 (copy)
	if enableSchedulingProfiler then
		if v7 then
			v8.mark("--render-stop")
		end

		if u9 then
			u9(t2.RenderStop)
		end
	end
end
function t1.markRenderScheduled(p12) -- line: 219
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), v8 (copy)
	if enableSchedulingProfiler and v7 then
		v8.mark("--schedule-render-" .. formatLanes(p12))
	end
end
function t1.markForceUpdateScheduled(p13, p14) -- line: 227
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), getComponentName (copy), v8 (copy)
	if enableSchedulingProfiler and v7 then
		local v29 = getComponentName(p13.type) or "Unknown"

		v8.mark("--schedule-forced-update-" .. formatLanes(p14) .. "-" .. v29)
	end
end
function t1.markStateUpdateScheduled(p15, p16) -- line: 239
	-- upvalues: enableSchedulingProfiler (copy), v7 (copy), getComponentName (copy), v8 (copy)
	if enableSchedulingProfiler and v7 then
		local v32 = getComponentName(p15.type) or "Unknown"

		v8.mark("--schedule-state-update-" .. formatLanes(p16) .. "-" .. v32)
	end
end

t1.profilerEventTypes = t2

function t1.registerProfilerEventCallback(p17: ((...any) -> ...any)) -- line: 254
	-- upvalues: u9 (ref)
	if u9 then
		warn("SchedulingProfiler: Another event callback was already registered.")
	end

	u9 = p17
end

return t1
