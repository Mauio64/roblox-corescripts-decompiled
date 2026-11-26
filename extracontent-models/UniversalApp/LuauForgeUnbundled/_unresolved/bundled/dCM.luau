local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SetSearchBarFocused", function(p2)
	return { focused = p2 }
end)
