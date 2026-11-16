local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dSv")
local module2 = require("@luauforge/bundled/dSw")
local module3 = require("@luauforge/bundled/dSx")
require("@luauforge/bundled/dMq")
local module4 = require("@luauforge/bundled/dME")

local module5 = require("@luauforge/bundled/dMn")

return Rodux.createReducer(module4.DefaultFilters.CatalogSort, {
	[module.name] = function(p2, p3)
		return p3.sort
	end,
	[module2.name] = function(p2, p3)
		return module4.DefaultFilters.CatalogSort
	end,
	[module3.name] = function(p2, p3)
		return p3.CatalogSort or p2
	end,
	[module5.name] = function(p2, p3)
		return p3.sortType or p2
	end
})
