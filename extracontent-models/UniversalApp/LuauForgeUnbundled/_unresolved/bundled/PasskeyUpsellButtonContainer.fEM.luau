local module = require("@luauforge/bundled/fEA")
local module2 = require("@luauforge/bundled/fEL")
local buttonVariant = module2.Enums.ButtonVariant
local fillBehavior = module2.Enums.FillBehavior
local buttonSize = module2.Enums.ButtonSize
local view = module2.View
local button = module2.Button
local defineFastInt = game:DefineFastInt("PasskeyUpsellDisableButtonTimer", 1)

local function PasskeyUpsellButtonContainer(props)
	local onCancelButtonPressed = props.localizedCancelText and props.onCancelButtonPressed
	local v5, v6

	if onCancelButtonPressed then
		v5 = "gap-small align-y-center align-x-center col"
		v6 = 88
	else
		v5 = "align-y-center align-x-center col"
		v6 = 40
	end

	return module.createElement(view, {
		tag = v5,
		Size = UDim2.new(1, 0, 0, v6),
		Position = UDim2.new(0, 0, 1, -v6),
		LayoutOrder = props.layoutOrder
	}, {
		ContinueButton = module.createElement(button, {
			variant = buttonVariant.Emphasis,
			text = props.localizedContinueText,
			size = buttonSize.Large,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onContinueButtonPressed,
			isDisabled = props.isDisabled
		}),
		CancelButton = onCancelButtonPressed and module.createElement(button, {
			variant = buttonVariant.Standard,
			size = buttonSize.Large,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			text = props.localizedCancelText,
			onActivated = props.onCancelButtonPressed,
			inputDelay = defineFastInt,
			isDisabled = props.isDisabled
		})
	})
end

return PasskeyUpsellButtonContainer
