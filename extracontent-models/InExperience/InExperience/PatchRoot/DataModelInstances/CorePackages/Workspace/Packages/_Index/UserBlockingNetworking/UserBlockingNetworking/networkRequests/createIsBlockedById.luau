local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("IsBlockedById", function(callback, p2)
		return callback(API_URL, { currentUserId = p2.currentUserId }):path("user-blocking-api"):path("v1"):path("users"):id(p2.userId):path("is-blocked")
	end)
end
