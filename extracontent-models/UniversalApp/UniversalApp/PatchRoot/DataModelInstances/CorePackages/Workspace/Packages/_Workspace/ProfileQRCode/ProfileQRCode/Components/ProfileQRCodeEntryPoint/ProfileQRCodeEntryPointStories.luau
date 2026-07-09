local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local ProfileQRCodeEntryPoint = require(script.Parent.ProfileQRCodeEntryPoint)
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
	default = function(p1) -- line: 17
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), ProfileQRCodeEntryPoint (copy), v12 (copy), Dash (copy), createMockRobloxEventReceiver (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156"
			}))
		}, {
			ProfileQRCodeEntryPoint = React.createElement(ProfileQRCodeEntryPoint, {
				layoutOrder = 1,
				appStorageService = p1.appStorageService or v12,
				analyticsService = if not p1 or not p1.analyticsService then nil else p1.analyticsService,
				onClose = if not p1 or not p1.onClose then Dash.noop else p1.onClose,
				openQrCodeScanner = if not p1 or not p1.openQrCodeScanner then Dash.noop else p1.openQrCodeScanner,
				robloxEventReceiver = createMockRobloxEventReceiver().mockEventReceiver
			})
		})
	end,
	loading = function(p2) -- line: 33
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), Constants (copy), ProfileQRCodeEntryPoint (copy), v12 (copy), Dash (copy), createMockRobloxEventReceiver (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				[Constants.RODUX_KEY] = {
					Users = {},
					NetworkStatus = {}
				}
			}))
		}, {
			ProfileQRCodeEntryPoint = React.createElement(ProfileQRCodeEntryPoint, {
				layoutOrder = 1,
				appStorageService = p2.appStorageService or v12,
				analyticsService = if not p2 or not p2.analyticsService then nil else p2.analyticsService,
				onClose = if not p2 or not p2.onClose then Dash.noop else p2.onClose,
				openQrCodeScanner = if not p2 or not p2.openQrCodeScanner then Dash.noop else p2.openQrCodeScanner,
				robloxEventReceiver = createMockRobloxEventReceiver().mockEventReceiver
			})
		})
	end
}
