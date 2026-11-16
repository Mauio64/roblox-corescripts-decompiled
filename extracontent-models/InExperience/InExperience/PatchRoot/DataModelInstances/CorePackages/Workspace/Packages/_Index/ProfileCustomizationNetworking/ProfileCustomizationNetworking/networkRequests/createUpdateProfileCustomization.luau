local parent = script.Parent.Parent
local API_URL = require(parent.API_URL)

return function(p)
	return p.roduxNetworking.POST("UpdateProfileCustomization", function(callback, data)
		local v = {
			profileCustomization = {
				profileEntity = data.profileEntity,
				pinnedComponents = data.pinnedComponents,
				customizedComponents = data.customizedComponents
			}
		}

		return callback(API_URL):path("profile-platform-api"):path("v1"):path("profiles"):path("customization"):path("update"):body(v)
	end)
end
