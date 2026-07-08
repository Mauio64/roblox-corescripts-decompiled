local function makeActionCreator(p1, ...) -- line: 11
	local t1 = { ... }

	assert(type(p1) == "string", "Bad argument #1 to makeActionCreator, expected string")

	for i = 1, select("#", ...) do
		assert(typeof(select(i, ...)) == "string", "Bad argument to makeActionCreator, all arguments must be of type string")
	end

	return (setmetatable({
		name = p1
	}, {
		__call = function(_, ...) -- line: 26
			-- upvalues: p1 (copy), t1 (copy)
			local t2 = {
				type = p1
			}

			assert(select("#", ...) == #t1, "Incorrect number of arguments provided to action creator " .. p1)

			for i, v in ipairs(t1) do
				t2[v] = select(i, ...)
			end

			return t2
		end
	}))
end

return makeActionCreator
