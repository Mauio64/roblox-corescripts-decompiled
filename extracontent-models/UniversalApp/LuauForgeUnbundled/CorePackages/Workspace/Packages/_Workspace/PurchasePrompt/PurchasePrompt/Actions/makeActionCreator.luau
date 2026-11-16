local function makeActionCreator(value, ...)
	assert(type(value) == "string", "Bad argument #1 to makeActionCreator, expected string")
	local v5 = { ... }

	for i = 1, select("#", ...) do
		assert(
			typeof((select)(i, ...)) == "string",
			"Bad argument to makeActionCreator, all arguments must be of type string"
		)
	end

	return (setmetatable({ name = value }, {
		__call = function(p2, ...)
			local result = { type = value }

			assert(
				select("#", ...) == #v5,
				"Incorrect number of arguments provided to action creator " .. value
			)

			for i, v6 in ipairs(v5) do
				result[v6] = select(i, ...)
			end

			return result
		end
	}))
end

return makeActionCreator
