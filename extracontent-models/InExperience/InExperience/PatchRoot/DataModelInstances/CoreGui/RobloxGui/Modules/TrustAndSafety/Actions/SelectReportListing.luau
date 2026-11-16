local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(reportType, targetPlayer, sortedUserIds)
	return { reportType = reportType, targetPlayer = targetPlayer, sortedUserIds = sortedUserIds }
end)
