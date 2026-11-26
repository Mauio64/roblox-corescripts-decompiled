local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gRz")

local module2 = require("@luauforge/deferred/hiX")
local module3 = require("@luauforge/deferred/hiY")

local function ColorAdjustmentPageContainer()
	local v5 = module2()
	return React.createElement(module3, v5)
end

local v5 = module(ColorAdjustmentPageContainer)

return React.memo(v5)
