local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.GET("GetPostsByUserId", function(callback, p3)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("findByUser"):queryArgs({
			limit = p3.limit,
			userId = p3.userId
		})
	end)
end
