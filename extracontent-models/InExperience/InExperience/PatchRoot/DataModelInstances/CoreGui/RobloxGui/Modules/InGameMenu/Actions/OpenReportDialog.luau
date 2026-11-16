local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("OPEN_REPORT_DIALOG", function(userId, userName)
	return { userId = userId, userName = userName }
end)
