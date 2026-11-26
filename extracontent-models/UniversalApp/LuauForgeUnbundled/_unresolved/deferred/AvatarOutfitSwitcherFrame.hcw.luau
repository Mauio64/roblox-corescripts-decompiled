local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/hcx")

local module2 = require("@luauforge/deferred/haW")

local function AvatarOutfitSwitcherFrame(p2)
	local v5 = module(p2)
	return React.createElement(module2, v5)
end

return AvatarOutfitSwitcherFrame
