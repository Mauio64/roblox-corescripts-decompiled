require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

return function(callback)
	return function()
		callback(function(items)
			local result = {}

			for k, item in items do
				if item and (item.startTime == nil or item.sent == true) then
					result[k] = item
				end
			end

			return result
		end)
	end
end
