return function(p1, p2) -- line: 3
	assert(type(p1) == "string", "A name must be provided to create an Action")
	assert(type(p2) == "function", "A function must be provided to create an Action")

	return (setmetatable({
		name = p1
	}, {
		__call = function(_, ...) -- line: 10
			-- upvalues: p2 (copy), p1 (copy)
			local v4 = p2(...)

			assert(type(v4) == "table", "An action must return a table")
			v4.type = p1

			return v4
		end
	}))
end
