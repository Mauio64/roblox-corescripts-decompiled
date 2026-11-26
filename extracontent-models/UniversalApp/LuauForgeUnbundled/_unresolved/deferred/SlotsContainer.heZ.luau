local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/hfa")
local module2 = require("@luauforge/deferred/hfi")
local Cryo = require(CorePackages.Packages.Cryo)

local fFlagAXSlotsDisableScrollAwayOnLandscape = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsDisableScrollAwayOnLandscape

local function SlotsContainer(p2)
	local joined = module(p2)
	local createElement = React.createElement

	if not fFlagAXSlotsDisableScrollAwayOnLandscape then
		joined = Cryo.Dictionary.join(joined, p2)
	end

	return createElement(module2, joined)
end

return SlotsContainer
