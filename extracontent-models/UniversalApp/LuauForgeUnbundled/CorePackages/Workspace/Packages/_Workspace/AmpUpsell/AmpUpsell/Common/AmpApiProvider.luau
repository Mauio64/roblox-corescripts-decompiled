local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UrlBuilder").UrlBase
local Fetch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Fetch")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Promise")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/SharedFlags")

local fetch = Fetch.fetch
local response = Fetch.Response
local accessResponseEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums").AccessResponseEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")
local gql = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/ApolloClient").gql
local base64 = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AuthCommon").Utils.Base64
local GetFFlagAmpGqlPassSuccessfulActions = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagAmpGqlPassSuccessfulActions")
local fFlagAllowAmpV2FeatureAccessCall = SharedFlags.FFlagAllowAmpV2FeatureAccessCall

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "access-management/v1/upsell-feature-access",
	query = {
		{ name = "featureName", value = "{featureName}", optional = false },
		{ name = "successfulActions", value = "{successfulActions}", optional = false },
		{ name = "nameSpace", value = "{nameSpace}", optional = true },
		{ name = "extraParameters", value = "{extraParameters}", optional = true }
	}
})

local v6 = urlBuilder.new({
	base = urlBase.APIS,
	path = "access-management/v1/feature-access",
	query = fFlagAllowAmpV2FeatureAccessCall and {
		featureNames = "{featureNames}",
		nameSpace = "{nameSpace}"
	} or { featureNames = "{featureNames}" }
})

local function getUpsellFeatureAccessFromFeatureName(p2, list, p3, p4)
	local v7 = fetch
	return Promise.new(function(callback, callback2)
		local expect = v7(
			v5({
				featureName = p2,
				successfulActions = table.concat(list, ","),
				nameSpace = p3,
				extraParameters = p4
			}),
			{ method = "GET" }
		):catch(function()
			return response.error()
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

return {
	upsellFeatureAccess = function(p2, list, p3, p4)
		local encoded = if p4 then base64.Encode(HttpService:JSONEncode(p4)) else nil
		local v7 = fetch
		return (Promise.new(function(callback, callback2)
			local expect = v7(
				v5({
					featureName = p2,
					successfulActions = table.concat(list, ","),
					nameSpace = p3,
					extraParameters = encoded
				}),
				{ method = "GET" }
			):catch(function()
				return response.error()
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
		end):catch(function(p5)
			return { access = accessResponseEnum.Error }
		end):expect())
	end,
	upsellFeatureAccessGql = function(object, p2, p3, p4, p5)
		local v7 = gql(require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/GetUpsellFeatureAccess"))

		local v8 = if p5 then base64.Encode(HttpService:JSONEncode(p5)) else nil

		local expect = object:query({
			query = v7,
			variables = {
				featureName = p2,
				successfulActions = not GetFFlagAmpGqlPassSuccessfulActions() and {} or p3,
				nameSpace = p4,
				extraParameters = v8
			},
			fetchPolicy = "network-only"
		}):catch(function(p6)
			return { access = accessResponseEnum.Error }
		end):expect()

		if expect.data and expect.data.getUpsellFeatureAccess.featureAccess then
			return expect.data.getUpsellFeatureAccess.featureAccess
		end

		return { access = accessResponseEnum.Error }
	end,
	getFeatureAccess = function(list, p2)
		local v7 = fetch
		return (Promise.new(function(callback, callback2)
			local joined = table.concat(list, ",")
			local v8

			if fFlagAllowAmpV2FeatureAccessCall then
				v8 = v6({
					featureNames = joined,
					nameSpace = not p2 and "" or p2
				})
			else
				v8 = v6({ featureNames = joined })
			end

			local expect = v7(v8, { method = "GET" }):catch(function()
				return response.error()
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

			local v9 = {}

			for k, feature in expect2.features do
				table.insert(v9, {
					feature = feature.featureName,
					access = feature.access
				})
			end

			callback({ featureAccessList = v9 })
		end):catch(function(p3)
			return { access = accessResponseEnum.Error }
		end):expect())
	end
}
