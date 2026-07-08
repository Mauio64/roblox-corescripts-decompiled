local Foundation = script:FindFirstAncestor("Foundation")
local StatusIndicatorVariant = require(Foundation.Enums.StatusIndicatorVariant)
local Flags = require(Foundation.Utility.Flags)

return {
	[StatusIndicatorVariant.Emphasis] = true,
	[StatusIndicatorVariant.Standard] = true,
	[StatusIndicatorVariant.Contrast_Experiment] = not not Flags.FoundationStatusIndicatorVariantExperiment,
	[StatusIndicatorVariant.Alert] = not not Flags.FoundationStatusIndicatorVariantExperiment
}
