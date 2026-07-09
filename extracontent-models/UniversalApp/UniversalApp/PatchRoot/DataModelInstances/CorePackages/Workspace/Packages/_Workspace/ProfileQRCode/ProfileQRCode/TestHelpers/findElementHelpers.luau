local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local SocialTestHelpers = require(ProfileQRCodeParent.Dev.SocialTestHelpers)
local findElementWithAssert = SocialTestHelpers.TestHelpers.findElementWithAssert
local findImageSet = SocialTestHelpers.TestHelpers.findImageSet
local TextKeys = require(ProfileQRCode.Common.TextKeys)

return {
	findQRCodeView = findElementWithAssert({
		Name = "QRCodeView"
	}),
	findQRCode = findElementWithAssert({
		Name = "QRCode"
	}),
	findDescription = findElementWithAssert({
		Text = TextKeys.ScanQRText
	}),
	findTrustedConnectionDescription = findElementWithAssert({
		Text = TextKeys.TrustedConnectionDescription
	}),
	findTrustedFriendsDescription = findElementWithAssert({
		Text = TextKeys.TrustedFriendsDescription
	}),
	findTopBarTitle = findElementWithAssert({
		Text = TextKeys.Title
	}),
	findTopBar = findElementWithAssert({
		Name = "TopBar"
	}),
	findPlayerAvatar = findElementWithAssert({
		Name = "PlayerAvatar"
	}),
	findCrossButton = findElementWithAssert(findImageSet("icons/navigation/close")),
	findBackButton = findElementWithAssert(findImageSet("icons/navigation/pushBack")),
	findRetryButton = findElementWithAssert(findImageSet("icons/common/refresh")),
	findLoadingElement = findElementWithAssert({
		Name = "Gradient"
	}),
	findQRCodeIcon = findElementWithAssert({
		Name = "QRImage"
	}),
	findUsername = findElementWithAssert({
		Name = "Username"
	}),
	findNotificationDescription = findElementWithAssert({
		Name = "Description"
	}),
	findCloseButton = findElementWithAssert({
		Name = "CloseButton"
	}),
	findDismissButton = findElementWithAssert({
		Name = "DismissButton"
	}),
	findAcceptButton = findElementWithAssert({
		Name = "AcceptButton"
	}),
	findAlertView = findElementWithAssert({
		Name = "FriendsInvite"
	}),
	findToastView = findElementWithAssert({
		Name = "FriendAcceptToast"
	}),
	findFriendAcceptedSnackbar = findElementWithAssert({
		Name = "FriendAcceptedSnackbar"
	})
}
