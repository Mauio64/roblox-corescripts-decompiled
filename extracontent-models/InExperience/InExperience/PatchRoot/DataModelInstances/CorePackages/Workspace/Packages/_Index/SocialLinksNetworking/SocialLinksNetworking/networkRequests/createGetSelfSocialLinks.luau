local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("GetSelfSocialLinks", function(callback, p2)
		return callback(API_URL):path("v1"):path("promotion-channels"):queryArgs({
			alwaysReturnUrls = p2.alwaysReturnUrls,
			filterLink = p2.filterLink
		})
	end)
end
