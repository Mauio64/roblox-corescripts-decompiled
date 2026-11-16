local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_FRIEND_STATUS", function(userId, friendStatus)
	return { userId = userId, friendStatus = friendStatus }
end)
