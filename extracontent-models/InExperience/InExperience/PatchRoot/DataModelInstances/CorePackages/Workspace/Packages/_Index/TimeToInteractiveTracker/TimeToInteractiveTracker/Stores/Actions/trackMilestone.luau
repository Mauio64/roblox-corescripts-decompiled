local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")
local TimeToInteractiveTrackerParent = TimeToInteractiveTracker.Parent
local v3 = require(TimeToInteractiveTracker.Logger):new(script.Name)
local FFlagLuaAppPerfTrackerUseLogger = require(TimeToInteractiveTrackerParent.SharedFlags).FFlagLuaAppPerfTrackerUseLogger
local FFlagDebugTimeToInteractiveTracker = require(TimeToInteractiveTracker.Utils.FFlagDebugTimeToInteractiveTracker)
local FFlagTimeToInteractiveTrackerWarningsRequireDebug = require(TimeToInteractiveTracker.Utils.FFlagTimeToInteractiveTrackerWarningsRequireDebug)

require(script.Parent.Parent.types)

local now = require(TimeToInteractiveTracker.Utils.now)
local getMemoryMb = require(TimeToInteractiveTracker.Utils.getMemoryMb)
local FFlagTTITrackerMemoryTracking = require(TimeToInteractiveTracker.Utils.FFlagTTITrackerMemoryTracking)

return function(p1, p2) -- line: 24
	-- upvalues: now (copy), FFlagLuaAppPerfTrackerUseLogger (copy), FFlagTimeToInteractiveTrackerWarningsRequireDebug (copy), FFlagDebugTimeToInteractiveTracker (copy), v3 (copy), FFlagTTITrackerMemoryTracking (copy), getMemoryMb (copy)
	return function(s1: string, p3, p4) -- line: 25
		-- upvalues: now (copy), p1 (copy), FFlagLuaAppPerfTrackerUseLogger (copy), FFlagTimeToInteractiveTrackerWarningsRequireDebug (copy), FFlagDebugTimeToInteractiveTracker (copy), v3 (copy), FFlagTTITrackerMemoryTracking (copy), getMemoryMb (copy), p2 (copy)
		local v15 = now()
		local v16 = p1(false)[s1]

		if not v16 or not v16.startTime then
			if FFlagLuaAppPerfTrackerUseLogger then
				if not FFlagTimeToInteractiveTrackerWarningsRequireDebug then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return
				end

				if FFlagDebugTimeToInteractiveTracker then
					v3:warning(`called before trackStart for eventName={ s1 }`)

					return
				end
			elseif FFlagTimeToInteractiveTrackerWarningsRequireDebug then
				if FFlagDebugTimeToInteractiveTracker then
					warn(`TimeToInteractiveTracker.trackMilestone called before trackStart for eventName={ s1 }`)

					return
				end
			else
				warn(`TimeToInteractiveTracker.trackMilestone called before trackStart for eventName={ s1 }`)
			end

			return
		end

		local v17 = (v15 - v16.startTime) * 1000
		local v18 = if not (FFlagTTITrackerMemoryTracking and v16.trackMemory == true) then nil else getMemoryMb()
		local t1 = {
			name = p3,
			id = if not p4 then nil else p4.id,
			timestamp = v15,
			deltaMs = v17,
			totalMemoryMB = if not v18 then nil else v18.totalMemoryMB,
			luaHeapMB = if not v18 then nil else v18.luaHeapMB
		}

		p2(function(p5) -- line: 66
			-- upvalues: s1 (copy), t1 (copy)
			local v21 = p5[s1]

			if not v21 then
				return p5
			end

			local v22 = table.clone(p5)
			local v23 = table.clone(v21)
			local v24 = if not v23.milestones then {} else table.clone(v23.milestones)

			table.insert(v24, t1)
			v23.milestones = v24
			v22[s1] = v23

			return v22
		end)
	end
end
