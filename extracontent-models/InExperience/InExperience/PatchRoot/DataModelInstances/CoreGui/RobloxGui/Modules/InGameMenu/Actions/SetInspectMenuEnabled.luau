local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SET_INSPECT_MENU_ENABLED", function(enabled)
	return { enabled = enabled }
end)
