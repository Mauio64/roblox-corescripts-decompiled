local parent = script:FindFirstAncestor("GraphQLServer").Parent
local GraphqlToolsMerge = require(parent.GraphqlToolsMerge)
local mergeTypeDefs = GraphqlToolsMerge.mergeTypeDefs
local GraphQL = require(parent.GraphQL)

local resolvers = require(script.resolvers)
local generatedTypes = require(script.generatedTypes)
local luaTypeDefs = require(script.luaTypeDefs)
return {
	typeDefs = "",
	generateTypeDefs = function()
		local v = mergeTypeDefs(luaTypeDefs)
		return (GraphQL.print(v))
	end,
	resolvers = resolvers,
	generatedTypes = generatedTypes,
	dataLoaders = require(script.dataLoaders),
	mocks = require(script.mocks)
}
