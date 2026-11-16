local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(reportType, targetPlayer, reportCategory)
	return { reportType = reportType, targetPlayer = targetPlayer, reportCategory = reportCategory }
end)
