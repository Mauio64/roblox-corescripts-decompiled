local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")

local module = require("@luauforge/bundled/dVZ")
local module2 = require("@luauforge/bundled/dVR")
local module3 = require("@luauforge/bundled/dVS")
local module4 = require("@luauforge/bundled/dPU")

local module5 = require("@luauforge/bundled/dPD")

return Rodux.createReducer(module4.DefaultFilters.CreatorFilter, {
	[module.name] = function(p2, p3)
		return p3.creatorFilter
	end,
	[module2.name] = function(p2, p3)
		return module4.DefaultFilters.CreatorFilter
	end,
	[module3.name] = function(p2, p3)
		return p3.CreatorFilter or p2
	end,
	[module5.name] = function(p2, p3)
		return p3.creatorFilter or p2
	end
})
