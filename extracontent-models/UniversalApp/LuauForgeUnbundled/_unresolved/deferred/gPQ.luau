local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)
local module = require("@luauforge/deferred/gPR")
local module2 = require("@luauforge/deferred/gPW")

local function ItemDescriptionWithChipsContainer(p2, p3)
	local v5 = module2(p2)
	return React.createElement(module, Dash.join(v5, { ref = p3 }))
end

return React.forwardRef(ItemDescriptionWithChipsContainer)
