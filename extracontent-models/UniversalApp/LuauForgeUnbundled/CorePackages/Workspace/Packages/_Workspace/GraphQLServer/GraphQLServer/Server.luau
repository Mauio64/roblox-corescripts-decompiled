local HttpService = game:GetService("HttpService")

local GraphQL = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local object = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill").Object

local fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch").fetch
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/DataLoader")

local Response = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/Response")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql")
local typeDefs = module4.typeDefs

local resolvers = module4.resolvers
local dataLoaders = module4.dataLoaders

local buildTypeResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/schemaUtils/buildTypeResolver")
local buildRootValue = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/schemaUtils/buildRootValue")
local buildFieldResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/schemaUtils/buildFieldResolver")
local addMockResolvers = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/schemaUtils/addMockResolvers")

local getFFlagUserProfilesDataLoaderEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/SharedFlags").getFFlagUserProfilesDataLoaderEnabled

local class = {}
class.__index = class

function class.new(data)
	local v5 = {}
	v5.port = not data.port and 4000 or data.port
	local success, result

	if data.typeDefs then
		success = false
	else
		success, result = pcall(function()
			return require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/compiled_schema")
		end)
	end

	if success and result then
		v5.schema = GraphQL.buildASTSchema(result, {
			assumeValid = true,
			assumeValidSDL = true
		})
	else
		local v6 = if data.typeDefs then data.typeDefs else typeDefs
		v5.schema = GraphQL.buildSchema(v6)
	end

	local v6 = if data.resolvers then data.resolvers else resolvers

	if type(data.mockResolvers) == "table" then
		v6 = addMockResolvers(v6, data.mockResolvers)
	end

	v5.rootValue = buildRootValue(v6)
	v5.typeResolver = buildTypeResolver(v6)
	v5.fieldResolver = buildFieldResolver(v6)
	local v7 = if data.fetchImpl then data.fetchImpl else fetch
	v5.fetchImpl = v7

	if getFFlagUserProfilesDataLoaderEnabled() then
		v5.clientLoaders = object.assign(
			{},
			{
				userProfiles = dataLoaders.userProfilesDataLoader.new()
			},
			data.dataLoaderInitializers or {}
		)
	end

	setmetatable(v5, class)
	return v5
end

function class:fetchLocal(p2)
	local v5 = not p2 and {} or HttpService:JSONDecode(p2.body)

	local v6 = {}
	return Promise.new(function(callback, p3)
		local graphql = GraphQL.graphql
		local v7 = {
			schema = self.schema,
			source = v5.query or v5.mutation,
			rootValue = self.rootValue,
			contextValue = 0,
			typeResolver = 0,
			fieldResolver = 0,
			variableValues = 0
		}
		local v8 = { fetchImpl = self.fetchImpl, dataLoaders = 0 }
		local v9 = if getFFlagUserProfilesDataLoaderEnabled() then object.assign({}, v6, self.clientLoaders) else v6
		v8.dataLoaders = v9
		v7.contextValue = v8

		v7.typeResolver = self.typeResolver
		v7.fieldResolver = self.fieldResolver
		v7.variableValues = v5.variables
		graphql(v7):andThen(function(p4)
			callback(Response.new(p4))
		end)
	end)
end

return class
