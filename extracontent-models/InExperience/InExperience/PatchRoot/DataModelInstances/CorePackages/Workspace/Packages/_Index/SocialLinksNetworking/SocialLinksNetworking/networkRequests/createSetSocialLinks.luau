local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "SetSocialLinks"
	}, function(p1, t2: {[any]: any}) -- line: 20
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("v1"):path("promotion-channels"):body({
			promotionChannelsVisibilityPrivacy = t2.promotionChannelsVisibilityPrivacy,
			facebook = t2.facebook,
			twitter = t2.twitter,
			youtube = t2.youtube,
			twitch = t2.twitch,
			guilded = t2.guilded
		})
	end)
end
