local Components = require(script.Components)
require(script.Types)
local Thunks = require(script.Thunks)
local Enum2 = require(script.Enum)

local Components2 = require(script.Components)
local SocialUpsell = {
	["InAppSocialUpsellOverlayWrapper"] = Components2.InAppSocialUpsellOverlayWrapper,
	UpsellBanner = Components.UpsellBanner,
	UpsellOverlay = Components.UpsellOverlay,
	SocialUpsellEventReceiver = Components.SocialUpsellEventReceiver,
	Analytics = {
		SocialUpsellAnalytics = require(script.Analytics.SocialUpsellAnalytics),
		Enum = require(script.Analytics.Enum)
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
	Enums = Enum2,
	Hooks = require(script.Hooks),
	Constants = require(script.Constants)
}
local overlay = {
	initializeInExpOverlay = require(script.Utils.initializeInExpOverlay),
	getOverlayStore = require(script.Store.getOverlayStore),
	OverlayTypes = 0
}
local Constants = require(script.Constants)
overlay.OverlayTypes = Constants.OVERLAY_TYPES
SocialUpsell.Overlay = overlay

SocialUpsell["jest.config"] = script["jest.config"]
return SocialUpsell
