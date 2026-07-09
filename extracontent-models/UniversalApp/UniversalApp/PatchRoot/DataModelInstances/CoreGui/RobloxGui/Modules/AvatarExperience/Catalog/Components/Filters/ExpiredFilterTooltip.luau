local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AXTooltip = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.AXTooltip
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local v7 = game:DefineFastString("AXFilterButtonExpiredItemsTooltip", "AXFilterButtonExpiredItemsTooltip")

local function ExpiredFilterTooltip(t1: {[any]: any}) -- line: 19
	-- upvalues: useSelector (copy), selectIsPortrait (copy), React (copy), AXTooltip (copy), v7 (copy)
	local v10 = not useSelector(selectIsPortrait) and "Bottom" or "Top"

	return React.createElement(AXTooltip, {
		showTooltip = true,
		tooltipLocalizationKey = "Feature.Avatar.tooltip.ExpiredItemsFilter",
		popoverSide = v10,
		tooltipStorageKey = v7,
		dismissTooltipRef = t1.dismissTooltipRef
	})
end

return ExpiredFilterTooltip
