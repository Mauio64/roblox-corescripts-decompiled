require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

return function(callback)
	return function(p2)
		callback(function(p3)
			local v5 = p3[p2]

			if v5 == nil then
				return p3
			end

			local clone = table.clone(p3)
			clone[p2] = {
				startTime = nil,
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				metadata = table.clone(v5.metadata)
			}

			return clone
		end)
	end
end
