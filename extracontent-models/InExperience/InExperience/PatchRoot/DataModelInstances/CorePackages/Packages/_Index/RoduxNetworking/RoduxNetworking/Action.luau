return function(name, callback)
	assert(type(name) == "string", "A name must be provided to create an Action")
	assert(type(callback) == "function", "A function must be provided to create an Action")

	return (setmetatable({ name = name }, {
		__call = function(_, ...)
			local v = callback(...)

			assert(type(v) == "table", "An action must return a table")

			v.type = name

			return v
		end
	}))
end
