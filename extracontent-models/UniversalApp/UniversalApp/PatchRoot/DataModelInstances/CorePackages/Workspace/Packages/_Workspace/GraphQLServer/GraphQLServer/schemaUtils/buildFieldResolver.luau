local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local GraphQL = require(Parent.GraphQL)

require(Parent.LuauPolyfill)

local function getFieldResolver(p1, p2) -- line: 7
	-- upvalues: GraphQL (copy)
	if not p1 or (not p1.parentType or not p1.fieldName or type(p1.parentType.name) ~= "string" or type(p2[p1.parentType.name]) ~= "table" or type(p2[p1.parentType.name][p1.fieldName]) ~= "function") then
		return GraphQL.defaultFieldResolver
	end

	return p2[p1.parentType.name][p1.fieldName]
end
local function buildFieldResolver(p3) -- line: 22
	-- upvalues: getFieldResolver (copy)
	return function(p4, p5, p6, p7) -- line: 23
		-- upvalues: getFieldResolver (copy), p3 (copy)
		return getFieldResolver(p7, p3)(p4, p5, p6, p7)
	end
end

return buildFieldResolver
