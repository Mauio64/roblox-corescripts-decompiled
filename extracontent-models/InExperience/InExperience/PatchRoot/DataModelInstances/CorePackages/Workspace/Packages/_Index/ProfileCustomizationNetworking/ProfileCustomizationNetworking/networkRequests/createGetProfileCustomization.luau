local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "GetProfileCustomization"
	}, function(p1, t2: {[any]: any}) -- line: 18
		-- upvalues: API_URL (copy)
		local t3 = {
			profileEntities = { t2.profileEntity }
		}

		return p1(API_URL):path("profile-platform-api"):path("v1"):path("profiles"):path("customization"):path("get"):body(t3)
	end)
end
