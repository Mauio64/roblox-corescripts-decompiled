local parent = script.Parent.Parent
local parent2 = parent.Parent
require(parent2.LuauPolyfill)

local devAssert = require(parent.jsutils.devAssert)
local devAssert2 = devAssert.devAssert
require(parent.language.location)

require(script.Parent.GraphQLError)

return {
	formatError = function(data)
		devAssert2(data, "Received nil error.")

		local message = not (data.message and string.len(data.message) > 0) and "An unknown error occurred."
			or data.message

		local locations = data.locations
		local path = data.path
		local extensions = data.extensions

		return extensions and {
				message = message,
				locations = locations,
				path = path,
				extensions = extensions
			}
			or { message = message, locations = locations, path = path }
	end
}
