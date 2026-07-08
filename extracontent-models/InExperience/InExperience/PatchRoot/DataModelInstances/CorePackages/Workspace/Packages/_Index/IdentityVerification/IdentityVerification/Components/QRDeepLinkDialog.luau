local Parent = script:FindFirstAncestor("IdentityVerification").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local QRCodeDisplay = require(Parent.QRCodeDisplay)
local ECLevels = QRCodeDisplay.ECLevels

local function QRDeepLinkDialog(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), React (copy), Dialog (copy), DialogSize (copy), View (copy), FoundationText (copy), QRCodeDisplay (copy), ECLevels (copy)
	local deeplink = t1.deeplink
	local title = t1.title
	local description = t1.description
	local footer = t1.footer
	local onClose = t1.onClose
	local v18 = useTokens()
	local uDim = UDim.new(0, v18.Size.Size_400 + v18.Size.Size_1000)
	local uDim2 = UDim.new(0, v18.Size.Size_500)

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		size = DialogSize.Medium,
		onClose = onClose
	}, {
		DialogContent = React.createElement(Dialog.Content, nil, {
			DialogView = React.createElement(View, {
				tag = "col items-stretch size-full-0 auto-y"
			}, {
				TitleWrapper = React.createElement(View, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y padding-bottom-small",
					padding = {
						right = uDim,
						top = uDim2
					}
				}, {
					TitleText = React.createElement(FoundationText, {
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
						Text = title
					})
				}),
				BodyText = React.createElement(Dialog.Text, {
					LayoutOrder = 2,
					Text = description
				}),
				QRCardWrapper = React.createElement(View, {
					tag = "col align-x-center items-center size-full-0 auto-y margin-y-large",
					LayoutOrder = 3
				}, {
					QRCard = React.createElement(View, {
						tag = "col auto-xy padding-medium",
						cornerRadius = UDim.new(0, 14),
						backgroundStyle = {
							Transparency = 0,
							Color3 = Color3.fromRGB(255, 255, 255)
						}
					}, {
						QRCode = React.createElement(QRCodeDisplay.DisplayQRCode, {
							sideLength = 176,
							ecLevel = ECLevels.EC_LEVEL_4,
							toEncode = deeplink,
							backgroundColor = Color3.fromRGB(255, 255, 255),
							pixelColor = Color3.fromRGB(0, 0, 0)
						})
					})
				}),
				FooterText = React.createElement(FoundationText, {
					LayoutOrder = 4,
					RichText = true,
					tag = "size-full-0 auto-y padding-bottom-small text-body-medium text-wrap text-align-x-left",
					Text = footer
				})
			})
		})
	})
end

return QRDeepLinkDialog
