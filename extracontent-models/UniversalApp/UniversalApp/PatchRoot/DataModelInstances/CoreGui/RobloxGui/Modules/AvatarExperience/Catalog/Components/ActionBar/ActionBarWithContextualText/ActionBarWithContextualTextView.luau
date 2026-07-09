local Packages = game:GetService("CorePackages").Packages
local React = require(Packages.React)
local Foundation = require(Packages.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens

local function ActionBarWithContextualTextView(t1: {[any]: any}) -- line: 36
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), ButtonVariant (copy), ButtonSize (copy), FillBehavior (copy)
	local v10 = useTokens()

	return React.createElement(Foundation.View, {
		tag = {
			["data-testid=ActionBarWithContextualTextView"] = true,
			["size-full-0 auto-y"] = true
		},
		LayoutOrder = t1.LayoutOrder
	}, {
		TopBorder = React.createElement(Foundation.View, {
			ZIndex = 2,
			backgroundStyle = v10.Color.Stroke.Default,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, -1)
		}),
		Content = React.createElement(Foundation.View, {
			tag = "col gap-large size-full-0 auto-y padding-medium bg-surface-0"
		}, {
			Title = React.createElement(Foundation.View, {
				tag = "row wrap items-center gap-xsmall size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				TitleText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
					LayoutOrder = 1,
					Text = t1.titleText
				})
			}),
			Buttons = React.createElement(Foundation.View, {
				tag = "row gap-small size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				ActionButton = React.createElement(Foundation.Button, {
					LayoutOrder = 1,
					text = t1.actionButtonText,
					onActivated = t1.onActionActivated,
					variant = ButtonVariant.Emphasis,
					size = ButtonSize.Medium,
					fillBehavior = FillBehavior.Fill,
					isDisabled = t1.isActionDisabled,
					isLoading = t1.isActionLoading
				}),
				MoreButton = React.createElement(Foundation.Button, {
					icon = "circle-three-dots-horizontal",
					LayoutOrder = 2,
					onActivated = t1.onMoreActivated,
					variant = ButtonVariant.Standard,
					size = ButtonSize.Medium
				})
			})
		})
	})
end

return ActionBarWithContextualTextView
