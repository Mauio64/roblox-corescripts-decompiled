local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent

require(ParentParentParent.LuauPolyfill)

local devAssert = require(ParentParent.jsutils.devAssert).devAssert

require(ParentParent.language.location)
require(script.Parent.GraphQLError)

return {
	formatError = function(p1) -- line: 25
		-- upvalues: devAssert (copy)
		devAssert(p1, "Received nil error.")

		local v5 = (not p1.message or not (string.len(p1.message) > 0)) and "An unknown error occurred." or p1.message
		local locations = p1.locations
		local path = p1.path
		local extensions = p1.extensions

		return extensions and {
			message = v5,
			locations = locations,
			path = path,
			extensions = extensions
		} or {
			message = v5,
			locations = locations,
			path = path
		}
	end
}
