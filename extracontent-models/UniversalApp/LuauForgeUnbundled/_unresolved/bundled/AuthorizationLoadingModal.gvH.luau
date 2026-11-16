local module = require("@luauforge/bundled/gvb")

local useScreenSize = require("@luauforge/bundled/gvI").useScreenSize
local useLocalization = require("@luauforge/bundled/gvJ").Hooks.useLocalization

local module2 = require("@luauforge/bundled/gvK")
local module3 = require("@luauforge/bundled/gvj")
local iconSize = module3.Enums.IconSize
local loading = module3.Loading

local interactiveAlert = module2.App.Dialog.Alert.InteractiveAlert

local buttonType = module2.App.Button.Enum.ButtonType

local function AuthorizationLoadingModal(p2)
	local onCancel = p2.onCancel

	local v5 = useScreenSize()

	local v6 = useLocalization({
		title = "Amp.FAEUpsell.Modal.Loading.Title",
		bodyText = "Amp.FAEUpsell.Modal.Loading.Text",
		cancelBtn = "Amp.FAEUpsell.Modal.Loading.ButtonCancel"
	})

	local v7 = module.useCallback(function()
		return module.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 80), BackgroundTransparency = 1 },
			{
				Spinner = module.createElement(loading, {
					size = iconSize.Medium,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			}
		)
	end, {})

	return module.createElement(interactiveAlert, {
		screenSize = v5,
		title = v6.title,
		bodyText = v6.bodyText,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onCancel, text = v6.cancelBtn }
				}
			}
		},
		middleContent = v7
	})
end

return AuthorizationLoadingModal
