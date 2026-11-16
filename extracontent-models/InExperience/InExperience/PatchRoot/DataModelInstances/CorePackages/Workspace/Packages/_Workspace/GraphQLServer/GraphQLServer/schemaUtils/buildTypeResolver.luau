local parent = script:FindFirstAncestor("GraphQLServer").Parent
require(parent.GraphQL)
require(parent.LuauPolyfill)

local function buildTypeResolver(p)
	return function(p2, p3, p4, p5)
		local v = p[p5.name]

		if type(v) == "table" and type(v.__resolveType) == "function" then
			return v.__resolveType(p2, p3, p4, p5)
		end

		return p5.name
	end
end

return buildTypeResolver
