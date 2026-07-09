local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local BuilderIcons = require(NotApprovedPageParent.BuilderIcons)
local TriangleExclamation = BuilderIcons.Icon.TriangleExclamation
local IconVariant = BuilderIcons.IconVariant

local function SuspensionDurationAlert(t1: {[any]: any}) -- line: 28
	-- upvalues: useTokens (copy), useNotApprovedPageContext (copy), React (copy), View (copy), Icon (copy), TriangleExclamation (copy), IconSize (copy), IconVariant (copy), FoundationText (copy)
	local v16 = useTokens()
	local translations = useNotApprovedPageContext().translations

	return React.createElement(View, {
		tag = "size-full-0 auto-y row gap-medium padding-medium align-y-center stroke-thick stroke-default radius-medium bg-shift-100",
		testId = "suspension-duration-alert",
		LayoutOrder = t1.layoutOrder
	}, {
		Icon = React.createElement(Icon, {
			LayoutOrder = 1,
			name = TriangleExclamation,
			size = IconSize.Medium,
			variant = IconVariant.Filled,
			style = v16.Color.System.Warning
		}),
		Text = React.createElement(View, {
			tag = "auto-xy row gap-xsmall",
			LayoutOrder = 2
		}, {
			Label = React.createElement(FoundationText, {
				tag = "auto-xy text-title-medium content-emphasis text-align-x-left text-wrap",
				LayoutOrder = 1,
				Text = translations.suspensionLabel
			}),
			Value = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left text-wrap",
				LayoutOrder = 2,
				Text = t1.timeRemaining
			})
		})
	})
end

return React.memo(SuspensionDurationAlert)
