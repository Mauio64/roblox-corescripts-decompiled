local ErrorHandling = {}
local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Boolean = LuauPolyfill.Boolean

require(parent.GraphQL)

function ErrorHandling.graphQLResultHasError(p)
	return Boolean.toJSBoolean(p.errors) and #p.errors > 0 and true or false
end

return ErrorHandling
