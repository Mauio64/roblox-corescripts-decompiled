require(script.Parent.Parent.types)

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
