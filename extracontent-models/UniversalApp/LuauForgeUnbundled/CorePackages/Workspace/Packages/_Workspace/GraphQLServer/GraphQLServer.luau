local Server = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/Server")
local graphql = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql")
local generatedTypes = graphql.generatedTypes
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/ApolloClientTestUtils")

return {
	GraphQLServer = Server,
	types = generatedTypes,
	mocks = graphql.mocks,
	ApolloClientTestUtils = module3,
	generateTypeDefs = graphql.generateTypeDefs,
	enums = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/enums")
}
