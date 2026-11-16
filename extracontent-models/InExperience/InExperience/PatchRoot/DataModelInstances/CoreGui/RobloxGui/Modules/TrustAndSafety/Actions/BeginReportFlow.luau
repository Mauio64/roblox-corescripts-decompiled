local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(reportType, targetPlayer)
	return { reportType = reportType, targetPlayer = targetPlayer }
end)
