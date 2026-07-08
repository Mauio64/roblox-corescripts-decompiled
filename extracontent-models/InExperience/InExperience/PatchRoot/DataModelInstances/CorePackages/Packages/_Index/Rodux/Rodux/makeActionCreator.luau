local function makeActionCreator(p1, p2) -- line: 4
	assert(type(p1) == "string", "Bad argument #1: Expected a string name for the action creator")
	assert(type(p2) == "function", "Bad argument #2: Expected a function that creates action objects")

	return (setmetatable({
		name = p1
	}, {
		__call = function(_, ...) -- line: 12
			-- upvalues: p2 (copy), p1 (copy)
			local v5 = p2(...)

			assert(type(v5) == "table", "Invalid action: An action creator must return a table")
			v5.type = p1

			return v5
		end
	}))
end

return makeActionCreator
