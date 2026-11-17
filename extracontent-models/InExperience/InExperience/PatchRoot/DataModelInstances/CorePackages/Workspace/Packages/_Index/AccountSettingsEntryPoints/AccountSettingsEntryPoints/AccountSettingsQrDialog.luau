local parent = script.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local QRCodeDisplay = require(parent2.QRCodeDisplay)

local AccountSettingsPage = require(parent.AccountSettingsPage)
local translate = require(parent.translate)

local Dialog = Foundation.Dialog
local View = Foundation.View

local function AccountSettingsQrDialog(p)
	local url = AccountSettingsPage.getUrl(p.page)

	return React.createElement(
		Dialog.Root,
		{
			onClose = p.onClose,
			hasBackdrop = true,
			disablePortal = false,
			testId = "--account-settings-qr-dialog"
		},
		{
			DialogTitle = React.createElement(Dialog.Title, {
				text = AccountSettingsPage.getTitle(p.page)
			}),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 1 }, {
				ContentView = React.createElement(View, {
					tag = "col size-full-0 auto-y gap-medium"
				}, {
					DialogText = React.createElement(Dialog.Text, {
						Text = translate("Feature.Settings.Description.AccountSettingsWebsite"),
						LayoutOrder = 1
					}),
					QRCodeContainer = React.createElement(
						View,
						{
							tag = "row size-full-0 auto-y align-x-center padding-y-large",
							LayoutOrder = 2
						},
						{
							QRCode = React.createElement(QRCodeDisplay.DisplayQRCode, {
								ecLevel = QRCodeDisplay.ECLevels.EC_LEVEL_1,
								sideLength = 240,
								toEncode = url
							})
						}
					)
				})
			})
		}
	)
end

return AccountSettingsQrDialog
