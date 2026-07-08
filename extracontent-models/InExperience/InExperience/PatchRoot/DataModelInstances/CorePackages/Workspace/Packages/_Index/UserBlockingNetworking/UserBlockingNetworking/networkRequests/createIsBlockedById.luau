local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "IsBlockedById"
	}, function(p1, t2: {[any]: any}) -- line: 16
		-- upvalues: API_URL (copy)
		return p1(API_URL, {
			currentUserId = t2.currentUserId
		}):path("user-blocking-api"):path("v1"):path("users"):id(t2.userId):path("is-blocked")
	end)
end
