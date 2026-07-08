local ParentParent = script.Parent.Parent.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local t1 = {}

require(script.Parent.Parent.core.types)

function t1.selectURI(p1, p2) -- line: 19
	-- upvalues: Boolean (copy)
	local uri = p1:getContext().uri

	if Boolean.toJSBoolean(uri) then
		return uri
	end

	if typeof(p2) == "function" then
		return p2(p1)
	end

	return Boolean.toJSBoolean(p2) and p2 or "/graphql"
end

return t1
