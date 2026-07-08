local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local Flags = Foundation.Utility.Flags
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local BadgeVariant = require(ParentParent.App.Indicator.Enum.BadgeVariant)

local function migrateBadgeVariantToStatusIndicatorVariant(p1) -- line: 9
	-- upvalues: Flags (copy), BadgeVariant (copy), StatusIndicatorVariant (copy)
	if Flags.FoundationStatusIndicatorVariantExperiment then
		if p1 == BadgeVariant.Alert then
			return StatusIndicatorVariant.Alert
		end

		return StatusIndicatorVariant.Contrast_Experiment
	end

	return StatusIndicatorVariant.Emphasis
end

return migrateBadgeVariantToStatusIndicatorVariant
