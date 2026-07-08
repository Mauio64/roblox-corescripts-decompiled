local ParentParent = script.Parent.Parent.Parent.Parent
local Boolean = require(ParentParent.LuauPolyfill).Boolean
local t1 = {
	__value = "null"
}

return {
	NULL = t1,
	toJSBoolean = function(p1) -- line: 19
		-- upvalues: Boolean (copy), t1 (copy)
		return Boolean.toJSBoolean(p1) and p1 ~= t1
	end
}
