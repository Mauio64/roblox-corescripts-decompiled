local Parent = script:FindFirstAncestor("GraphQlShared").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local HttpService = game:GetService("HttpService")
local DiscoveryUtils = require(Parent.DiscoveryUtils)
local FFlagEnableContextFeaturesForOmniRecommendations = require(Parent.SharedFlags).FFlagEnableContextFeaturesForOmniRecommendations
local AddSystemInfoToArgs = DiscoveryUtils.AddSystemInfoToArgs
local OmniRecommendationsPageType = DiscoveryUtils.OmniRecommendationsPageType
local v9 = UrlBuilder.new({
	path = "/discovery-api/omni-recommendation",
	base = Url.APIS_URL
})

return function(p1, p2, p3, p4, p5, p6, p7, p8, p9) -- line: 54
	-- upvalues: OmniRecommendationsPageType (copy), FFlagEnableContextFeaturesForOmniRecommendations (copy), AddSystemInfoToArgs (copy), v9 (copy), HttpService (copy)
	local t1 = {
		pageType = OmniRecommendationsPageType.fromAppPage(p2),
		sessionId = p3,
		pageToken = p4,
		supportedTreatmentTypes = p5,
		requestIntent = p6,
		topicIds = p7,
		sduiTreatmentTypes = p8
	}

	if FFlagEnableContextFeaturesForOmniRecommendations and p9 then
		t1.contextFeatures = p9
	end

	AddSystemInfoToArgs(t1)

	return p1(v9(), "POST", {
		postBody = HttpService:JSONEncode(t1)
	})
end
