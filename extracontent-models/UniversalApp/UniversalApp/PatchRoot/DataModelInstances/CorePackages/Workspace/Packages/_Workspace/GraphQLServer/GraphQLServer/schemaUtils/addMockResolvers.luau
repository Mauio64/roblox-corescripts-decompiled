local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local Object = require(Parent.LuauPolyfill).Object

local function addMockResolvers(p1, p2) -- line: 6
	-- upvalues: Object (copy)
	local v6 = Object.assign({}, p1, p2)
	local v7 = Object.assign({}, p1.Query or {}, p2.Query or {})
	local v8 = Object.assign({}, p1.Mutation or {}, p2.Mutation or {})

	Object.assign(v6, {
		Query = v7,
		Mutation = v8
	})

	return v6
end

return addMockResolvers
