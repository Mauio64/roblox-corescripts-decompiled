local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local Parent = require(script.Parent)
local React = require(ProfileQRCodeParent.React)
local RoactRodux = require(ProfileQRCodeParent.RoactRodux)
local mockStore = require(ProfileQRCode.TestHelpers.mockStore)
local mockState = require(ProfileQRCode.TestHelpers.mockState)
local Dash = require(ProfileQRCodeParent.Dash)
local DefaultTestUserId = require(ProfileQRCode.TestHelpers.DefaultTestUserId)

return {
	default = function(p1) -- line: 12
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), Parent (copy), Dash (copy), DefaultTestUserId (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState())
		}, {
			QRCodeFriendRequestNotificationElement = React.createElement(Parent, {
				notificationQueueSize = 1,
				onClose = if not p1.onClose then Dash.noop else p1.onClose,
				onAccept = if not p1.onAccept then Dash.noop else p1.onAccept,
				userId = if not p1.userId then DefaultTestUserId else p1.userId
			})
		})
	end
}
