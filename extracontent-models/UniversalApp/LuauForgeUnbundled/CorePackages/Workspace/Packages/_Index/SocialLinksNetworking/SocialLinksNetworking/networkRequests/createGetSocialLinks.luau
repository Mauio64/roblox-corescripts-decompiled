local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/SocialLinksNetworking/SocialLinksNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.GET("GetSocialLinks", function(callback, data)
		return callback(API_URL):path("v1"):path("users"):id(data.userId):path("promotion-channels"):queryArgs({
			alwaysReturnUrls = data.alwaysReturnUrls,
			filterLink = data.filterLink
		})
	end)
end
