local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local ProfileQRCodePage = require(script.Parent.ProfileQRCodePage)
local React = require(ProfileQRCodeParent.React)
local RoactRodux = require(ProfileQRCodeParent.RoactRodux)
local mockStore = require(ProfileQRCode.TestHelpers.mockStore)
local mockState = require(ProfileQRCode.TestHelpers.mockState)
local Dash = require(ProfileQRCodeParent.Dash)
local Constants = require(ProfileQRCode.Common.Constants)
local createMockRobloxEventReceiver = require(ProfileQRCode.TestHelpers.createMockRobloxEventReceiver)
local FormFactor = require(ProfileQRCodeParent.Dev.FormFactor)

return {
	default = function(p1) -- line: 14
		-- upvalues: createMockRobloxEventReceiver (copy), React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), FormFactor (copy), ProfileQRCodePage (copy), Dash (copy)
		local mockEventReceiver = createMockRobloxEventReceiver().mockEventReceiver

		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				FormFactor = FormFactor.Enums.FormFactor.WIDE
			}))
		}, {
			AvatarBackground = React.createElement("Frame", {
				Size = UDim2.new(0, 1200, 0, 800),
				BackgroundColor3 = Color3.new(1, 0, 1)
			}, {
				ProfileQRCodePage = React.createElement(ProfileQRCodePage, {
					profileQRCodeFriendRequestAlertsEnabled = if not p1.profileQRCodeFriendRequestAlertsEnabled then nil else p1.profileQRCodeFriendRequestAlertsEnabled,
					onClose = if not p1 or not p1.onClose then Dash.noop else p1.onClose,
					openQrCodeScanner = if not p1 or not p1.openQrCodeScanner then Dash.noop else p1.openQrCodeScanner,
					robloxEventReceiver = if not p1.robloxEventReceiver then mockEventReceiver else p1.robloxEventReceiver
				})
			})
		})
	end,
	loading = function(p2) -- line: 41
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), FormFactor (copy), Constants (copy), ProfileQRCodePage (copy), Dash (copy), createMockRobloxEventReceiver (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				FormFactor = FormFactor.Enums.FormFactor.WIDE,
				[Constants.RODUX_KEY] = {
					Users = {},
					NetworkStatus = {}
				}
			}))
		}, {
			AvatarBackground = React.createElement("Frame", {
				Size = UDim2.new(0, 1200, 0, 800),
				BackgroundColor3 = Color3.new(1, 0, 1)
			}, {
				ProfileQRCodePage = React.createElement(ProfileQRCodePage, {
					profileQRCodeFriendRequestAlertsEnabled = true,
					onClose = if not p2 or not p2.onClose then Dash.noop else p2.onClose,
					openQrCodeScanner = if not p2 or not p2.openQrCodeScanner then Dash.noop else p2.openQrCodeScanner,
					robloxEventReceiver = createMockRobloxEventReceiver().mockEventReceiver
				})
			})
		})
	end
}
