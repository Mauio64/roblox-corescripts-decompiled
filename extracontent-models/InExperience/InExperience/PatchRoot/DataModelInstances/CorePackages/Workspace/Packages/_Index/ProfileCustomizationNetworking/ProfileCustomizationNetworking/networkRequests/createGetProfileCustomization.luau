local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.POST("GetProfileCustomization", function(callback, p2)
		local v = {
			profileEntities = { p2.profileEntity }
		}

		return callback(API_URL):path("profile-platform-api"):path("v1"):path("profiles"):path("customization"):path("get"):body(v)
	end)
end
