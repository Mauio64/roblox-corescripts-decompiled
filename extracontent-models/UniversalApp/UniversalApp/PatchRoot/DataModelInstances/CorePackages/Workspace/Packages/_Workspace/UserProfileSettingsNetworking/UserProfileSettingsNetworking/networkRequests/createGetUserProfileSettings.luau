local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 8
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetUserProfileSettings"
	}, function(p1) -- line: 11
		-- upvalues: API_URL (copy)
		return p1(API_URL):path("user-profile-api"):path("v1"):path("user"):path("profiles"):path("settings")
	end)
end
