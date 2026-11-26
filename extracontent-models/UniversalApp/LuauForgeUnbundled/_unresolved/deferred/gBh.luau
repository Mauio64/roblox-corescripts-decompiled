local module = require("@luauforge/deferred/gzS")

local module2 = require("@luauforge/deferred/gzT")
local buttonSize = module2.Enums.ButtonSize
local buttonVariant = module2.Enums.ButtonVariant
local icon = module2.Icon
local iconButton = module2.IconButton
local inputSize = module2.Enums.InputSize
local text = module2.Text
local view = module2.View
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/deferred/gBa")
local circleX = module3.Icon.CircleX
local iconVariant = module3.IconVariant

local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local function ErrorAlert(p2)
	local v5 = useTokens()
	local translations = useNotApprovedPageContext().translations

	return module.createElement(view, {
		tag = "size-full-0 auto-y row flex-between gap-medium padding-medium radius-medium align-y-center stroke-standard stroke-system-alert",
		backgroundStyle = { Color3 = v5.Color.System.Alert.Color3, Transparency = 0.9 },
		LayoutOrder = p2.layoutOrder or 1,
		testId = "error-alert"
	}, {
		Container = module.createElement(
			view,
			{ tag = "auto-xy row gap-small align-y-center", LayoutOrder = 1 },
			{
				Icon = module.createElement(icon, {
					name = circleX,
					size = inputSize.Medium,
					variant = iconVariant.Filled,
					style = v5.Color.System.Alert,
					LayoutOrder = 1
				}),
				Text = module.createElement(text, {
					tag = "auto-xy text-body-medium text-align-x-left text-wrap content-emphasis",
					Text = translations.errorMessage,
					LayoutOrder = 2
				})
			}
		),
		Button = module.createElement(iconButton, {
			icon = "x-small",
			variant = buttonVariant.Utility,
			isCircular = true,
			onActivated = p2.onClose,
			LayoutOrder = 2,
			size = buttonSize.Small
		})
	})
end

return module.memo(ErrorAlert)
