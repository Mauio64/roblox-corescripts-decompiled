local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("RECEIVED_USER_INVITE_STATUS", function(p, inviteStatus)
	return { userId = tostring(p), inviteStatus = inviteStatus }
end)
