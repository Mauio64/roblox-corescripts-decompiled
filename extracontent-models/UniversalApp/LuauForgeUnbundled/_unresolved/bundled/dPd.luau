local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dwM")
local module2 = require("@luauforge/bundled/dPe")
require("@luauforge/bundled/dMc")

return Rodux.createReducer({}, {
	[module2.name] = function(p2, p3)
		module.isType(p3.uprankedItems, "table", "items data must be a table.")
		return p3.uprankedItems
	end
})
