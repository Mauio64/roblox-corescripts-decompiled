local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local SharedFlags = require(parent.SharedFlags)
local GetFStringEdpPlayerFeedbackServiceRoute = SharedFlags.GetFStringEdpPlayerFeedbackServiceRoute

local _ = { ExperienceDiscoveryPage = "experience-discovery-page" }

return {
	USER_VOTE_FEEDBACK_METADATA_URL = urlBuilder.new({
		base = Url.APIS_URL,
		path = "{serviceRoute}/v1/channels/{channel}/assets"
	})({
		serviceRoute = GetFStringEdpPlayerFeedbackServiceRoute(),
		channel = "experience-discovery-page"
	}),
	buildUserVoteFeedbackMetadataUrl = function(rootPlaceId: string)
		return urlBuilder.new({
			base = Url.APIS_URL,
			path = "{serviceRoute}/v1/channels/{channel}/assets/{rootPlaceId}"
		})({
			serviceRoute = GetFStringEdpPlayerFeedbackServiceRoute(),
			channel = "experience-discovery-page",
			rootPlaceId = rootPlaceId
		})
	end
}
