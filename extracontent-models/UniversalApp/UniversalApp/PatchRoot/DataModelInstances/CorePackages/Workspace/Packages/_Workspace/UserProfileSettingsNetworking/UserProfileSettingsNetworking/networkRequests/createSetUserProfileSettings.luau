local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "SetUserProfileSettings"
	}, function(p1, t2: {[any]: any}) -- line: 15
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("user-profile-api"):path("v1"):path("user"):path("profiles"):path("settings"):body({
			userProfileSettings = {
				isInExperienceNameEnabled = t2.isInExperienceNameEnabled
			}
		})
	end)
end
