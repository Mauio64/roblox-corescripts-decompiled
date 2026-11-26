local mergeTypeDefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Merge").mergeTypeDefs
local GraphQL = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/resolvers")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")
local luaTypeDefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/luaTypeDefs")
return {
	typeDefs = "",
	generateTypeDefs = function()
		local v5 = mergeTypeDefs(luaTypeDefs)
		return (GraphQL.print(v5))
	end,
	resolvers = module2,
	generatedTypes = module3,
	dataLoaders = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/dataLoaders"),
	mocks = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/mocks")
}
