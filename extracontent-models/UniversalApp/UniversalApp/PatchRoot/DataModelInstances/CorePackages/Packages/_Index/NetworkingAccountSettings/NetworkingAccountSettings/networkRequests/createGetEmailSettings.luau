local ParentParent = script.Parent.Parent

require(ParentParent.Types.networkRequestsTypes)

local ACCOUNT_SETTINGS_URL = require(ParentParent.ACCOUNT_SETTINGS_URL)

return function(p1) -- line: 6
	-- upvalues: ACCOUNT_SETTINGS_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetEmailSettings"
	}, function(p2) -- line: 9
		-- upvalues: ACCOUNT_SETTINGS_URL (copy)
		return p2(ACCOUNT_SETTINGS_URL):path("v1"):path("email")
	end)
end
