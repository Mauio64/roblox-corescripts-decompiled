local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local setSpecialFeaturesFilter = require("@luauforge/bundled/dHL").Actions.SetSpecialFeaturesFilter
local module = require("@luauforge/bundled/dSw")
local module2 = require("@luauforge/bundled/dSx")
local module3 = require("@luauforge/bundled/dME")

local module4 = require("@luauforge/bundled/dMn")

return Rodux.createReducer(module3.DefaultFilters.SpecialFeaturesFilter, {
	[setSpecialFeaturesFilter.name] = function(list, p2)
		if list and table.concat(list, ",") == table.concat(p2.specialFeaturesFilter, ",") then
			return list
		end

		return p2.specialFeaturesFilter
	end,
	[module.name] = function(p2, p3)
		return module3.DefaultFilters.SpecialFeaturesFilter
	end,
	[module2.name] = function(p2, p3)
		return p3.SpecialFeaturesFilter or p2
	end,
	[module4.name] = function(p2, p3)
		return module3.DefaultFilters.SpecialFeaturesFilter
	end
})
