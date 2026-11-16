local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local Enumerate = require(parent.Enumerate)

return Enumerate(script.Name, {
	QRPageLoad = "QRPageLoad",
	QRPageLoadFailed = "QRPageLoadFailed",
	QRPageFriendRequestBannerShown = "QRPageFriendRequestBannerShown",
	QRPageFriendRequestBannerAccepted = "QRPageFriendRequestBannerAccepted",
	QRPageFriendRequestBannerDismissed = "QRPageFriendRequestBannerDismissed",
	QRCodeScannerOpened = "QRCodeScannerOpened",
	QRCodeScannerTooltipShown = "QRCodeScannerTooltipShown",
	RefreshQrSession = "RefreshQrSession"
})
