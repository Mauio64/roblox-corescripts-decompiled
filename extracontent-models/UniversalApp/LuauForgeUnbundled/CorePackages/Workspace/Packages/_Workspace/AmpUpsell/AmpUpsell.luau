require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")

return {
	AccountSettingsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/AccountSettingsUpsell"),
	VPCUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/ParentalRequest/VPCUpsellContainer"),
	VPCPrologue = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Prologues/VPCPrologue"),
	WizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/WizardContainer"),
	FAEUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/FacialAgeEstimation/FAEUpsellContainer"),
	OpenAmpWizardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/OpenAmpWizardContainer"),
	AmpWizardLaunchReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/AmpWizardLaunchReceiver"),
	AmpEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums"),
	AmpApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AmpApiProvider"),
	IDVUpsellContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/IDVUpsellContainer"),
	GetFFlagEnableAmpEmailUpsellSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpEmailUpsellSupport"),
	GetFFlagEnableAmpIDVUpsellSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpIDVUpsellSupport"),
	GetFFlagEnableAmpSubscriptionUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpSubscriptionUpsell"),
	InExpAmpWizardController = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/InExpAmpWizardController"),
	GetFFlagEnableAmpVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpVPCPrologue"),
	GetFFlagEnableReusableVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableReusableVPCPrologue"),
	GetFFlagEnableAmpWizardVPCNavigationFix = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableAmpWizardVPCNavigationFix"),
	AmpWizardUserMismatchModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/AmpWizardUserMismatchModal")
}
