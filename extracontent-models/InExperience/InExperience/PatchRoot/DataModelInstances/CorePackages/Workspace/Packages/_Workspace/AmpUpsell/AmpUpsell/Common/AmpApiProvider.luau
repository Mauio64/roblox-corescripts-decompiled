local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local HttpService = game:GetService("HttpService")

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase
local Fetch = require(parent.Fetch)
local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)

local fetch = Fetch.fetch
local Response = Fetch.Response
local Enums = require(AmpUpsell.Common.Enums)
local AccessResponseEnum = Enums.AccessResponseEnum
require(AmpUpsell.Common.Types)
local ApolloClient = require(parent.ApolloClient)
local gql = ApolloClient.gql
local AuthCommon = require(parent.AuthCommon)
local Base64 = AuthCommon.Utils.Base64
local GetFFlagAmpGqlPassSuccessfulActions = require(AmpUpsell.Flags.GetFFlagAmpGqlPassSuccessfulActions)
local FFlagAllowAmpV2FeatureAccessCall = SharedFlags.FFlagAllowAmpV2FeatureAccessCall

local v = urlBuilder.new({
	base = UrlBase.APIS,
	path = "access-management/v1/upsell-feature-access",
	query = {
		{ name = "featureName", value = "{featureName}", optional = false },
		{ name = "successfulActions", value = "{successfulActions}", optional = false },
		{ name = "nameSpace", value = "{nameSpace}", optional = true },
		{ name = "extraParameters", value = "{extraParameters}", optional = true }
	}
})

local v2 = urlBuilder.new({
	base = UrlBase.APIS,
	path = "access-management/v1/feature-access",
	query = FFlagAllowAmpV2FeatureAccessCall and {
		featureNames = "{featureNames}",
		nameSpace = "{nameSpace}"
	} or { featureNames = "{featureNames}" }
})

local function getUpsellFeatureAccessFromFeatureName(featureName: string, list, nameSpace: string?, extraParameters: string?) -- 1 equivalent call inferred from this helper
	local fetch2 = fetch
	return Promise.new(function(callback, callback2)
		local expect = fetch2(
			v({
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
			callback2("Got Response: 304")
			return
		end

		if not expect.ok then
			callback2("Failed to find upsell feature access values")
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if expect2 then
			callback({
				access = expect2.access,
				recourse = expect2.recourse,
				recourses = expect2.recourses,
				shouldPrompt = expect2.shouldPrompt
			})
		else
			callback2("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API")
		end
	end)
end

local AmpApiProvider = {}

function AmpApiProvider.upsellFeatureAccess(featureName: string, list, nameSpace: string?, p)
	local v3

	if p then
		v3 = Base64.Encode(HttpService:JSONEncode(p))
	end

	return (getUpsellFeatureAccessFromFeatureName(featureName, list, nameSpace, v3):catch(function(_) -- inferred equivalent call
		return { access = AccessResponseEnum.Error }
	end):expect())
end

function AmpApiProvider.upsellFeatureAccessGql(object, featureName: string, p, nameSpace: string?, p2)
	local query = gql(require(script.Parent.GetUpsellFeatureAccess))
	local extraParameters

	if p2 then
		extraParameters = Base64.Encode(HttpService:JSONEncode(p2))
	end

	local expect = object:query({
		query = query,
		variables = {
			featureName = featureName,
			successfulActions = not GetFFlagAmpGqlPassSuccessfulActions() and {} or p,
			nameSpace = nameSpace,
			extraParameters = extraParameters
		},
		fetchPolicy = "network-only"
	}):catch(function(_)
		return { access = AccessResponseEnum.Error }
	end):expect()

	if expect.data and expect.data.getUpsellFeatureAccess.featureAccess then
		return expect.data.getUpsellFeatureAccess.featureAccess
	end

	return { access = AccessResponseEnum.Error }
end

function AmpApiProvider.getFeatureAccess(list, p: string?)
	local fetch2 = fetch
	return (Promise.new(function(callback, callback2)
		local joined = table.concat(list, ",")
		local v3

		if FFlagAllowAmpV2FeatureAccessCall then
			v3 = v2({
				featureNames = joined,
				nameSpace = not p and "" or p
			})
		else
			v3 = v2({ featureNames = joined })
		end

		local expect = fetch2(v3, { method = "GET" }):catch(function()
			return Response.error()
		end):expect()

		if expect.status == 304 then
			callback2("Got Response: 304")
			return
		end

		if not expect.ok then
			callback2("Failed to find get feature access values")
			return
		end

		local expect2 = expect:json():catch(function(): nil
			return nil
		end):expect()

		if not expect2 then
			callback2("Failed to decode HTTP response as JSON for AMP Upsell Feature Access API")
			return
		end

		local featureAccessList = {}

		for _, feature in expect2.features do
			table.insert(featureAccessList, {
				feature = feature.featureName,
				access = feature.access
			})
		end

		callback({ featureAccessList = featureAccessList })
	end):catch(function(_)
		return { access = AccessResponseEnum.Error }
	end):expect())
end

return AmpApiProvider
