local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ProfileCustomizationNetworking/ProfileCustomizationNetworking/API_URL")

return function(p2)
	return p2.roduxNetworking.POST("UpdateProfileCustomization", function(callback, data)
		local v5 = {
			profileCustomization = {
				profileEntity = data.profileEntity,
				pinnedComponents = data.pinnedComponents,
				customizedComponents = data.customizedComponents
			}
		}

		return callback(API_URL):path("profile-platform-api"):path("v1"):path("profiles"):path("customization"):path("update"):body(v5)
	end)
end
