local Parent = script:FindFirstAncestor("DataHydration").Parent
local Url = require(Parent.Http).Url
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local GetFStringEdpPlayerFeedbackServiceRoute = require(Parent.SharedFlags).GetFStringEdpPlayerFeedbackServiceRoute
local _ = {
	ExperienceDiscoveryPage = "experience-discovery-page"
}

return {
	USER_VOTE_FEEDBACK_METADATA_URL = UrlBuilder.new({
		path = "{serviceRoute}/v1/channels/{channel}/assets",
		base = Url.APIS_URL
	})({
		channel = "experience-discovery-page",
		serviceRoute = GetFStringEdpPlayerFeedbackServiceRoute()
	}),
	buildUserVoteFeedbackMetadataUrl = function(s1: string) -- line: 22
		-- upvalues: UrlBuilder (copy), Url (copy), GetFStringEdpPlayerFeedbackServiceRoute (copy)
		return UrlBuilder.new({
			path = "{serviceRoute}/v1/channels/{channel}/assets/{rootPlaceId}",
			base = Url.APIS_URL
		})({
			channel = "experience-discovery-page",
			serviceRoute = GetFStringEdpPlayerFeedbackServiceRoute(),
			rootPlaceId = s1
		})
	end
}
