local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local Dash = require(Parent.Dash)
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local BtnValues = require(script.Parent.Parent.Analytics.BtnValues)
local EventNames = require(script.Parent.EventNames)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

return {
	[EventNames.QRPageLoad] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			shareLinkId = Dash.identity
		}
	},
	[EventNames.QRCodeScannerOpened] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.QRCodeScannerOpened
		}
	},
	[EventNames.QRCodeScannerTooltipShown] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.ProfileQRCodeTooltipShown
	},
	[EventNames.QRPageLoadFailed] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.PageLoadFailed,
		formatRulesForAdditionalInfo = {
			errorReason = Dash.identity
		}
	},
	[EventNames.QRPageFriendRequestBannerShown] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.ProfileQRCodeNotificationBannerShown,
		formatRulesForAdditionalInfo = {
			qrCodeBannerQueueSize = Dash.identity
		}
	},
	[EventNames.QRPageFriendRequestBannerAccepted] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.FriendRequestBannerAccepted
		},
		formatRulesForAdditionalInfo = {
			qrCodeBannerQueueSize = Dash.identity
		}
	},
	[EventNames.QRPageFriendRequestBannerDismissed] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.FriendRequestBannerDismissed
		},
		formatRulesForAdditionalInfo = {
			qrCodeBannerQueueSize = Dash.identity
		}
	},
	[EventNames.RefreshQrSession] = {
		context = Contexts.ProfileQRCode,
		eventType = EventTypes.RefreshQrSession,
		formatRulesForAdditionalInfo = {
			success = Dash.identity,
			responseCode = Dash.identity
		}
	}
}
