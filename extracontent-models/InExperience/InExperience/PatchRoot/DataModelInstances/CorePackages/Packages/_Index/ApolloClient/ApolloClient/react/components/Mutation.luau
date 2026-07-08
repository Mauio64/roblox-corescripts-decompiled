local t1 = {}
local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Boolean = require(ParentParentParent.LuauPolyfill).Boolean

require(ParentParent.core)
require(script.Parent.types)

local useMutation = require(script.Parent.Parent.hooks).useMutation

function t1.Mutation(p1) -- line: 31
	-- upvalues: useMutation (copy), Boolean (copy)
	local v7, v8 = table.unpack(useMutation(p1.mutation, p1), 1, 2)

	if Boolean.toJSBoolean(p1.children) then
		return p1.children(v7, v8)
	end

	return nil
end

return t1
