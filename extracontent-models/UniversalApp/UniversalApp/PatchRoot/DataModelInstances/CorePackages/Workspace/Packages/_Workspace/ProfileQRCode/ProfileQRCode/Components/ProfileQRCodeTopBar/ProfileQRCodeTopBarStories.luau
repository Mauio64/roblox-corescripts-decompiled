local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local ProfileQRCodeTopBar = require(script.Parent.ProfileQRCodeTopBar)
local React = require(ProfileQRCodeParent.React)
local Dash = require(ProfileQRCodeParent.Dash)
local RoactRodux = require(ProfileQRCodeParent.RoactRodux)
local createMockAppStorageService = require(ProfileQRCode.TestHelpers.createMockAppStorageService)
local mockStore = require(ProfileQRCode.TestHelpers.mockStore)
local mockState = require(ProfileQRCode.TestHelpers.mockState)
local v10 = createMockAppStorageService()

return {
	default = function(p1) -- line: 16
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), ProfileQRCodeTopBar (copy), v10 (copy), Dash (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState())
		}, {
			ProfileQRCodeTopBar = React.createElement(ProfileQRCodeTopBar, {
				layoutOrder = 1,
				appStorageService = if not p1.appStorageService then v10 else p1.appStorageService,
				onClose = if not p1.onClose then Dash.noop else p1.onClose,
				openQrCodeScanner = if not p1.openQrCodeScanner then Dash.noop else p1.openQrCodeScanner
			})
		})
	end
}
