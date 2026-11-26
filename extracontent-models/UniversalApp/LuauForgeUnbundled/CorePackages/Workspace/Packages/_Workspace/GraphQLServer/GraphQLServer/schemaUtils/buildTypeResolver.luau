require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL")
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

local function buildTypeResolver(p2)
	return function(p3, p4, p5, p6)
		local v5 = p2[p6.name]

		if type(v5) == "table" and type(v5.__resolveType) == "function" then
			return v5.__resolveType(p3, p4, p5, p6)
		end

		return p6.name
	end
end

return buildTypeResolver
