local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dSG")
local module2 = require("@luauforge/bundled/dSw")
local module3 = require("@luauforge/bundled/dSx")
require("@luauforge/bundled/dMo")
local module4 = require("@luauforge/bundled/dME")

local module5 = require("@luauforge/bundled/dMn")

return Rodux.createReducer(module4.DefaultFilters.UnavailableItemFilter, {
	[module.name] = function(p2, p3)
		return p3.unavailableItemFilter
	end,
	[module2.name] = function(p2, p3)
		return module4.DefaultFilters.UnavailableItemFilter
	end,
	[module3.name] = function(p2, p3)
		return p3.UnavailableItemFilter or p2
	end,
	[module5.name] = function(p2, p3)
		return p3.unavailableItemFilter or p2
	end
})
