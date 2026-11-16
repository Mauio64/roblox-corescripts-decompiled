local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gmV")

local module2 = require("@luauforge/deferred/gWL")
local module3 = require("@luauforge/deferred/gWM")

local function ColorAdjustmentPageContainer()
	local v5 = module2()
	return React.createElement(module3, v5)
end

local v5 = module(ColorAdjustmentPageContainer)

return React.memo(v5)
