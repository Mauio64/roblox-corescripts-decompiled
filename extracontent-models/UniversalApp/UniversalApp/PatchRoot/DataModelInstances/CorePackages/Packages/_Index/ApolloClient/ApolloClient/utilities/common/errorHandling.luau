local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean

require(ParentParent.GraphQL)

function t1.graphQLResultHasError(p1) -- line: 18
	-- upvalues: Boolean (copy)
	return not not Boolean.toJSBoolean(p1.errors) and (#p1.errors > 0 or false)
end

return t1
