local Components = require(script.Components)

require(script.Types)

local Thunks = require(script.Thunks)
local Enum = require(script.Enum)

return {
	InAppSocialUpsellOverlayWrapper = require(script.Components).InAppSocialUpsellOverlayWrapper,
	UpsellBanner = Components.UpsellBanner,
	UpsellOverlay = Components.UpsellOverlay,
	SocialUpsellEventReceiver = Components.SocialUpsellEventReceiver,
	Analytics = {
		SocialUpsellAnalytics = require(script.Analytics.SocialUpsellAnalytics),
		Enum = require(script.Analytics.Enum)
	},
	Flags = {
		FFlagAddAEGIS2Analytics = require(script.Flag.FFlagAddAEGIS2Analytics)
	},
	Enum = require(script.Enum),
	Utils = {
		createCommonSocialUpsellBannerConfig = require(script.Utils.createCommonSocialUpsellBannerConfig),
		createBannerConfigFromUpsellCardVariation = require(script.Utils.createBannerConfigFromUpsellCardVariation),
		manuallyInvokeAmpUpsell = require(script.Utils.manuallyInvokeAmpUpsell)
	},
	Signals = {
		GetAgeVerifiedChangedSignal = require(script.Signals.GetAgeVerifiedChangedSignal)
	},
	Thunks = Thunks,
	Enums = Enum,
	Hooks = require(script.Hooks),
	Constants = require(script.Constants),
	Overlay = {
		initializeInExpOverlay = require(script.Utils.initializeInExpOverlay),
		getOverlayStore = require(script.Store.getOverlayStore),
		OverlayTypes = require(script.Constants).OVERLAY_TYPES
	},
	["jest.config"] = script["jest.config"]
}
