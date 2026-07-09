local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local FFlagConnectionsToFriendsRename = require(Parent.SharedFlags).FFlagConnectionsToFriendsRename

return {
	AcceptFriend = "Feature.Profile.Action.AcceptFriends",
	AcceptConnection = "CommonUI.Features.Label.AcceptConnection",
	Description = "Feature.Profile.Description.QrCodeScanning",
	ScanQRText = "Feature.Profile.Description.ScanQR",
	TrustedConnectionDescription = "Feature.Profile.Description.QrCodeDescription",
	TrustedFriendsDescription = "Feature.Profile.Description.QrCodeDescription.FriendsRename",
	FailedToLoad = "Feature.Profile.Message.QRLoadFailed",
	FriendAdded = "Feature.Profile.Message.FriendAdded",
	ConnectionAdded = "Feature.Friends.Action.ConnectionAdded",
	NowTrusted = "Feature.Friends.Label.NowTrusted",
	QRFriendAdded = "Feature.Friends.Message.FriendAdded",
	NotificationRequest = "Feature.Profile.Message.QRNofificationRequest",
	Title = "Feature.Profile.Heading.ProfileQRCode",
	TooltipText = "Feature.Profile.Tooltip.QrScanner",
	TooltipTitle = "Feature.Profile.Title.QrScanner",
	ShareProfileLink = "Feature.Profile.Action.ShareProfileLink",
	CopyProfileLink = "Feature.Profile.Action.CopyProfileLink",
	QrCodeDescription = not FFlagConnectionsToFriendsRename and "Feature.Profile.Description.QrCodeDescription" or "Feature.Profile.Description.QrCodeDescription.FriendsRename",
	NotificationRequestText = not FFlagConnectionsToFriendsRename and "Feature.Profile.Message.QRNotificationRequest" or "Feature.Profile.Message.QRNotificationRequest.FriendsRename"
}
