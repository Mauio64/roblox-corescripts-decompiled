local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local QRCodeFriendRequestNotification = require(script.QRCodeFriendRequestNotification)
local QRCodeFriendRequestNotificationV2 = require(script.QRCodeFriendRequestNotificationV2)

if require(ProfileQRCode.Flags.FFlagQRCodeFriendRequestNotificationV2) then
	return QRCodeFriendRequestNotificationV2
end

return QRCodeFriendRequestNotification
