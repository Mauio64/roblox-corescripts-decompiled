local parent = script:FindFirstAncestor("TimeToInteractiveTracker").Parent

require(script.Parent.Parent.types)

local now = require(script.Parent.Parent.Parent.Utils.now)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppNavTTIMeasurementV2 = SharedFlags.FFlagLuaAppNavTTIMeasurementV2

return function(callback, p)
	local set = {}

	return function(p2: string, flag: boolean?)
		if FFlagLuaAppNavTTIMeasurementV2 and p then
			p[p2] = nil
		end

		callback(function(p3)
			local v = p3[p2]

			local startTime = now()

			local clone = table.clone(p3)
			clone[p2] = {
				startTime = startTime,
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				metadata = v == nil and {} or table.clone(v.metadata)
			}

			if flag then
				clone[p2].metadata.coldStart = not set[p2]
				set[p2] = true
			end

			return clone
		end)
	end
end
