local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetCameraSliderRotate", function(p2)
	return { rotateSliderValue = p2 }
end)
