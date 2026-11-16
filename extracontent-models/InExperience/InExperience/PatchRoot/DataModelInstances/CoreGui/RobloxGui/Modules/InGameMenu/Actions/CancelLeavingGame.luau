local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("CANCEL_LEAVING_GAME", function()
	return {}
end)
