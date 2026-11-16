local GraphQL = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL")
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")

local function getFieldResolver(p2, p3)
	if
		p2
		and p2.parentType
		and p2.fieldName
		and type(p2.parentType.name) == "string"
		and type(p3[p2.parentType.name]) == "table"
		and type(p3[p2.parentType.name][p2.fieldName]) == "function"
	then
		return p3[p2.parentType.name][p2.fieldName]
	end

	return GraphQL.defaultFieldResolver
end

local function buildFieldResolver(p2)
	return function(p3, p4, p5, p6)
		return getFieldResolver(p6, p2)(p3, p4, p5, p6)
	end
end

return buildFieldResolver
