local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gRz")

local module2 = require("@luauforge/deferred/hiP")

local module3 = require("@luauforge/deferred/hiR")

local function LayeredMakeupSortScreen(p2)
	local v5 = module3(p2)
	return React.createElement(module2, v5)
end

module2 = module(module2)

return LayeredMakeupSortScreen
