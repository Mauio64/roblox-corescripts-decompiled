local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Dash = require(CorePackages.Packages.Dash)

local module = require("@luauforge/deferred/hkE")
local module2 = require("@luauforge/deferred/hkF")

local function EmoteTileContainer(p2, p3)
	local v5 = module2(p2, p3)
	return React.createElement(module, Dash.assign(v5, { ref = p3 }))
end

return React.forwardRef(EmoteTileContainer)
