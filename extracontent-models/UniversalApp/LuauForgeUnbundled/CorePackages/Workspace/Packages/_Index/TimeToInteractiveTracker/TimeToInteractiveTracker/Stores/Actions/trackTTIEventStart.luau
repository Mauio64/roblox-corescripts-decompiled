require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local now = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/now")
local fFlagLuaAppNavTTIMeasurementV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/TimeToInteractiveTracker/SharedFlags").FFlagLuaAppNavTTIMeasurementV2

return function(callback, p2)
	local set = {}

	return function(p3, p4)
		if fFlagLuaAppNavTTIMeasurementV2 and p2 then
			p2[p3] = nil
		end

		callback(function(p5)
			local v5 = p5[p3]

			local v6 = now()

			local clone = table.clone(p5)
			clone[p3] = {
				startTime = v6,
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				metadata = v5 == nil and {} or table.clone(v5.metadata)
			}

			if p4 then
				clone[p3].metadata.coldStart = not set[p3]
				set[p3] = true
			end

			return clone
		end)
	end
end
