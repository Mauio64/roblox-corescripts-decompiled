local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Dash")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SocialLuaAnalytics")

local BtnValues = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/BtnValues")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")

local enums = SocialLuaAnalytics.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes

return {
	[EventNames.QRPageLoad] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.PageLoad,
		formatRulesForAdditionalInfo = { shareLinkId = Dash.identity }
	},
	[EventNames.QRCodeScannerOpened] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.QRCodeScannerOpened }
	},
	[EventNames.QRCodeScannerTooltipShown] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.ProfileQRCodeTooltipShown
	},
	[EventNames.QRPageLoadFailed] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.PageLoadFailed,
		formatRulesForAdditionalInfo = { errorReason = Dash.identity }
	},
	[EventNames.QRPageFriendRequestBannerShown] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.ProfileQRCodeNotificationBannerShown,
		formatRulesForAdditionalInfo = { qrCodeBannerQueueSize = Dash.identity }
	},
	[EventNames.QRPageFriendRequestBannerAccepted] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.FriendRequestBannerAccepted },
		formatRulesForAdditionalInfo = { qrCodeBannerQueueSize = Dash.identity }
	},
	[EventNames.QRPageFriendRequestBannerDismissed] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.FriendRequestBannerDismissed },
		formatRulesForAdditionalInfo = { qrCodeBannerQueueSize = Dash.identity }
	},
	[EventNames.RefreshQrSession] = {
		context = contexts.ProfileQRCode,
		eventType = eventTypes.RefreshQrSession,
		formatRulesForAdditionalInfo = {
			success = Dash.identity,
			responseCode = Dash.identity
		}
	}
}
