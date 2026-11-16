local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dTa")
local module2 = require("@luauforge/bundled/dTi")
local module3 = require("@luauforge/bundled/dTk")
local module4 = require("@luauforge/bundled/dTn")

return Rodux.combineReducers({
	ProfilePictureParams = module,
	PeekabooLayoutDetails = module2,
	CameraSliders = module3,
	FinalPageViewMode = module4
})
