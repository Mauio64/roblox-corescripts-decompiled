local parent = script:FindFirstAncestor("GraphQLServer").Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local function addMockResolvers(p, p2)
	local v = Object.assign({}, p, p2)
	local query = Object.assign({}, p.Query or {}, p2.Query or {})
	local mutation = Object.assign({}, p.Mutation or {}, p2.Mutation or {})

	Object.assign(v, { Query = query, Mutation = mutation })

	return v
end

return addMockResolvers
