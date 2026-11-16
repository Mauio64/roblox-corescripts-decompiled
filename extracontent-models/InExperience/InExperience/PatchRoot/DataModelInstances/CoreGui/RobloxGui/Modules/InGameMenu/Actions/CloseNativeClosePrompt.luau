local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("CLOSE_NATIVE_PROMPT", function()
	return {}
end)
