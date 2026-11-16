local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dHL")

local module = require("@luauforge/bundled/dSI")
local module2 = require("@luauforge/bundled/dSJ")
local module3 = require("@luauforge/bundled/dSx")
local module4 = require("@luauforge/bundled/dSw")
local module5 = require("@luauforge/bundled/dME")

local module6 = require("@luauforge/bundled/dMn")

return Rodux.createReducer(module5.DefaultFilters.SelectedTopics, {
	[module2.name] = function(p2, p3)
		return p3.selectedTopics
	end,
	[module.name] = function(p2, p3)
		return module5.DefaultFilters.SelectedTopics
	end,
	[module3.name] = function(p2, p3)
		return p3.SelectedTopics or p2
	end,
	[module4.name] = function(p2, p3)
		return module5.DefaultFilters.SelectedTopics
	end,
	[module6.name] = function(p2, p3)
		return p3.topics or p2
	end
})
