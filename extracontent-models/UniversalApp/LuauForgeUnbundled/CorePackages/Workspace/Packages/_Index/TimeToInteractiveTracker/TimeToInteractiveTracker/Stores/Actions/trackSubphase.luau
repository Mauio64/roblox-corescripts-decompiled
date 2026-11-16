local v5 = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Logger"):new("trackSubphase")
local FFlagDebugTimeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagDebugTimeToInteractiveTracker")

local FFlagTimeToInteractiveTrackerWarningsRequireDebug = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/FFlagTimeToInteractiveTrackerWarningsRequireDebug")

require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local now = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/now")
local Util = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/Util")

return function(callback, callback2)
	return function(p2, p3, p4)
		local v6 = now()
		local v7 = callback(false)[p2]

		if v7 and v7.startTime then
			local v8 = {
				name = p4,
				timestamp = v6,
				deltaMs = (v6 - v7.startTime) * 1000
			}

			callback2(function(p5)
				local v9 = p5[p2]

				if not (v9 and v9.milestones) then
					return p5
				end

				local lastMilestoneIndex = Util.findLastMilestoneIndex(v9.milestones, p3)

				if lastMilestoneIndex then
					local clone = table.clone(p5)
					local clone2 = table.clone(v9)
					local clone3 = table.clone(v9.milestones)
					local clone4 = table.clone(clone3[lastMilestoneIndex])

					local v10 = not clone4.subphases and {} or table.clone(clone4.subphases)
					table.insert(v10, v8)
					clone4.subphases = v10

					clone3[lastMilestoneIndex] = clone4
					clone2.milestones = clone3
					clone[p2] = clone2
					return clone
				end

				if FFlagTimeToInteractiveTrackerWarningsRequireDebug then
					if FFlagDebugTimeToInteractiveTracker then
						v5:warning(`no milestone "{p3}" found for eventName={p2}`)
						return p5
					end
				else
					v5:warning(`no milestone "{p3}" found for eventName={p2}`)
				end

				return p5
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
