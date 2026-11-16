local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ProfileCustomizationNetworking/ProfileCustomizationNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.POST("GetProfileCustomization", function(callback, p3)
		local v5 = {
			profileEntities = { p3.profileEntity }
		}

		return callback(API_URL):path("profile-platform-api"):path("v1"):path("profiles"):path("customization"):path("get"):body(v5)
	end)
end
