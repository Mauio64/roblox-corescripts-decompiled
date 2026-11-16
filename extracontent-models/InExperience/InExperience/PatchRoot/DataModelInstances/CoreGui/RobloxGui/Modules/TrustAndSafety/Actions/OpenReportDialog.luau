local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(reportType, targetPlayer, onGoBack)
	return { reportType = reportType, targetPlayer = targetPlayer, onGoBack = onGoBack }
end)
