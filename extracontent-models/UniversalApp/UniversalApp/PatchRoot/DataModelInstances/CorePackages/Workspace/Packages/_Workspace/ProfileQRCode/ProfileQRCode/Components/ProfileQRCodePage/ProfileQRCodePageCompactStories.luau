local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local ProfileQRCodePage = require(script.Parent.ProfileQRCodePage)
local Dash = require(ProfileQRCodeParent.Dash)
local React = require(ProfileQRCodeParent.React)
local RoactRodux = require(ProfileQRCodeParent.RoactRodux)
local Constants = require(ProfileQRCode.Common.Constants)
local createMockAppStorageService = require(ProfileQRCode.TestHelpers.createMockAppStorageService)
local createMockRobloxEventReceiver = require(ProfileQRCode.TestHelpers.createMockRobloxEventReceiver)
local mockState = require(ProfileQRCode.TestHelpers.mockState)
local mockStore = require(ProfileQRCode.TestHelpers.mockStore)
local v12 = createMockAppStorageService()

return {
	default = function(p1) -- line: 19
		-- upvalues: createMockRobloxEventReceiver (copy), React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), ProfileQRCodePage (copy), v12 (copy), Dash (copy)
		local mockEventReceiver = createMockRobloxEventReceiver().mockEventReceiver

		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				FormFactor = nil
			}))
		}, {
			AvatarBackground = React.createElement("Frame", {
				ZIndex = -2,
				Size = UDim2.new(0, 500, 0, 700),
				BackgroundColor3 = Color3.new(1, 0, 1)
			}, {
				AvatarImage = React.createElement("Frame", {
					ZIndex = -1,
					Size = UDim2.new(0, 500, 0, 350),
					BackgroundColor3 = Color3.new(0, 1, 1)
				}),
				ProfileQRCodePage = React.createElement(ProfileQRCodePage, {
					appStorageService = if not p1.appStorageService then v12 else p1.appStorageService,
					profileQRCodeFriendRequestAlertsEnabled = if not p1.profileQRCodeFriendRequestAlertsEnabled then nil else p1.profileQRCodeFriendRequestAlertsEnabled,
					onClose = if not p1 or not p1.onClose then Dash.noop else p1.onClose,
					openQrCodeScanner = if not p1 or not p1.openQrCodeScanner then Dash.noop else p1.openQrCodeScanner,
					robloxEventReceiver = if not p1.robloxEventReceiver then mockEventReceiver else p1.robloxEventReceiver
				})
			})
		})
	end,
	longScreen = function(p2) -- line: 54
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), ProfileQRCodePage (copy), Dash (copy), createMockRobloxEventReceiver (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				FormFactor = nil
			}))
		}, {
			AvatarBackground = React.createElement("Frame", {
				Size = UDim2.new(0, 500, 0, 900),
				BackgroundColor3 = Color3.new(1, 0, 1)
			}, {
				AvatarImage = React.createElement("Frame", {
					Size = UDim2.new(0, 500, 0, 450),
					BackgroundColor3 = Color3.new(0, 1, 1)
				}),
				ProfileQRCodePage = React.createElement(ProfileQRCodePage, {
					profileQRCodeFriendRequestAlertsEnabled = true,
					onClose = if not p2 or not p2.onClose then Dash.noop else p2.onClose,
					openQrCodeScanner = if not p2 or not p2.openQrCodeScanner then Dash.noop else p2.openQrCodeScanner,
					robloxEventReceiver = createMockRobloxEventReceiver().mockEventReceiver
				})
			})
		})
	end,
	loading = function(p3) -- line: 81
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), Constants (copy), ProfileQRCodePage (copy), Dash (copy), createMockRobloxEventReceiver (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				FormFactor = nil,
				[Constants.RODUX_KEY] = {
					Users = {},
					NetworkStatus = {}
				}
			}))
		}, {
			AvatarBackground = React.createElement("Frame", {
				Size = UDim2.new(0, 500, 0, 900),
				BackgroundColor3 = Color3.new(1, 0, 1)
			}, {
				ProfileQRCodePage = React.createElement(ProfileQRCodePage, {
					profileQRCodeFriendRequestAlertsEnabled = true,
					onClose = if not p3 or not p3.onClose then Dash.noop else p3.onClose,
					openQrCodeScanner = if not p3 or not p3.openQrCodeScanner then Dash.noop else p3.openQrCodeScanner,
					robloxEventReceiver = createMockRobloxEventReceiver().mockEventReceiver
				})
			})
		})
	end
}
