local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gOM")

local module2 = require("@luauforge/deferred/gOT")

local function MakeupOutfitSwitcherFrame(p2)
	local v5 = module(p2)
	return React.createElement(module2, v5)
end

return MakeupOutfitSwitcherFrame
