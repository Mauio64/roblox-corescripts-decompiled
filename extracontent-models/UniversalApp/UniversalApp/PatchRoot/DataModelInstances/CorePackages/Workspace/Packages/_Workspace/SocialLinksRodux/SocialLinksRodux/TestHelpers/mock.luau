local Parent = script:FindFirstAncestor("SocialLinksRodux").Parent
local Rodux = require(Parent.Rodux)
local v3 = Rodux.makeActionCreator("SOCIAL_LINKS_SUCCEEDED", function() -- line: 6
	return {
		namedIds = {
			users = "123"
		},
		responseBody = {
			facebook = "facebookUrl",
			twitter = "twitterUrl",
			youtube = "youtubeUrl",
			twitch = "twitchUrl",
			guilded = nil
		},
		queryArgs = {
			alwaysReturnUrls = true
		}
	}
end)
local v4 = Rodux.makeActionCreator("SELF_SOCIAL_LINKS_SUCCEEDED", function() -- line: 25
	return {
		responseBody = {
			promotionChannelsVisibilityPrivacy = "NoOne",
			facebook = "url",
			twitter = "url",
			youtube = "url",
			twitch = "url",
			guilded = nil
		}
	}
end)

return {
	mockGetSocialLinks = "SOCIAL_LINKS_SUCCEEDED",
	mockGetSelfSocialLinks = "SELF_SOCIAL_LINKS_SUCCEEDED",
	mockGetSocialLinksAction = v3,
	mockGetSelfSocialLinksAction = v4
}
