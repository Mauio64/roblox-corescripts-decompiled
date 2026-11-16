require(script.Parent.Parent.types)

local now = require(script.Parent.Parent.Parent.Utils.now)

return function(callback)
	local set = {}

	return function(p: string, flag: boolean?)
		callback(function(p2)
			local v = p2[p]

			local startTime = now()

			local clone = table.clone(p2)
			clone[p] = {
				startTime = startTime,
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				metadata = v == nil and {} or table.clone(v.metadata)
			}

			if flag then
				clone[p].metadata.coldStart = not set[p]
				set[p] = true
			end

			return clone
		end)
	end
end
