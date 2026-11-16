local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Logger"):new("trackMilestone")
local FFlagDebugTimeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagDebugTimeToInteractiveTracker")

local FFlagTimeToInteractiveTrackerWarningsRequireDebug = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTimeToInteractiveTrackerWarningsRequireDebug")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local now = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/now")
local getMemoryMb = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/getMemoryMb")
local FFlagTTITrackerMemoryTracking = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTTITrackerMemoryTracking")

return function(callback, callback2)
	return function(p2, p3, p4)
		local v6 = now()
		local v7 = callback(false)[p2]

		if v7 and v7.startTime then
			local v8 = (v6 - v7.startTime) * 1000

			local v9 = if FFlagTTITrackerMemoryTracking then getMemoryMb() else nil

			local v10 = {
				name = p3,
				id = 0,
				timestamp = 0,
				deltaMs = 0,
				totalMemoryMB = 0,
				luaHeapMB = 0
			}

			local v11 = if p4 then p4.id else nil
			v10.id = v11
			v10.timestamp = v6
			v10.deltaMs = v8
			local v12 = if v9 then v9.totalMemoryMB else nil
			v10.totalMemoryMB = v12
			local v13 = if v9 then v9.luaHeapMB else nil
			v10.luaHeapMB = v13

			callback2(function(p5)
				local v14 = p5[p2]

				if not v14 then
					return p5
				end

				local clone = table.clone(p5)
				local clone2 = table.clone(v14)
				local v15 = not clone2.milestones and {} or table.clone(clone2.milestones)
				table.insert(v15, v10)
				clone2.milestones = v15

				clone[p2] = clone2
				return clone
			end)
		elseif FFlagTimeToInteractiveTrackerWarningsRequireDebug then
			if FFlagDebugTimeToInteractiveTracker then
				v5:warning(`called before trackStart for eventName={p2}`)
			end
		else
			v5:warning(`called before trackStart for eventName={p2}`)
		end
	end
end
