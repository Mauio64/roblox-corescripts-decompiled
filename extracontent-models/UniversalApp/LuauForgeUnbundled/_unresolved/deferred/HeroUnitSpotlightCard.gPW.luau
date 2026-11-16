local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gPX")

local module2 = require("@luauforge/deferred/gPZ")

local function HeroUnitSpotlightCard(p2)
	local v5 = module2(p2)
	return React.createElement(module, v5)
end

return HeroUnitSpotlightCard
