local Components = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Components")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Types")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Thunks")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum")

return {
	InAppSocialUpsellOverlayWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Components").InAppSocialUpsellOverlayWrapper,
	UpsellBanner = Components.UpsellBanner,
	UpsellOverlay = Components.UpsellOverlay,
	SocialUpsellEventReceiver = Components.SocialUpsellEventReceiver,
	Analytics = {
		SocialUpsellAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/SocialUpsellAnalytics"),
		Enum = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum")
	},
	Enum = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum"),
	Utils = {
		createCommonSocialUpsellBannerConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/createCommonSocialUpsellBannerConfig"),
		createBannerConfigFromUpsellCardVariation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/createBannerConfigFromUpsellCardVariation"),
		manuallyInvokeAmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/manuallyInvokeAmpUpsell")
	},
	Signals = { GetAgeVerifiedChangedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Signals/GetAgeVerifiedChangedSignal") },
	Thunks = module2,
	Enums = module3,
	Hooks = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Hooks"),
	Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants"),
	Overlay = {
		initializeInExpOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/initializeInExpOverlay"),
		getOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Store/getOverlayStore"),
		OverlayTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants").OVERLAY_TYPES
	}
}
