local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gnl")
local module2 = require("@luauforge/deferred/gnm")

local function OutfitDetailsContentContainer(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return OutfitDetailsContentContainer
