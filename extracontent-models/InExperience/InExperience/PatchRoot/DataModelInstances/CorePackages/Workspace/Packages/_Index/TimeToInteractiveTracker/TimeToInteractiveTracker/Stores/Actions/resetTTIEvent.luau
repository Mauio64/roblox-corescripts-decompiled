require(script.Parent.Parent.types)

return function(callback)
	return function(p: string)
		callback(function(p2)
			local v = p2[p]

			if v == nil then
				return p2
			end

			local clone = table.clone(p2)
			clone[p] = {
				startTime = nil,
				endTime = nil,
				deltaMs = nil,
				sent = nil,
				metadata = table.clone(v.metadata)
			}

			return clone
		end)
	end
end
