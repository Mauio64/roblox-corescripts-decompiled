local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gmV")

local module2 = require("@luauforge/deferred/gWE")

local module3 = require("@luauforge/deferred/gWF")

local function LayeredMakeupSortScreen(p2)
	local v5 = module3(p2)
	return React.createElement(module2, v5)
end

module2 = module(module2)

return LayeredMakeupSortScreen
