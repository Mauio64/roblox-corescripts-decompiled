local parent = script:FindFirstAncestor("GraphQLServer").Parent
local GraphQL = require(parent.GraphQL)
require(parent.LuauPolyfill)

local function getFieldResolver(p, p2)
	if
		p
		and p.parentType
		and p.fieldName
		and type(p.parentType.name) == "string"
		and type(p2[p.parentType.name]) == "table"
		and type(p2[p.parentType.name][p.fieldName]) == "function"
	then
		return p2[p.parentType.name][p.fieldName]
	end

	return GraphQL.defaultFieldResolver
end

local function buildFieldResolver(p)
	return function(p2, p3, p4, p5)
		return getFieldResolver(p5, p)(p2, p3, p4, p5)
	end
end

return buildFieldResolver
