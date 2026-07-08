local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Error = require(ParentParentParent.LuauPolyfill).Error

require(ParentParent.luaUtils.Response)

return {
	throwServerError = function(p1, p2, s1: string) -- line: 31
		-- upvalues: Error (copy)
		local v7 = Error.new(s1)

		v7.name = "ServerError"
		v7.response = p1
		v7.statusCode = p1.status
		v7.result = p2
		error(v7)
	end
}
