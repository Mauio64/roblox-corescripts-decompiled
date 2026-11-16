local parent = script:FindFirstAncestor("IdentityVerification").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local QRCodeDisplay = require(parent.QRCodeDisplay)
local ECLevels = QRCodeDisplay.ECLevels

local function QRDeepLinkDialog(props)
	local deeplink = props.deeplink
	local title = props.title
	local description = props.description
	local footer = props.footer
	local onClose = props.onClose

	local v = useTokens()

	local udim = UDim.new(0, v.Size.Size_400 + v.Size.Size_1000)
	local udim2 = UDim.new(0, v.Size.Size_500)

	return React.createElement(Dialog.Root, {
		size = DialogSize.Medium,
		hasBackdrop = true,
		onClose = onClose
	}, {
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogView = React.createElement(View, { tag = "col items-stretch size-full-0 auto-y" }, {
				TitleWrapper = React.createElement(View, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y padding-bottom-small",
					padding = { right = udim, top = udim2 }
				}, {
					TitleText = React.createElement(Text, {
						Text = title,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis"
					})
				}),
				BodyText = React.createElement(Dialog.Text, { Text = description, LayoutOrder = 2 }),
				QRCardWrapper = React.createElement(
					View,
					{
						tag = "col align-x-center items-center size-full-0 auto-y margin-y-large",
						LayoutOrder = 3
					},
					{
						QRCard = React.createElement(View, {
							tag = "col auto-xy padding-medium",
							cornerRadius = UDim.new(0, 14),
							backgroundStyle = {
								Color3 = Color3.fromRGB(255, 255, 255),
								Transparency = 0
							}
						}, {
							QRCode = React.createElement(QRCodeDisplay.DisplayQRCode, {
								ecLevel = ECLevels.EC_LEVEL_4,
								sideLength = 176,
								toEncode = deeplink,
								backgroundColor = Color3.fromRGB(255, 255, 255),
								pixelColor = Color3.fromRGB(0, 0, 0)
							})
						})
					}
				),
				FooterText = React.createElement(Text, {
					Text = footer,
					LayoutOrder = 4,
					RichText = true,
					tag = "size-full-0 auto-y padding-bottom-small text-body-medium text-wrap text-align-x-left"
				})
			})
		})
	})
end

return QRDeepLinkDialog
