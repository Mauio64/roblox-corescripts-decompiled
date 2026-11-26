local url = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBuilder

local getFStringEdpPlayerFeedbackServiceRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").GetFStringEdpPlayerFeedbackServiceRoute

local v5 = { ExperienceDiscoveryPage = "experience-discovery-page" }

return {
	USER_VOTE_FEEDBACK_METADATA_URL = urlBuilder.new({
		base = url.APIS_URL,
		path = "{serviceRoute}/v1/channels/{channel}/assets"
	})({
		serviceRoute = getFStringEdpPlayerFeedbackServiceRoute(),
		channel = "experience-discovery-page"
	}),
	buildUserVoteFeedbackMetadataUrl = function(p2)
		return urlBuilder.new({
			base = url.APIS_URL,
			path = "{serviceRoute}/v1/channels/{channel}/assets/{rootPlaceId}"
		})({
			serviceRoute = getFStringEdpPlayerFeedbackServiceRoute(),
			channel = "experience-discovery-page",
			rootPlaceId = p2
		})
	end
}
