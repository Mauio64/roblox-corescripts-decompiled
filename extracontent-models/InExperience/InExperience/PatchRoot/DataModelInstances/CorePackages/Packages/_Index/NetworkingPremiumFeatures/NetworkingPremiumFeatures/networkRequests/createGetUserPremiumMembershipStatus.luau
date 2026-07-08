local PREMIUM_FEATURES_URL = require(script.Parent.Parent.PREMIUM_FEATURES_URL)

return function(p1) -- line: 8
	-- upvalues: PREMIUM_FEATURES_URL (copy)
	return p1.roduxNetworking.GET({
		Name = "GetUserPremiumMembershipStatus"
	}, function(p2, p3) -- line: 13
		-- upvalues: PREMIUM_FEATURES_URL (copy)
		return p2(PREMIUM_FEATURES_URL):path("v1"):path("users"):id(p3):path("validate-membership")
	end)
end
