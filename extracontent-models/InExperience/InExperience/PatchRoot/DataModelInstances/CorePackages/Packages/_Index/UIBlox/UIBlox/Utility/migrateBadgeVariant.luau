local parent = script.Parent.Parent
local parent2 = parent.Parent
local Foundation = require(parent2.Foundation)
local Flags = Foundation.Utility.Flags
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local BadgeVariant = require(parent.App.Indicator.Enum.BadgeVariant)

local function migrateBadgeVariantToStatusIndicatorVariant(p)
	if not Flags.FoundationStatusIndicatorVariantExperiment then
		return StatusIndicatorVariant.Emphasis
	end

	if p == BadgeVariant.Alert then
		return StatusIndicatorVariant.Alert
	end

	return StatusIndicatorVariant.Contrast_Experiment
end

return migrateBadgeVariantToStatusIndicatorVariant
