local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("ClearWidgetInfo", function(p2, p3)
	return { query = p2, context = p3 }
end)
