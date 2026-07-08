local Parent = script:FindFirstAncestor("ProfileQRCode").Parent

return require(Parent.Enumerate)(script.Name, {
	QRPageLoad = "QRPageLoad",
	QRPageLoadFailed = "QRPageLoadFailed",
	QRPageFriendRequestBannerShown = "QRPageFriendRequestBannerShown",
	QRPageFriendRequestBannerAccepted = "QRPageFriendRequestBannerAccepted",
	QRPageFriendRequestBannerDismissed = "QRPageFriendRequestBannerDismissed",
	QRCodeScannerOpened = "QRCodeScannerOpened",
	QRCodeScannerTooltipShown = "QRCodeScannerTooltipShown",
	RefreshQrSession = "RefreshQrSession"
})
