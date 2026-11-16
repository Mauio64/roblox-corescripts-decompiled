local GraphQLServer = script:FindFirstAncestor("GraphQLServer")

local UrlBuilder = require(GraphQLServer.Parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(GraphQLServer.Parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
require(GraphQLServer.Parent.LuauPolyfill)
local Promise = require(GraphQLServer.Parent.Promise)
local GraphQL = require(GraphQLServer.Parent.GraphQL)
local GraphQLError = GraphQL.GraphQLError
require(GraphQLServer.graphql.generatedTypes)
local Fetch = require(GraphQLServer.Parent.Fetch)
local fetch = Fetch.fetch
local Response = Fetch.Response

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "access-management/v1/feature-access",
	query = { featureNames = "{featureNames}" }
})
local AmpUpsellConnector = {}

function AmpUpsellConnector.getFeatureAccessFromFeatureNamesList(list, p)
	local v2 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v2(v({ featureNames = table.concat(list, ",") }), { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if expect.status == 304 then
			callback2(GraphQLError.new("Got Response: 304, using cached data instead"))
			return
		end

		if not expect.ok then
			callback2(GraphQLError.new("Failed to find feature access values"))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(GraphQLError.new("Failed to decode HTTP response as JSON for AMP Feature Access API"))
			return
		end

		local features = {}

		for _, feature in expect2.features do
			table.insert(features, { featureName = feature.featureName, access = feature.access })
		end

		callback({ features = features })
	end)
end

local v2 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "access-management/v1/upsell-feature-access",
	query = {
		{ name = "featureName", value = "{featureName}", optional = false },
		{ name = "successfulActions", value = "{successfulActions}", optional = false },
		{ name = "nameSpace", value = "{nameSpace}", optional = true },
		{ name = "extraParameters", value = "{extraParameters}", optional = true }
	}
})

function AmpUpsellConnector.getUpsellFeatureAccessFromFeatureName(featureName: string, list, p, nameSpace: string?, extraParameters: string?)
	local v3 = p or fetch
	return Promise.new(function(callback, callback2)
		local expect = v3(
			v2({
				featureName = featureName,
				successfulActions = table.concat(list, ","),
				nameSpace = nameSpace,
				extraParameters = extraParameters
			}),
			{ method = "GET" }
		):catch(function()
			return Response.error()
		end):expect()

		if expect.status == 304 then
			callback2(GraphQLError.new("Got Response: 304, using cached data instead"))
			return
		end

		if not expect.ok then
			callback2(GraphQLError.new("Failed to find upsell feature access values"))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback({
				featureName = expect2.featureName,
				access = expect2.access,
				recourse = expect2.recourse,
				recourses = expect2.recourses,
				shouldPrompt = expect2.shouldPrompt
			})
		else
			callback2(GraphQLError.new("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API"))
		end
	end)
end

return AmpUpsellConnector
