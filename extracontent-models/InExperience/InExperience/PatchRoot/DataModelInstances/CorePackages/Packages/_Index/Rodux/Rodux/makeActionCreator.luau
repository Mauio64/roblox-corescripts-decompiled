local function makeActionCreator(name, callback)
	assert(type(name) == "string", "Bad argument #1: Expected a string name for the action creator")

	assert(type(callback) == "function", "Bad argument #2: Expected a function that creates action objects")

	return (setmetatable({ name = name }, {
		__call = function(_, ...)
			local v = callback(...)

			assert(type(v) == "table", "Invalid action: An action creator must return a table")

			v.type = name

			return v
		end
	}))
end

return makeActionCreator
