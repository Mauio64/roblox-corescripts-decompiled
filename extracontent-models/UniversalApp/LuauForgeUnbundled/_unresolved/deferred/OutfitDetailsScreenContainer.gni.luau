local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gnj")
local module2 = require("@luauforge/deferred/gnn")

local function OutfitDetailsScreenContainer(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return OutfitDetailsScreenContainer
