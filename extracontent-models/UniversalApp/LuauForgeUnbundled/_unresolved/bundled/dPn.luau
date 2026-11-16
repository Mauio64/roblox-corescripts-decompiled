local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetBodyColorViewSetting", function(p2)
	return { bodyColorViewSetting = p2 }
end)
