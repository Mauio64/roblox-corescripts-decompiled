local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/SocialLinksNetworking/SocialLinksNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.GET("GetSelfSocialLinks", function(callback, p3)
		return callback(API_URL):path("v1"):path("promotion-channels"):queryArgs({
			alwaysReturnUrls = p3.alwaysReturnUrls,
			filterLink = p3.filterLink
		})
	end)
end
