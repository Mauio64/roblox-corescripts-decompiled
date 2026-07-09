local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.QRPageLoad] = {
		name = game:DefineFastString("ProfileQRPageLoad", "ProfileQRPageLoad")
	},
	[EventNames.QRCodeScannerOpened] = {
		name = game:DefineFastString("ProfileQRCodeScannerOpened", "ProfileQRCodeScannerOpened")
	},
	[EventNames.QRCodeScannerTooltipShown] = {
		name = game:DefineFastString("ProfileQRCodeScannerTooltipShown", "ProfileQRCodeScannerTooltipShown")
	},
	[EventNames.QRPageLoadFailed] = {
		name = game:DefineFastString("ProfileQRPageLoadFailed", "ProfileQRPageLoadFailed")
	},
	[EventNames.QRPageFriendRequestBannerShown] = {
		name = game:DefineFastString("ProfileQRPageFriendRequestBannerShown", "ProfileQRPageFriendRequestBannerShown")
	},
	[EventNames.QRPageFriendRequestBannerAccepted] = {
		name = game:DefineFastString("ProfileQRPageFriendRequestBannerAccepted", "ProfileQRPageFriendRequestBannerAccepted")
	},
	[EventNames.QRPageFriendRequestBannerDismissed] = {
		name = game:DefineFastString("ProfileQRPageFriendRequestBannerDismissed", "ProfileQRPageFriendRequestBannerDismissed")
	}
}
