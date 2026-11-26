require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

return function(callback)
	return function()
		local result = {}
		callback(function(items)
			local result2 = {}

			for k, item in items do
				if item and (item.startTime == nil or item.sent == true) then
					result2[k] = item
				else
					table.insert(result, k)
				end
			end

			return result2
		end)

		return result
	end
end
