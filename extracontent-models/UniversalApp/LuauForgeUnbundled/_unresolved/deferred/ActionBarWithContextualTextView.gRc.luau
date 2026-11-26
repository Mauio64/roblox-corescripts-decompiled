local CorePackages = game:GetService("CorePackages")
local packages = CorePackages.Packages
local React = require(packages.React)
local Foundation = require(packages.Foundation)

local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local fillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens

local function ActionBarWithContextualTextView(props)
	local v5 = useTokens()

	return React.createElement(Foundation.View, {
		tag = {
			["data-testid=ActionBarWithContextualTextView"] = true,
			["size-full-0 auto-y"] = true
		},
		LayoutOrder = props.LayoutOrder
	}, {
		TopBorder = React.createElement(Foundation.View, {
			backgroundStyle = v5.Color.Stroke.Default,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, -1),
			ZIndex = 2
		}),
		Content = React.createElement(
			Foundation.View,
			{ tag = "col gap-large size-full-0 auto-y padding-medium bg-surface-0" },
			{
				Title = React.createElement(
					Foundation.View,
					{
						tag = "row wrap items-center gap-xsmall size-full-0 auto-y",
						LayoutOrder = 1
					},
					{
						TitleText = React.createElement(Foundation.Text, {
							tag = "auto-xy text-title-medium text-align-x-left content-emphasis",
							Text = props.titleText,
							LayoutOrder = 1
						})
					}
				),
				Buttons = React.createElement(
					Foundation.View,
					{ tag = "row gap-small size-full-0 auto-y", LayoutOrder = 2 },
					{
						ActionButton = React.createElement(Foundation.Button, {
							text = props.actionButtonText,
							onActivated = props.onActionActivated,
							variant = buttonVariant.Emphasis,
							size = buttonSize.Medium,
							fillBehavior = fillBehavior.Fill,
							isDisabled = props.isActionDisabled,
							isLoading = props.isActionLoading,
							LayoutOrder = 1
						}),
						MoreButton = React.createElement(Foundation.Button, {
							icon = "circle-three-dots-horizontal",
							onActivated = props.onMoreActivated,
							variant = buttonVariant.Standard,
							size = buttonSize.Medium,
							LayoutOrder = 2
						})
					}
				)
			}
		)
	})
end

return ActionBarWithContextualTextView
