local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dSA")
local module2 = require("@luauforge/bundled/dSw")
local module3 = require("@luauforge/bundled/dSx")
local module4 = require("@luauforge/bundled/dME")
require("@luauforge/bundled/dMc")

local module5 = require("@luauforge/bundled/dMn")

return Rodux.createReducer(module4.DefaultFilters.PriceRange, {
	[module.name] = function(p2, p3)
		return p3.priceRange
	end,
	[module2.name] = function(p2, p3)
		return module4.DefaultFilters.PriceRange
	end,
	[module3.name] = function(p2, p3)
		return p3.PriceRange or p2
	end,
	[module5.name] = function(p2, p3)
		return p3.priceRange or p2
	end
})
