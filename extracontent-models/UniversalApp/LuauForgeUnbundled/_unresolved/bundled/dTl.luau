local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetCameraSliderZoom", function(p2)
	return { zoomSliderValue = p2 }
end)
