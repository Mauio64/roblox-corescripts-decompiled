local ParentParent = script.Parent.Parent

require(ParentParent.Types.networkRequestsTypes)

local ACCOUNT_INFORMATION_URL = require(ParentParent.ACCOUNT_INFORMATION_URL)

return function(p1) -- line: 7
	-- upvalues: ACCOUNT_INFORMATION_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetPhoneInformation"
	}, function(p2) -- line: 10
		-- upvalues: ACCOUNT_INFORMATION_URL (copy)
		return p2(ACCOUNT_INFORMATION_URL):path("v1"):path("phone")
	end)
end
