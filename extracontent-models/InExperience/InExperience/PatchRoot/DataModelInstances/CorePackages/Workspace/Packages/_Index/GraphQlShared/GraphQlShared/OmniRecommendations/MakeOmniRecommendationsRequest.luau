local parent = script:FindFirstAncestor("GraphQlShared").Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local HttpService = game:GetService("HttpService")
local DiscoveryUtils = require(parent.DiscoveryUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableContextFeaturesForOmniRecommendations = SharedFlags.FFlagEnableContextFeaturesForOmniRecommendations
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagHomePYMKUseProfileFrameThumbnail = SharedFlags2.GetFFlagHomePYMKUseProfileFrameThumbnail
local AddSystemInfoToArgs = DiscoveryUtils.AddSystemInfoToArgs
local OmniRecommendationsPageType = DiscoveryUtils.OmniRecommendationsPageType

local v = urlBuilder.new({ base = Url.APIS_URL, path = "/discovery-api/omni-recommendation" })

return function(callback, p, sessionId, pageToken, supportedTreatmentTypes, requestIntent, topicIds, sduiTreatmentTypes, contextFeatures, includePymkSortProfileFrame)
	local v2 = {
		["pageType"] = OmniRecommendationsPageType.fromAppPage(p),
		sessionId = sessionId,
		pageToken = pageToken,
		supportedTreatmentTypes = supportedTreatmentTypes,
		requestIntent = requestIntent,
		topicIds = topicIds,
		sduiTreatmentTypes = sduiTreatmentTypes
	}

	if FFlagEnableContextFeaturesForOmniRecommendations and contextFeatures then
		v2.contextFeatures = contextFeatures
	end

	if GetFFlagHomePYMKUseProfileFrameThumbnail() and includePymkSortProfileFrame then
		v2.includePymkSortProfileFrame = includePymkSortProfileFrame
	end

	AddSystemInfoToArgs(v2)

	return callback(v(), "POST", { postBody = HttpService:JSONEncode(v2) })
end
