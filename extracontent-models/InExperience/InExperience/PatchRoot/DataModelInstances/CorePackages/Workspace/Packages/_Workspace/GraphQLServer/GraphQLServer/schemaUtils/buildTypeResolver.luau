local Parent = script:FindFirstAncestor("GraphQLServer").Parent

require(Parent.GraphQL)
require(Parent.LuauPolyfill)

local function buildTypeResolver(p1) -- line: 8
	return function(p2, p3, p4, p5) -- line: 9
		-- upvalues: p1 (copy)
		local v8 = p1[p5.name]

		if type(v8) == "table" and type(v8.__resolveType) == "function" then
			return v8.__resolveType(p2, p3, p4, p5)
		end

		return p5.name
	end
end

return buildTypeResolver
