local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.POST("DeletePost", function(callback, p2)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("delete"):id(p2.postId):body({})
	end)
end
