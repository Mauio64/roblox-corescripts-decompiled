local object = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Object

local function addMockResolvers(p2, p3)
	local v5 = object.assign({}, p2, p3)
	local v6 = object.assign({}, p2.Query or {}, p3.Query or {})
	local v7 = object.assign({}, p2.Mutation or {}, p3.Mutation or {})

	object.assign(v5, { Query = v6, Mutation = v7 })

	return v5
end

return addMockResolvers
