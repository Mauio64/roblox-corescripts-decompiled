local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local Flags = Foundation.Utility.Flags
local Constants = require(script.Parent.Parent.Constants)

local function PrimaryNavigationItem(p1) -- line: 22
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), Icon (copy), IconSize (copy), FoundationText (copy), StatusIndicator (copy), Flags (copy), StatusIndicatorVariant (copy), Constants (copy)
	local v14 = useTokens()

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = p1.layoutOrder
	}, {
		PrimaryNavigationButton = React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = p1.onActivated
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v14.Gap.Small)
			}),
			IconContainer = if not p1.icon then nil else React.createElement(Foundation.View, {
				tag = "auto-xy padding-small",
				LayoutOrder = 1
			}, {
				Icon = React.createElement(Icon, {
					style = v14.Color.Content.Emphasis,
					name = p1.icon,
					size = IconSize.Medium
				})
			}),
			Text = if not p1.text then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy padding-y-small text-align-x-left text-truncate-end text-title-large text-wrap content-emphasis",
				Text = p1.text
			})
		}),
		StatusIndicator = if not p1.notificationCount then nil else React.createElement(StatusIndicator, {
			LayoutOrder = 3,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -v14.Gap.Medium, 0.5, 0),
			value = p1.notificationCount,
			variant = if not Flags.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Contrast_Experiment,
			max = Constants.MAX_SHOWN_STATUS_INDICATOR_COUNT
		})
	})
end

return PrimaryNavigationItem
