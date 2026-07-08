local ParentParent = script.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local t1 = {}
local Kind = require(ParentParent.GraphQL).Kind

function t1.isDocumentNode(p1) -- line: 18
	-- upvalues: Boolean (copy), Kind (copy)
	return Boolean.toJSBoolean(p1) and (typeof(p1) == "table" and (Boolean.toJSBoolean(p1.kind) and p1.kind == Kind.DOCUMENT))
end

return t1
