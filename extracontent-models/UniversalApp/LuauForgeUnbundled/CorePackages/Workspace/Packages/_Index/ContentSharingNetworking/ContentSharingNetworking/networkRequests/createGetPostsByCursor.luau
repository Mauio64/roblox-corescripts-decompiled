local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.GET("GetPostsByCursor", function(callback, data)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("findByUser"):queryArgs({
			cursor = data.cursor,
			sortOrder = data.sortOrder,
			userId = data.userId
		})
	end)
end
