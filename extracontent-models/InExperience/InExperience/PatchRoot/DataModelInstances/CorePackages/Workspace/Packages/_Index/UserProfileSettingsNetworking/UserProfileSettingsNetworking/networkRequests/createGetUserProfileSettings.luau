local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.GET("GetUserProfileSettings", function(callback)
		return callback(API_URL):path("user-profile-api"):path("v1"):path("user"):path("profiles"):path("settings")
	end)
end
