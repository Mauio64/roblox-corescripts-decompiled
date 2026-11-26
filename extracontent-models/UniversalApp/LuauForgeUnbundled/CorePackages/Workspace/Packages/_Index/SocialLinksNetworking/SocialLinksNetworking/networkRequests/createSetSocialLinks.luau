local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/SocialLinksNetworking/SocialLinksNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.POST("SetSocialLinks", function(callback, data)
		return callback(API_URL):path("v1"):path("promotion-channels"):body({
			promotionChannelsVisibilityPrivacy = data.promotionChannelsVisibilityPrivacy,
			facebook = data.facebook,
			twitter = data.twitter,
			youtube = data.youtube,
			twitch = data.twitch,
			guilded = data.guilded
		})
	end)
end
