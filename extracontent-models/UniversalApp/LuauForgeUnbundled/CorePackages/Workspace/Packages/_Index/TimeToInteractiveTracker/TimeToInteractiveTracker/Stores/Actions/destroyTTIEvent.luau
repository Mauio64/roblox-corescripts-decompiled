require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

return function(callback)
	return function(p2)
		callback(function(p3)
			if p3[p2] == nil then
				return p3
			end

			local clone = table.clone(p3)
			clone[p2] = nil
			return clone
		end)
	end
end
