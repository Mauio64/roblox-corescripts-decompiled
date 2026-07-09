local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: API_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetBlockedUsers"
	}, function(p1, t2: {[any]: any}?) -- line: 17
		-- upvalues: API_URL (copy)
		return p1(API_URL, {
			currentUserId = t2 and t2.currentUserId or nil
		}):path("user-blocking-api"):path("v1"):path("users"):path("get-blocked-users"):queryArgs({
			cursor = t2 and t2.cursor or nil,
			count = t2 and t2.count or nil
		})
	end)
end
