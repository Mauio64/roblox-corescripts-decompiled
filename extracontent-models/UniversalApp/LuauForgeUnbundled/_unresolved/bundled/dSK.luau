local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dSL")
local module2 = require("@luauforge/bundled/dSw")
local module3 = require("@luauforge/bundled/dSx")
local module4 = require("@luauforge/bundled/dME")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module5 = require("@luauforge/bundled/dMn")

return Rodux.createReducer(module4.DefaultFilters.WearTimeFilter, {
	[module.name] = function(p2, p3)
		return p3.wearTimeFilter
	end,
	[module2.name] = function(p2, p3)
		return module4.DefaultFilters.WearTimeFilter
	end,
	[module3.name] = function(p2, p3)
		return p3.WearTimeFilter or p2
	end,
	[module5.name] = function(p2, p3)
		return p3.wearTimeFilter or p2
	end
})
