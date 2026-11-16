local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dNF")
local module2 = require("@luauforge/bundled/dNJ")
local module3 = require("@luauforge/bundled/dNK")
local module4 = require("@luauforge/bundled/dNL")

return Rodux.combineReducers({
	WidgetInfo = module,
	SearchPageWidgetInfo = module3,
	ContextWidgetInfo = module4,
	HydratedWidgetData = module2
})
