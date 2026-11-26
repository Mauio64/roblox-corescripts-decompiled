local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IdentityVerification/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local QRCodeDisplay = require("@game/CorePackages/Workspace/Packages/_Index/IdentityVerification/QRCodeDisplay")
local ecLevels = QRCodeDisplay.ECLevels

local function QRDeepLinkDialog(props)
	local deeplink = props.deeplink
	local title = props.title
	local description = props.description
	local footer = props.footer
	local onClose = props.onClose

	local v5 = useTokens()

	local udim = UDim.new(0, v5.Size.Size_400 + v5.Size.Size_1000)
	local udim2 = UDim.new(0, v5.Size.Size_500)

	return React.createElement(
		dialog.Root,
		{ size = dialogSize.Medium, hasBackdrop = true, onClose = onClose },
		{
			DialogContent = React.createElement(dialog.Content, nil, {
				DialogView = React.createElement(view, {
					tag = "col items-stretch size-full-0 auto-y"
				}, {
					TitleWrapper = React.createElement(view, {
						LayoutOrder = 1,
						tag = "size-full-0 auto-y padding-bottom-small",
						padding = { right = udim, top = udim2 }
					}, {
						TitleText = React.createElement(text, {
							Text = title,
							tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
						})
					}),
					BodyText = React.createElement(dialog.Text, {
						Text = description,
						LayoutOrder = 2
					}),
					QRCardWrapper = React.createElement(
						view,
						{
							tag = "col align-x-center items-center size-full-0 auto-y margin-y-large",
							LayoutOrder = 3
						},
						{
							QRCard = React.createElement(view, {
								tag = "col auto-xy padding-medium",
								cornerRadius = UDim.new(0, 14),
								backgroundStyle = {
									Color3 = Color3.fromRGB(255, 255, 255),
									Transparency = 0
								}
							}, {
								QRCode = React.createElement(QRCodeDisplay.DisplayQRCode, {
									ecLevel = ecLevels.EC_LEVEL_4,
									sideLength = 176,
									toEncode = deeplink,
									backgroundColor = Color3.fromRGB(255, 255, 255),
									pixelColor = Color3.fromRGB(0, 0, 0)
								})
							})
						}
					),
					FooterText = React.createElement(text, {
						Text = footer,
						LayoutOrder = 4,
						RichText = true,
						tag = "size-full-0 auto-y padding-bottom-small text-body-medium text-wrap text-align-x-left"
					})
				})
			})
		}
	)
end

return QRDeepLinkDialog
