local function makeActionCreator(name, ...)
	assert(type(name) == "string", "Bad argument #1 to makeActionCreator, expected string")
	local v = { ... }

	for i = 1, select("#", ...) do
		assert(
			typeof((select)(i, ...)) == "string",
			"Bad argument to makeActionCreator, all arguments must be of type string"
		)
	end

	return (setmetatable({ name = name }, {
		__call = function(_, ...)
			local result = { type = name }

			assert(select("#", ...) == #v, "Incorrect number of arguments provided to action creator " .. name)

			for i, v2 in ipairs(v) do
				result[v2] = select(i, ...)
			end

			return result
		end
	}))
end

return makeActionCreator
