local module = require("@luauforge/bundled/gtJ")
local react = module.React
local uiBlox = module.UIBlox
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local module2 = require("@luauforge/bundled/guj")
local useLocalization = module.Localization.Hooks.useLocalization
local useStyle = uiBlox.Core.Style.useStyle
local images = uiBlox.App.ImageSet.Images
local module3 = require("@luauforge/bundled/guk")
local module4 = require("@luauforge/bundled/gul")

local function AddAccountRow(props)
	local v5 = useLocalization({
		addAccountText = "Authentication.AccountSwitch.Action.AddAccount"
	})

	local v6 = useStyle()
	local function renderPlusIcon()
		return react.createElement(
			"Frame",
			{
				Size = UDim2.new(0, 48, 0, 48),
				BackgroundColor3 = v6.Theme.IconDefault.Color,
				BackgroundTransparency = 0.6
			},
			{
				UICorner = react.createElement("UICorner", {
					CornerRadius = UDim.new(0, 24)
				}),
				Icon = react.createElement(imageSetLabel, {
					Size = UDim2.new(0, 16, 0, 16),
					Image = images["icons/common/plus_small"],
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					ImageColor3 = v6.Theme.BackgroundContrast.Color
				})
			}
		)
	end

	local function onRowClickedCallback()
		props.onRowClicked()
		module3.sendButtonClickEvent(props.context, props.origin, module4.btn.addAccount)
	end

	return react.createElement(module2, {
		titleContent = v5.addAccountText,
		subtitleContent = "",
		renderImage = renderPlusIcon,
		onAccountSelection = onRowClickedCallback,
		userInteractionEnabled = true
	})
end

return AddAccountRow
