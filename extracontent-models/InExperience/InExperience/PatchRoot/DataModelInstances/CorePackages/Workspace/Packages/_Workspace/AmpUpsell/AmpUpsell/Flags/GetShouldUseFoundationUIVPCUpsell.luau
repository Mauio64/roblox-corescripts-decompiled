local AmpUpsell = script:FindFirstAncestor("AmpUpsell")

local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)

local GetFFlagEnableFoundationUIVPCUpsellForInExperience = require(AmpUpsell.Flags.GetFFlagEnableFoundationUIVPCUpsellForInExperience)

return function(flag: boolean)
	return GetFFlagEnableVPCUpsellFoundationDialogHardening()
		or GetFFlagEnableFoundationUIVPCUpsellForInExperience() and flag
end
