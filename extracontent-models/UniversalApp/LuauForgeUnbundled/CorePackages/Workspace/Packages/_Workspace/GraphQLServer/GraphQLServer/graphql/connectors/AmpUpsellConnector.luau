local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/UrlBuilder").UrlBase
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Promise")
local graphQLError = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQL").GraphQLError
require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/Fetch")
local fetch = Fetch.fetch
local response = Fetch.Response

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "access-management/v1/feature-access",
	query = { featureNames = "{featureNames}" }
})
local v5 = {}

function v5.getFeatureAccessFromFeatureNamesList(list, p2)
	local v7 = p2 or fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(v6({ featureNames = table.concat(list, ",") }), {
			method = "GET"
		}):catch(function()
			return response.error()
		end):expect()

		if expect.status == 304 then
			callback2(graphQLError.new("Got Response: 304, using cached data instead"))
			return
		end

		if not expect.ok then
			callback2(graphQLError.new("Failed to find feature access values"))
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2(graphQLError.new("Failed to decode HTTP response as JSON for AMP Feature Access API"))
			return
		end

		local v9 = {}

		for k, feature in expect2.features do
			table.insert(v9, {
				featureName = feature.featureName,
				access = feature.access
			})
		end

		callback({ features = v9 })
	end)
end

local v7 = urlBuilder.new({
	base = urlBase.APIS,
	path = "access-management/v1/upsell-feature-access",
	query = {
		{ name = "featureName", value = "{featureName}", optional = false },
		{ name = "successfulActions", value = "{successfulActions}", optional = false },
		{ name = "nameSpace", value = "{nameSpace}", optional = true },
		{ name = "extraParameters", value = "{extraParameters}", optional = true }
	}
})

function v5.getUpsellFeatureAccessFromFeatureName(p2, list, p3, p4, p5)
	local v8 = p3 or fetch
	return Promise.new(function(callback, callback2)
		local expect = v8(
			v7({
				featureName = p2,
				successfulActions = table.concat(list, ","),
				nameSpace = p4,
				extraParameters = p5
			}),
			{ method = "GET" }
		):catch(function()
			return response.error()
		end):expect()

		if expect.status == 304 then
			callback2(graphQLError.new("Got Response: 304, using cached data instead"))
			return
		end

		if not expect.ok then
			callback2(graphQLError.new("Failed to find upsell feature access values"))
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
			callback2(graphQLError.new("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API"))
		end
	end)
end

return v5
