local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/Foundation")
local QRCodeDisplay = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/QRCodeDisplay")

local AccountSettingsPage = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/AccountSettingsPage")
local translate = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/translate")

local dialog = Foundation.Dialog
local view = Foundation.View

local function AccountSettingsQrDialog(p2)
	local url = AccountSettingsPage.getUrl(p2.page)

	return React.createElement(
		dialog.Root,
		{
			onClose = p2.onClose,
			hasBackdrop = true,
			disablePortal = false,
			testId = "--account-settings-qr-dialog"
		},
		{
			DialogTitle = React.createElement(dialog.Title, {
				text = AccountSettingsPage.getTitle(p2.page)
			}),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 1 }, {
				ContentView = React.createElement(view, {
					tag = "col size-full-0 auto-y gap-medium"
				}, {
					DialogText = React.createElement(dialog.Text, {
						Text = translate("Feature.Settings.Description.AccountSettingsWebsite"),
						LayoutOrder = 1
					}),
					QRCodeContainer = React.createElement(
						view,
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
