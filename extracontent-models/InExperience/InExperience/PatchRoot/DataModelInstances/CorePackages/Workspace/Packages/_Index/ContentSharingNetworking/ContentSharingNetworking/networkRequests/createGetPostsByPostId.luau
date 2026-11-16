local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("GetPostsByPostId", function(callback, data)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("findByUser"):queryArgs({
			limit = data.limit,
			postId = data.postId,
			userId = data.userId
		})
	end)
end
