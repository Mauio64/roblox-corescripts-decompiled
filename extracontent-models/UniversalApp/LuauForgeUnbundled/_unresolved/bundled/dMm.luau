local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("CompleteExternalNavigation", function(p2)
	return { requestId = p2 }
end)
