local ParentParent = script.Parent.Parent
local ACCOUNT_SETTINGS_URL = require(ParentParent.ACCOUNT_SETTINGS_URL)

return function(t1: {[any]: any}) -- line: 12
	-- upvalues: ACCOUNT_SETTINGS_URL (copy)
	return t1.roduxNetworking.GET({
		Name = "GetBlockedUsers"
	}, function(p1, t2: {[any]: any}?) -- line: 15
		-- upvalues: ACCOUNT_SETTINGS_URL (copy)
		return p1(ACCOUNT_SETTINGS_URL, {
			currentUserId = t2 and t2.currentUserId or nil
		}):path("v1"):path("users"):path("get-detailed-blocked-users")
	end)
end
