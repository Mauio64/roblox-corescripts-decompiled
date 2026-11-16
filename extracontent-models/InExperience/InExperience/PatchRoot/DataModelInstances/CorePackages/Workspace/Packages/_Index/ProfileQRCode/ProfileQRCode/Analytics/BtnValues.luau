local parent = script:FindFirstAncestor("ProfileQRCode").Parent
local Enumerate = require(parent.Enumerate)

return Enumerate(script.Name, {
	FriendRequestBannerAccepted = "friendRequestBannerAccepted",
	FriendRequestBannerDismissed = "friendRequestBannerDismissed",
	QRCodeScannerOpened = "qrCodeScannerOpened"
})
