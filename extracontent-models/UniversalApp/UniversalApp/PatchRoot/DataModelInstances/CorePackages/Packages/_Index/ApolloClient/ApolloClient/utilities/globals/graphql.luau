local t1 = {}
local ParentParent = script.Parent.Parent.Parent.Parent
local isType = require(ParentParent.GraphQL).isType

function t1.removeTemporaryGlobals() -- line: 26
	-- upvalues: isType (copy)
	isType(nil)

	local function remove() -- line: 33
	end

	return remove()
end

return t1
