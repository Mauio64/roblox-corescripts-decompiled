local parent = script:FindFirstAncestor("GamePlayButton").Parent

local AmpUpsell = require(parent.AmpUpsell)

return game:DefineFastFlag("EnablePlayButtonWizardVPCPrologue", false)
	and AmpUpsell.GetFFlagEnableAmpVPCPrologue()
	and AmpUpsell.GetFFlagEnableReusableVPCPrologue()
	and AmpUpsell.GetFFlagEnableAmpWizardVPCNavigationFix()
