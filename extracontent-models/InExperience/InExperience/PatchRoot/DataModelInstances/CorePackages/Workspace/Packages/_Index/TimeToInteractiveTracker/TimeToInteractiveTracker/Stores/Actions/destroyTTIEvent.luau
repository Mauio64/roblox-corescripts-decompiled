require(script.Parent.Parent.types)

return function(callback)
	return function(p: string)
		callback(function(p2)
			if p2[p] == nil then
				return p2
			end

			local clone = table.clone(p2)
			clone[p] = nil
			return clone
		end)
	end
end
