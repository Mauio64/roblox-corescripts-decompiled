local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

return Rodux.makeActionCreator("SetPeekabooLayoutDetails", function(p2, p3, p4, p5)
	return { screenName = p2, screenHeightPix = p3, topYPix = p4, viewportSizePix = p5 }
end)
