local parent = script.Parent.Parent.Parent.Parent

local GraphQL = require(parent.GraphQL)
local isType = GraphQL.isType
return {
	removeTemporaryGlobals = function()
		isType(nil)

		local function remove() end
		return remove()
	end
}
