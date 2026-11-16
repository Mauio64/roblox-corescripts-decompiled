local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("CLOSE_REPORT_DIALOG", function()
	return {}
end)
