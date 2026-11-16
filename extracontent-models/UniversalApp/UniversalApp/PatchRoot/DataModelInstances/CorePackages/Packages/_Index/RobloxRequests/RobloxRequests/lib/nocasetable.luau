return function(items)
	local self = setmetatable({}, {
		__index = function(p, value)
			return (rawget(p, value:lower()))
		end,
		__newindex = function(p, value, p2)
			rawset(p, value:lower(), p2)
		end
	})

	for k, item in pairs(items) do
		self[k] = item
	end

	return self
end
