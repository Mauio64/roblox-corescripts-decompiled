local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local axTooltip = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AXTooltip
local module = require("@luauforge/bundled/gJS")

local defineFastString = game:DefineFastString(
	"AXFilterButtonExpiredItemsTooltip",
	"AXFilterButtonExpiredItemsTooltip"
)

local function ExpiredFilterTooltip(p2)
	local v5 = useSelector(module) and "Top" or "Bottom"

	return React.createElement(axTooltip, {
		popoverSide = v5,
		tooltipStorageKey = defineFastString,
		showTooltip = true,
		tooltipLocalizationKey = "Feature.Avatar.tooltip.ExpiredItemsFilter",
		dismissTooltipRef = p2.dismissTooltipRef
	})
end

return ExpiredFilterTooltip
