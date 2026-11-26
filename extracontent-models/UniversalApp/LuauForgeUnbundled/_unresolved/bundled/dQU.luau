local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dQV")
local module2 = require("@luauforge/bundled/dQZ")
local module3 = require("@luauforge/bundled/dRa")
local module4 = require("@luauforge/bundled/dRb")

return Rodux.combineReducers({
	WidgetInfo = module,
	SearchPageWidgetInfo = module3,
	ContextWidgetInfo = module4,
	HydratedWidgetData = module2
})
