local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local function SetFieldOfViewDeg(p2)
	return { fieldOfViewDeg = p2 }
end

return Rodux.makeActionCreator("SetFieldOfViewDeg", SetFieldOfViewDeg)
