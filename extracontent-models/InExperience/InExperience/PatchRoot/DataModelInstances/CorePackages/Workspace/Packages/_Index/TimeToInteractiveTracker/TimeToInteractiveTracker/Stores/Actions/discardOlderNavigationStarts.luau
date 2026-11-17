local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

require(script.Parent.Parent.types)

local navigationEventPrefix = require(TimeToInteractiveTracker.Utils.navigationEventPrefix)
local logTTIDiscard = require(TimeToInteractiveTracker.Utils.logTTIDiscard)
local hasNavigationCommitted = require(TimeToInteractiveTracker.Utils.hasNavigationCommitted)

return function(callback, p)
	return function(p2: string)
		local v = {}
		local set = {}
		callback(function(items)
			local item = items[p2]

			if item == nil or item.startTime == nil then
				return items
			end

			for k, item2 in items do
				if not (k ~= p2 and string.sub(k, 1, #navigationEventPrefix) == navigationEventPrefix and item2 ~= nil and item2.startTime ~= nil) then
					continue
				end

				if item2.sent or not (item2.startTime < item.startTime) then
					continue
				end

				table.insert(v, k)

				if hasNavigationCommitted(item2) then
					set[k] = true
				end
			end

			if #v == 0 then
				return items
			end

			local clone = table.clone(items)

			for _, v2 in v do
				clone[v2] = nil
			end

			return clone
		end)

		for _, v2 in v do
			p[v2] = true

			if set[v2] then
				logTTIDiscard(v2, "superseded")
			end
		end
	end
end
