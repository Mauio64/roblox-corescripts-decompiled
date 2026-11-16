local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(p, inviteStatus)
	return { userId = tostring(p), inviteStatus = inviteStatus }
end)
