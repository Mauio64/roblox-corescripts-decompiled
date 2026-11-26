local AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AmpUpsell")

return game:DefineFastFlag("EnablePlayButtonWizardVPCPrologue", false)
	and AmpUpsell.GetFFlagEnableAmpVPCPrologue()
	and AmpUpsell.GetFFlagEnableReusableVPCPrologue()
	and AmpUpsell.GetFFlagEnableAmpWizardVPCNavigationFix()
