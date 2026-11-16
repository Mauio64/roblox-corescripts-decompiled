local GetFFlagEnableVPCUpsellFoundationDialogHardening = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableVPCUpsellFoundationDialogHardening")

local GetFFlagEnableFoundationUIVPCUpsellForInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableFoundationUIVPCUpsellForInExperience")

return function(p2)
	return GetFFlagEnableVPCUpsellFoundationDialogHardening() or GetFFlagEnableFoundationUIVPCUpsellForInExperience() and p2
end
