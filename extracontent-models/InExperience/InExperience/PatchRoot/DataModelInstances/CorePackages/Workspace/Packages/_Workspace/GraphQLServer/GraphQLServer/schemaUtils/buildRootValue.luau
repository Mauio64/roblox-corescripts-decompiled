local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local Object = require(Parent.LuauPolyfill).Object

local function buildRootValue(p1) -- line: 6
	-- upvalues: Object (copy)
	local v5 = p1.Query or {}
	local v6 = p1.Mutation or {}

	return (Object.assign({}, v5, v6))
end

return buildRootValue
