local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("GetPostsByUserId", function(callback)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("getActiveCategories")
	end)
end
