local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjJ")
local useLocalization = require("@luauforge/bundled/gjH").Hooks.useLocalization

local image = module2.Image
local text = module2.Text
local view = module2.View
local useTokens = module2.Hooks.useTokens

local function QRPanel(p2)
	local v5 = useTokens()
	local scale = v5.Config.UI.Scale
	local v6 = useLocalization({
		title = "Authentication.CrossDevice.Heading.SignInWithQrCode",
		body = "Authentication.CrossDevice.Description.ScanQrOrEnterCode"
	})

	local children = {}

	for i = 1, 6 do
		children["Character" .. i] = module.createElement(view, {
			LayoutOrder = i,
			Size = UDim2.fromOffset(48 * scale, 48 * scale),
			tag = "row align-x-center align-y-center radius-small bg-over-media-300",
			testId = "CrossDeviceMagicSignInCodeCharacter"
		}, {
			Character = module.createElement(text, {
				Text = string.sub(p2.deviceCode, i, i),
				tag = "auto-xy text-heading-large content-emphasis"
			})
		})
	end

	local v7 = not (p2.qrCodeUrl == nil) and p2.deviceCode ~= ""

	local createElement = module.createElement

	local v10 = {
		Title = module.createElement(text, {
			Size = UDim2.new(1, 0, 0, 34 * scale),
			Text = v6.title,
			tag = "text-heading-large text-align-x-left text-truncate-end content-emphasis"
		}),
		Body = module.createElement(text, {
			Position = UDim2.fromOffset(0, 42 * scale),
			RichText = true,
			Size = UDim2.new(1, 0, 0, 44 * scale),
			Text = v6.body,
			tag = "text-body-large text-wrap text-align-x-left text-align-y-top content-default"
		}),
		QRCode = 0,
		Code = 0
	}

	local v11 = if v7 then module.createElement(view, {
		backgroundStyle = v5.Color.Extended.White.White_100,
		cornerRadius = 12 * scale,
		Position = UDim2.fromOffset(94.5 * scale, 112.5 * scale),
		Size = UDim2.fromOffset(213 * scale, 213 * scale),
		tag = "clip"
	}, {
		Image = module.createElement(image, {
			Image = p2.qrCodeUrl,
			Position = UDim2.fromOffset(18 * scale, 18 * scale),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(177 * scale, 177 * scale),
			testId = "CrossDeviceMagicSignInQRCode"
		})
	}) else nil
	v10.QRCode = v11

	v10.Code = module.createElement(view, {
		Position = UDim2.fromOffset(0, 349.5 * scale),
		Size = UDim2.new(1, 0, 0, 48 * scale),
		tag = "row align-x-center gap-large"
	}, children)
	return createElement(view, {
		tag = "size-full",
		testId = "CrossDeviceMagicSignInQRPanel"
	}, v10)
end

return QRPanel
