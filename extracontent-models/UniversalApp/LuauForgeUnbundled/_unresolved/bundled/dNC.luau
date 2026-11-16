local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetPlayEmoteInBackground", function(p2)
	return { shouldPlayEmoteInBackground = p2 }
end)
