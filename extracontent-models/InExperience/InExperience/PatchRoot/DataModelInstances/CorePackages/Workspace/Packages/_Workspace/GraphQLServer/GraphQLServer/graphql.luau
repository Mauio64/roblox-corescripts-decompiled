local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local mergeTypeDefs = require(Parent.GraphqlToolsMerge).mergeTypeDefs
local GraphQL = require(Parent.GraphQL)
local resolvers = require(script.resolvers)
local generatedTypes = require(script.generatedTypes)
local luaTypeDefs = require(script.luaTypeDefs)
local dataLoaders = require(script.dataLoaders)
local mocks = require(script.mocks)

return {
	typeDefs = "",
	generateTypeDefs = function() -- line: 35
		-- upvalues: mergeTypeDefs (copy), luaTypeDefs (copy), GraphQL (copy)
		local v9 = mergeTypeDefs(luaTypeDefs)

		return (GraphQL.print(v9))
	end,
	resolvers = resolvers,
	generatedTypes = generatedTypes,
	dataLoaders = dataLoaders,
	mocks = mocks
}
