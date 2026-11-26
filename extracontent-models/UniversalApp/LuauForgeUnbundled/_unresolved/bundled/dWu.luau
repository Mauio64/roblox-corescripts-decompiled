local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dWv")
local module2 = require("@luauforge/bundled/dWD")
local module3 = require("@luauforge/bundled/dWF")
local module4 = require("@luauforge/bundled/dWI")

return Rodux.combineReducers({
	ProfilePictureParams = module,
	PeekabooLayoutDetails = module2,
	CameraSliders = module3,
	FinalPageViewMode = module4
})
