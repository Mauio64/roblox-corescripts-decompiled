return function(p1) -- line: 4
	local self = setmetatable({}, {
		__index = function(p2, p3) -- line: 6
			return (rawget(p2, p3:lower()))
		end,
		__newindex = function(p4, p5, p6) -- line: 9
			rawset(p4, p5:lower(), p6)
		end
	})

	for k, v in pairs(p1) do
		self[k] = v
	end

	return self
end
