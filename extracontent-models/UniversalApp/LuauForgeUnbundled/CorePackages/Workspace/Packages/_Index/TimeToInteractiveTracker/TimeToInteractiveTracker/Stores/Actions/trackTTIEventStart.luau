require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local now = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/now")

return function(callback)
	local set = {}

	return function(p2, p3)
		callback(function(p4)
			local v5 = p4[p2]

			local v6 = now()

			local clone = table.clone(p4)
			clone[p2] = {
				startTime = v6,
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				metadata = v5 == nil and {} or table.clone(v5.metadata)
			}

			if p3 then
				clone[p2].metadata.coldStart = not set[p2]
				set[p2] = true
			end

			return clone
		end)
	end
end
