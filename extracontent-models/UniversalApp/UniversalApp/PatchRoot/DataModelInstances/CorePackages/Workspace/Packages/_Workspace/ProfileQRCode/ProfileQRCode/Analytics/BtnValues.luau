local Parent = script:FindFirstAncestor("ProfileQRCode").Parent

return require(Parent.Enumerate)(script.Name, {
	FriendRequestBannerAccepted = "friendRequestBannerAccepted",
	FriendRequestBannerDismissed = "friendRequestBannerDismissed",
	QRCodeScannerOpened = "qrCodeScannerOpened"
})
