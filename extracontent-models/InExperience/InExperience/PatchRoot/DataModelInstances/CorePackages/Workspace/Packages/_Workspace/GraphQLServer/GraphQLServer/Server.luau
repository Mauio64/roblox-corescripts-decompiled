local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("GraphQLServer").Parent
local GraphQL = require(parent.GraphQL)

local Promise = require(parent.Promise)
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local Fetch = require(parent.Fetch)

local fetch = Fetch.fetch
require(parent.DataLoader)

local Response = require(script.Parent.Response)
local graphql = require(script.Parent.graphql)
local typeDefs = graphql.typeDefs

local resolvers = graphql.resolvers
local dataLoaders = graphql.dataLoaders

local buildTypeResolver = require(script.Parent.schemaUtils.buildTypeResolver)
local buildRootValue = require(script.Parent.schemaUtils.buildRootValue)
local buildFieldResolver = require(script.Parent.schemaUtils.buildFieldResolver)
local addMockResolvers = require(script.Parent.schemaUtils.addMockResolvers)

local SharedFlags = require(parent.SharedFlags)
local getFFlagUserProfilesDataLoaderEnabled = SharedFlags.getFFlagUserProfilesDataLoaderEnabled

local class = {}
class.__index = class

function class.new(data)
	local v = {}
	v.port = not data.port and 4000 or data.port
	local success, result

	if data.typeDefs then
		success = false
	else
		success, result = pcall(function()
			return require(script.Parent.compiled_schema)
		end)
	end

	if success and result then
		v.schema = GraphQL.buildASTSchema(result, { assumeValid = true, assumeValidSDL = true })
	else
		local v2 = if data.typeDefs then data.typeDefs else typeDefs
		v.schema = GraphQL.buildSchema(v2)
	end

	local v2 = if data.resolvers then data.resolvers else resolvers

	if type(data.mockResolvers) == "table" then
		v2 = addMockResolvers(v2, data.mockResolvers)
	end

	v.rootValue = buildRootValue(v2)
	v.typeResolver = buildTypeResolver(v2)
	v.fieldResolver = buildFieldResolver(v2)
	local fetchImpl = if data.fetchImpl then data.fetchImpl else fetch
	v.fetchImpl = fetchImpl

	if getFFlagUserProfilesDataLoaderEnabled() then
		v.clientLoaders = Object.assign(
			{},
			{
				userProfiles = dataLoaders.userProfilesDataLoader.new()
			},
			data.dataLoaderInitializers or {}
		)
	end

	setmetatable(v, class)
	return v
end

function class.fetchLocal(data, p)
	local v = not p and {} or HttpService:JSONDecode(p.body)

	local v2 = {}
	return Promise.new(function(callback, _)
		local graphql2 = GraphQL.graphql
		local v3 = {
			schema = data.schema,
			source = v.query or v.mutation,
			rootValue = data.rootValue,
			contextValue = 0,
			typeResolver = 0,
			fieldResolver = 0,
			variableValues = 0
		}
		local contextValue = { fetchImpl = data.fetchImpl, dataLoaders = 0 }
		local dataLoaders2

		if getFFlagUserProfilesDataLoaderEnabled() then
			dataLoaders2 = Object.assign({}, v2, data.clientLoaders)
		else
			dataLoaders2 = v2
		end

		contextValue.dataLoaders = dataLoaders2
		v3.contextValue = contextValue

		v3.typeResolver = data.typeResolver
		v3.fieldResolver = data.fieldResolver
		v3.variableValues = v.variables
		graphql2(v3):andThen(function(p2)
			callback(Response.new(p2))
		end)
	end)
end

return class
