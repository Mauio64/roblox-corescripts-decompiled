local PREMIUM_FEATURES_URL = require(script.Parent.Parent.PREMIUM_FEATURES_URL)

return function(p)
	return p.roduxNetworking.GET({ Name = "GetUserPremiumMembershipStatus" }, function(callback, p2)
		return callback(PREMIUM_FEATURES_URL):path("v1"):path("users"):id(p2):path("validate-membership")
	end)
end
