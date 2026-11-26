local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQlShared/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQlShared/Http").Url
local HttpService = game:GetService("HttpService")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQlShared/DiscoveryUtils")

local fFlagEnableContextFeaturesForOmniRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQlShared/SharedFlags").FFlagEnableContextFeaturesForOmniRecommendations
local getFFlagHomePYMKUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQlShared/SharedFlags").GetFFlagHomePYMKUseProfileFrameThumbnail
local addSystemInfoToArgs = DiscoveryUtils.AddSystemInfoToArgs
local omniRecommendationsPageType = DiscoveryUtils.OmniRecommendationsPageType

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "/discovery-api/omni-recommendation"
})

return function(callback, p2, p3, p4, p5, p6, p7, p8, contextFeatures, includePymkSortProfileFrame)
	local v6 = {
		["pageType"] = omniRecommendationsPageType.fromAppPage(p2),
		sessionId = p3,
		pageToken = p4,
		supportedTreatmentTypes = p5,
		requestIntent = p6,
		topicIds = p7,
		sduiTreatmentTypes = p8
	}

	if fFlagEnableContextFeaturesForOmniRecommendations and contextFeatures then
		v6.contextFeatures = contextFeatures
	end

	if getFFlagHomePYMKUseProfileFrameThumbnail() and includePymkSortProfileFrame then
		v6.includePymkSortProfileFrame = includePymkSortProfileFrame
	end

	addSystemInfoToArgs(v6)

	return callback(v5(), "POST", { postBody = HttpService:JSONEncode(v6) })
end
