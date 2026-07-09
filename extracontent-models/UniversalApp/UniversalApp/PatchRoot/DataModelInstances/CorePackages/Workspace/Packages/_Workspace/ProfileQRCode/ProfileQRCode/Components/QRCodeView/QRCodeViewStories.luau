local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local QRCodeView = require(script.Parent.QRCodeView)
local React = require(ProfileQRCodeParent.React)
local RoactRodux = require(ProfileQRCodeParent.RoactRodux)
local mockStore = require(ProfileQRCode.TestHelpers.mockStore)
local mockState = require(ProfileQRCode.TestHelpers.mockState)
local Constants = require(ProfileQRCode.Common.Constants)
local NetworkStatus = require(ProfileQRCode.Networking.configuredRoduxNetworking).Enum.NetworkStatus

return {
	default = function() -- line: 13
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), QRCodeView (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156"
			}))
		}, {
			QRCodeView = React.createElement(QRCodeView, {
				layoutOrder = 1
			})
		})
	end,
	loading = function() -- line: 24
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), Constants (copy), QRCodeView (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				[Constants.RODUX_KEY] = {
					Users = {},
					NetworkStatus = {},
					ShareUrl = {}
				}
			}))
		}, {
			QRCodeView = React.createElement(QRCodeView, {
				layoutOrder = 1
			})
		})
	end,
	failed = function() -- line: 40
		-- upvalues: React (copy), RoactRodux (copy), mockStore (copy), mockState (copy), Constants (copy), NetworkStatus (copy), QRCodeView (copy)
		return React.createElement(RoactRodux.StoreProvider, {
			store = mockStore(mockState({
				LocalUserId = "156",
				[Constants.RODUX_KEY] = {
					Users = {},
					NetworkStatus = {
						["https://apis.roblox.com/sharelinks/v1/get-or-create-link"] = NetworkStatus.Failed
					},
					ShareUrl = {}
				}
			}))
		}, {
			QRCodeView = React.createElement(QRCodeView, {
				layoutOrder = 1
			})
		})
	end
}
