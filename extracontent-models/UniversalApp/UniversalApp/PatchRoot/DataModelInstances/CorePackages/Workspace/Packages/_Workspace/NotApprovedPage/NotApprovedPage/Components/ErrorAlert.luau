local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local React = require(NotApprovedPageParent.React)
local Foundation = require(NotApprovedPageParent.Foundation)
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local BuilderIcons = require(NotApprovedPageParent.BuilderIcons)
local CircleX = BuilderIcons.Icon.CircleX
local IconVariant = BuilderIcons.IconVariant
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext

local function ErrorAlert(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), useNotApprovedPageContext (copy), React (copy), View (copy), Icon (copy), CircleX (copy), InputSize (copy), IconVariant (copy), FoundationText (copy), IconButton (copy), ButtonVariant (copy), ButtonSize (copy)
	local v19 = useTokens()
	local translations = useNotApprovedPageContext().translations

	return React.createElement(View, {
		tag = "size-full-0 auto-y row flex-between gap-medium padding-medium radius-medium align-y-center stroke-standard stroke-system-alert",
		testId = "error-alert",
		backgroundStyle = {
			Transparency = 0.9,
			Color3 = v19.Color.System.Alert.Color3
		},
		LayoutOrder = t1.layoutOrder or 1
	}, {
		Container = React.createElement(View, {
			tag = "auto-xy row gap-small align-y-center",
			LayoutOrder = 1
		}, {
			Icon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = CircleX,
				size = InputSize.Medium,
				variant = IconVariant.Filled,
				style = v19.Color.System.Alert
			}),
			Text = React.createElement(FoundationText, {
				tag = "auto-xy text-body-medium text-align-x-left text-wrap content-emphasis",
				LayoutOrder = 2,
				Text = translations.errorMessage
			})
		}),
		Button = React.createElement(IconButton, {
			icon = "x-small",
			isCircular = true,
			LayoutOrder = 2,
			variant = ButtonVariant.Utility,
			onActivated = t1.onClose,
			size = ButtonSize.Small
		})
	})
end

return React.memo(ErrorAlert)
