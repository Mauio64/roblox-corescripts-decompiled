local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.POST("SetSocialLinks", function(callback, data)
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
