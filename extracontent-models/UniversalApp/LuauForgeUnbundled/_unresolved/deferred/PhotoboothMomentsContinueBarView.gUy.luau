local module = require("@luauforge/deferred/gTR")
local module2 = require("@luauforge/deferred/gTT")

local udim = UDim.new(0.35, 0)
local udim2 = UDim.new(0.85, 0)

local function PhotoboothMomentsContinueBarView(props)
	local createElement = module.createElement
	local view = module2.View
	local v5 = {
		tag = "row align-x-center align-y-center size-full-0 auto-y padding-y-medium bg-surface-0",
		LayoutOrder = props.LayoutOrder,
		testId = "PhotoboothMomentsContinueBarView"
	}

	local createElement2 = module.createElement
	local button = module2.Button
	local v7 = {
		text = props.text,
		variant = module2.Enums.ButtonVariant.Emphasis,
		size = module2.Enums.InputSize.Medium,
		width = 0,
		isDisabled = 0,
		onActivated = 0,
		testId = "PhotoboothMomentsContinueBarView_Button"
	}
	local v8 = if props.isLandscape then udim else udim2
	v7.width = v8
	v7.isDisabled = props.isDisabled
	v7.onActivated = props.onActivated
	return createElement(view, v5, { Button = createElement2(button, v7) })
end

return PhotoboothMomentsContinueBarView
