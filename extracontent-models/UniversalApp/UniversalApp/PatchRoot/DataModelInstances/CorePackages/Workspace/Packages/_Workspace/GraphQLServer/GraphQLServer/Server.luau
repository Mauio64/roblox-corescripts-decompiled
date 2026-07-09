local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("GraphQLServer").Parent
local GraphQL = require(Parent.GraphQL)
local Promise = require(Parent.Promise)
local Object = require(Parent.LuauPolyfill).Object
local fetch = require(Parent.Fetch).fetch

require(Parent.DataLoader)

local Response = require(script.Parent.Response)
local graphql = require(script.Parent.graphql)
local typeDefs = graphql.typeDefs
local resolvers = graphql.resolvers
local dataLoaders = graphql.dataLoaders
local buildTypeResolver = require(script.Parent.schemaUtils.buildTypeResolver)
local buildRootValue = require(script.Parent.schemaUtils.buildRootValue)
local buildFieldResolver = require(script.Parent.schemaUtils.buildFieldResolver)
local addMockResolvers = require(script.Parent.schemaUtils.addMockResolvers)
local getFFlagUserProfilesDataLoaderEnabled = require(Parent.SharedFlags).getFFlagUserProfilesDataLoaderEnabled
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 71
	-- upvalues: GraphQL (copy), typeDefs (copy), resolvers (copy), addMockResolvers (copy), buildRootValue (copy), buildTypeResolver (copy), buildFieldResolver (copy), fetch (copy), getFFlagUserProfilesDataLoaderEnabled (copy), Object (copy), dataLoaders (copy), t1 (copy)
	local t3 = {
		port = not t2.port and 4000 or t2.port
	}
	local v20 = false
	local result = nil

	if not t2.typeDefs then
		v20, result = pcall(function() -- line: 78
			return require(script.Parent.compiled_schema)
		end)
	end

	if v20 and result then
		t3.schema = GraphQL.buildASTSchema(result, {
			assumeValid = true,
			assumeValidSDL = true
		})
	else
		local v22 = if not t2.typeDefs then typeDefs else t2.typeDefs

		t3.schema = GraphQL.buildSchema(v22)
	end

	local v23 = if not t2.resolvers then resolvers else t2.resolvers

	if type(t2.mockResolvers) == "table" then
		v23 = addMockResolvers(v23, t2.mockResolvers)
	end

	t3.rootValue = buildRootValue(v23)
	t3.typeResolver = buildTypeResolver(v23)
	t3.fieldResolver = buildFieldResolver(v23)
	t3.fetchImpl = if not t2.fetchImpl then fetch else t2.fetchImpl

	if getFFlagUserProfilesDataLoaderEnabled() then
		t3.clientLoaders = Object.assign({}, {
			userProfiles = dataLoaders.userProfilesDataLoader.new()
		}, t2.dataLoaderInitializers or {})
	end

	setmetatable(t3, t1)

	return t3
end
function t1.fetchLocal(t4: {[any]: any}, t5: {[any]: any}) -- line: 115
	-- upvalues: HttpService (copy), Promise (copy), GraphQL (copy), getFFlagUserProfilesDataLoaderEnabled (copy), Object (copy), Response (copy)
	local v26 = if not t5 then {} else HttpService:JSONDecode(t5.body)
	local t6 = {}

	return Promise.new(function(resolve, _) -- line: 119
		-- upvalues: GraphQL (copy), t4 (copy), v26 (copy), getFFlagUserProfilesDataLoaderEnabled (copy), Object (copy), t6 (copy), Response (copy)
		GraphQL.graphql({
			schema = t4.schema,
			source = v26.query or v26.mutation,
			rootValue = t4.rootValue,
			contextValue = {
				fetchImpl = t4.fetchImpl,
				dataLoaders = if not getFFlagUserProfilesDataLoaderEnabled() then t6 else Object.assign({}, t6, t4.clientLoaders)
			},
			typeResolver = t4.typeResolver,
			fieldResolver = t4.fieldResolver,
			variableValues = v26.variables
		}):andThen(function(p2) -- line: 133
			-- upvalues: resolve (copy), Response (copy)
			resolve(Response.new(p2))
		end)
	end)
end

return t1
