local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")

local module = require("@luauforge/bundled/dWb")
local module2 = require("@luauforge/bundled/dVR")
local module3 = require("@luauforge/bundled/dVS")
require("@luauforge/bundled/dPE")
local module4 = require("@luauforge/bundled/dPU")

local module5 = require("@luauforge/bundled/dPD")

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
