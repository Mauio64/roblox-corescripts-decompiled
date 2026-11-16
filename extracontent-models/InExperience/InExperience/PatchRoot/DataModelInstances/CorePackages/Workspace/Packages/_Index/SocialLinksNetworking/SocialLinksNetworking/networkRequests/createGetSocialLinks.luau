local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("GetSocialLinks", function(callback, data)
		return callback(API_URL):path("v1"):path("users"):id(data.userId):path("promotion-channels"):queryArgs({
			alwaysReturnUrls = data.alwaysReturnUrls,
			filterLink = data.filterLink
		})
	end)
end
