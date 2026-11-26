require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Stores/types")

local navigationEventPrefix = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/navigationEventPrefix")
local logTTIDiscard = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/logTTIDiscard")
local hasNavigationCommitted = require("@game/CorePackages/Workspace/Packages/_Index/TimeToInteractiveTracker/TimeToInteractiveTracker/Utils/hasNavigationCommitted")

return function(callback, p2)
	return function(p3)
		local v5 = {}
		local set = {}
		callback(function(items)
			local item = items[p3]

			if item == nil or item.startTime == nil then
				return items
			end

			for k, item2 in items do
				if not (k ~= p3 and string.sub(k, 1, #navigationEventPrefix) == navigationEventPrefix and item2 ~= nil and item2.startTime ~= nil) then
					continue
				end

				if item2.sent or not (item2.startTime < item.startTime) then
					continue
				end

				table.insert(v5, k)

				if hasNavigationCommitted(item2) then
					set[k] = true
				end
			end

			if #v5 == 0 then
				return items
			end

			local clone = table.clone(items)

			for k, v6 in v5 do
				clone[v6] = nil
			end

			return clone
		end)

		for k, v6 in v5 do
			p2[v6] = true

			if set[v6] then
				logTTIDiscard(v6, "superseded")
			end
		end
	end
end
