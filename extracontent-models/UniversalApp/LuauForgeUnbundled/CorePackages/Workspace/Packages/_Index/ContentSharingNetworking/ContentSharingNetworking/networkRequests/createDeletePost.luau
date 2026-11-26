local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ContentSharingNetworking/ContentSharingNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.POST("DeletePost", function(callback, p3)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("delete"):id(p3.postId):body({})
	end)
end
