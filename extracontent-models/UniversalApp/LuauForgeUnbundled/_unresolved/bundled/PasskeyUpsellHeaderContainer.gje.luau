local module = require("@luauforge/bundled/giU")
local module2 = require("@luauforge/bundled/giY")
local useStyle = module2.Core.Style.useStyle
local images = module2.App.ImageSet.Images
local useStyleMetadata = module2.Core.Style.useStyleMetadata
local imageSetButton = module2.Core.ImageSet.ImageSetButton
local module3 = require("@luauforge/bundled/gjf")
local colorMode = module3.Enums.ColorMode
local text = module3.Text
local view = module3.View
local image = module3.Image

local function checkGraphicExistence(p2)
	return images[p2].image
end

local function PasskeyUpsellHeaderContainer(props)
	local v5 = useStyle()
	local v6 = useStyleMetadata().ThemeName == colorMode.Dark

	local v7 = "icons/graphic/passkey_upsell"
	local success, result = pcall(checkGraphicExistence, v7)

	return module.createElement(view, {
		tag = "col gap-xxlarge size-full-0 auto-y padding-bottom-xxlarge",
		padding = { top = UDim.new(0, 48) }
	}, {
		CloseButton = module.createElement(imageSetButton, {
			Size = UDim2.new(0, 36, 0, 36),
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			Image = images["icons/navigation/close"],
			[module.Event.Activated] = props.onCancelButtonPressed,
			BackgroundColor3 = v5.Theme.BackgroundUIContrast.Color,
			ImageColor3 = v5.Theme.UIEmphasis.Color,
			LayoutOrder = 1,
			Active = not props.isDisabled
		}),
		Title = module.createElement(text, {
			Text = props.localizedTitleText,
			textStyle = { Color3 = v5.Theme.TextEmphasis.Color },
			TextWrapped = true,
			tag = "content-action-emphasis text-align-x-left text-heading-medium auto-xy padding-left",
			LayoutOrder = 3
		}),
		Graphic = props.shouldRenderGraphic and module.createElement(
			view,
			{
				tag = "auto-xy position-center-center grow",
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0.27, 0)
			},
			{
				UpsellGraphic = module.createElement(image, {
					Image = not success and (v6 and "icons/graphic/passkey_upsell_dark" or "icons/graphic/passkey_upsell_light") or v7,
					ScaleType = Enum.ScaleType.Fit,
					Size = UDim2.new(1, 0, 1, 0)
				})
			}
		)
	})
end

return PasskeyUpsellHeaderContainer
