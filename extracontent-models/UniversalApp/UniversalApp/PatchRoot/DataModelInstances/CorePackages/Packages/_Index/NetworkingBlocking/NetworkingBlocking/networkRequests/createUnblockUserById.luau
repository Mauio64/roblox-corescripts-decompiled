local ParentParent = script.Parent.Parent
local ACCOUNT_SETTINGS_URL = require(ParentParent.ACCOUNT_SETTINGS_URL)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: ACCOUNT_SETTINGS_URL (copy)
	return t1.roduxNetworking.POST({
		Name = "UnblockUserById"
	}, function(p1, t2: {[any]: any}) -- line: 16
		-- upvalues: ACCOUNT_SETTINGS_URL (copy)
		return p1(ACCOUNT_SETTINGS_URL, {
			params = t2.currentUserId
		}):path("v1"):path("users"):id(t2.userId):path("unblock"):body({})
	end)
end
