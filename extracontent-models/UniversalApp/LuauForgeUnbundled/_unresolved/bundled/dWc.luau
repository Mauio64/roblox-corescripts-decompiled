local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")

local module = require("@luauforge/bundled/dWd")
local module2 = require("@luauforge/bundled/dWe")
local module3 = require("@luauforge/bundled/dVS")
local module4 = require("@luauforge/bundled/dVR")
local module5 = require("@luauforge/bundled/dPU")

local module6 = require("@luauforge/bundled/dPD")

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
