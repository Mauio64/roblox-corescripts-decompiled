local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "UpdateProfileCustomization"
	}, function(p1, t2: {[any]: any}) -- line: 33
		-- upvalues: API_URL (copy)
		local t3 = {
			profileCustomization = {
				profileEntity = t2.profileEntity,
				pinnedComponents = t2.pinnedComponents,
				customizedComponents = t2.customizedComponents
			}
		}

		return p1(API_URL):path("profile-platform-api"):path("v1"):path("profiles"):path("customization"):path("update"):body(t3)
	end)
end
