local module = require("@luauforge/bundled/grg")
local module2 = require("@luauforge/bundled/gri")
local view = module2.View
local iconButton = module2.IconButton
local buttonVariant = module2.Enums.ButtonVariant
local iconName = module2.Enums.IconName
local inputSize = module2.Enums.InputSize

local function DashboardTopBar(props)
	return module.createElement(view, {
		tag = "row align-y-center size-full-0 auto-y padding-x-medium",
		LayoutOrder = props.layoutOrder,
		padding = { top = UDim.new(0, props.topInset) }
	}, {
		CloseButton = module.createElement(iconButton, {
			icon = iconName.X,
			isCircular = false,
			size = inputSize.Medium,
			variant = buttonVariant.Utility,
			onActivated = props.onClose
		})
	})
end

return DashboardTopBar
