local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)
local GetFFlagEnableFoundationUIVPCUpsellForInExperience = require(AmpUpsell.Flags.GetFFlagEnableFoundationUIVPCUpsellForInExperience)

return function(b1: boolean) -- line: 8
	-- upvalues: GetFFlagEnableVPCUpsellFoundationDialogHardening (copy), GetFFlagEnableFoundationUIVPCUpsellForInExperience (copy)
	return GetFFlagEnableVPCUpsellFoundationDialogHardening() or GetFFlagEnableFoundationUIVPCUpsellForInExperience() and b1
end
