local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local Parent = require(script.Parent)
local Dash = require(ProfileQRCodeParent.Dash)
local React = require(ProfileQRCodeParent.React)
local RoactRodux = require(ProfileQRCodeParent.RoactRodux)
local createMockAppStorageService = require(ProfileQRCode.TestHelpers.createMockAppStorageService)
local createMockRobloxEventReceiver = require(ProfileQRCode.TestHelpers.createMockRobloxEventReceiver)
local mockState = require(ProfileQRCode.TestHelpers.mockState)
local mockStore = require(ProfileQRCode.TestHelpers.mockStore)
local v11 = createMockAppStorageService()

return {
	default = function(p1) -- line: 17
		-- upvalues: createMockRobloxEventReceiver (copy), React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), Parent (copy), v11 (copy), Dash (copy)
		local mockEventReceiver = createMockRobloxEventReceiver().mockEventReceiver

		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156"
			}))
		}, {
			Wrapper = React.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(400, 500)
			}, {
				ProfileQRCodeTopElements = React.createElement(Parent, {
					appStorageService = if not p1.appStorageService then v11 else p1.appStorageService,
					onClose = if not p1.onClose then Dash.noop else p1.onClose,
					openQrCodeScanner = if not p1.openQrCodeScanner then Dash.noop else p1.openQrCodeScanner,
					profileQRCodeFriendRequestAlertsEnabled = if not p1.profileQRCodeFriendRequestAlertsEnabled then nil else p1.profileQRCodeFriendRequestAlertsEnabled,
					robloxEventReceiver = if not p1.robloxEventReceiver then mockEventReceiver else p1.robloxEventReceiver
				})
			})
		})
	end
}
