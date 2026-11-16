local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.POST("RemoveReaction", function(callback, p2)
		return callback(API_URL):path("posts-api"):path("v1"):path("content-posts"):path("removeReaction"):body(p2)
	end)
end
