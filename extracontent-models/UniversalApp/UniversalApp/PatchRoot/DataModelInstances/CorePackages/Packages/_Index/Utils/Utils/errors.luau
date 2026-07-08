local ParentParent = script.Parent.Parent

require(ParentParent.LuauPolyfill)

local t1 = {}
local GraphQL = require(ParentParent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
local versionInfo = GraphQL.versionInfo

require(script.Parent.types)

local function createGraphQLError(s1: string, t2: {[any]: any}?) -- line: 37
	-- upvalues: versionInfo (copy), GraphQLError (copy)
	if versionInfo.major >= 17 then
		return GraphQLError.new(s1, t2)
	end

	return GraphQLError.new(s1, if typeof(t2) ~= "table" then nil else t2.nodes, if typeof(t2) ~= "table" then nil else t2.source, if typeof(t2) ~= "table" then nil else t2.positions, if typeof(t2) ~= "table" then nil else t2.path, if typeof(t2) ~= "table" then nil else t2.originalError, if typeof(t2) ~= "table" then nil else t2.extensions)
end

t1.createGraphQLError = createGraphQLError

function t1.relocatedError(p1, p2) -- line: 55
	-- upvalues: createGraphQLError (copy)
	return createGraphQLError(p1.message, {
		nodes = p1.nodes,
		source = p1.source,
		positions = p1.positions,
		path = if p2 ~= nil then p2 else p1.path,
		originalError = p1,
		extensions = p1.extensions
	})
end

return t1
