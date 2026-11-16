local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("GetPostsByUserId", function(callback, p2)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("findByUser"):queryArgs({
			limit = p2.limit,
			userId = p2.userId
		})
	end)
end
