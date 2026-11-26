local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local module = require("@luauforge/deferred/gzS")

local module2 = require("@luauforge/deferred/gzT")
local view = module2.View
local icon = module2.Icon
local iconSize = module2.Enums.IconSize
local text = module2.Text
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/deferred/gBa")
local triangleExclamation = module3.Icon.TriangleExclamation
local iconVariant = module3.IconVariant

local function SuspensionDurationAlert(p2)
	local v5 = useTokens()
	local translations = useNotApprovedPageContext().translations

	return module.createElement(
		view,
		{
			tag = "size-full-0 auto-y row gap-medium padding-medium align-y-center stroke-thick stroke-default radius-medium bg-shift-100",
			LayoutOrder = p2.layoutOrder,
			testId = "suspension-duration-alert"
		},
		{
			Icon = module.createElement(icon, {
				name = triangleExclamation,
				size = iconSize.Medium,
				variant = iconVariant.Filled,
				style = v5.Color.System.Warning,
				LayoutOrder = 1
			}),
			Text = module.createElement(view, {
				tag = "auto-xy row gap-xsmall",
				LayoutOrder = 2
			}, {
				Label = module.createElement(text, {
					tag = "auto-xy text-title-medium content-emphasis text-align-x-left text-wrap",
					Text = translations.suspensionLabel,
					LayoutOrder = 1
				}),
				Value = module.createElement(text, {
					tag = "auto-xy text-body-medium text-align-x-left text-wrap",
					Text = p2.timeRemaining,
					LayoutOrder = 2
				})
			})
		}
	)
end

return module.memo(SuspensionDurationAlert)
