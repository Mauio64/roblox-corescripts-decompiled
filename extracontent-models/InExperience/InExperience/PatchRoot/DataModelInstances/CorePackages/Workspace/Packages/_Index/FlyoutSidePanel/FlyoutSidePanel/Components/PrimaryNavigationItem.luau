local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local Constants = require(script.Parent.Parent.Constants)
local RoactUtils = require(parent.RoactUtils)
local getTestId = RoactUtils.getTestId
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow

local function PrimaryNavigationItem(props)
	local v = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v2 = { tag = "size-full-0 auto-y", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v4 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = "",
		[React.Event.Activated] = props.onActivated
	}
	local tag = React.Tag
	local v5

	if FFlagLuaAppAddTestIdsForArrow then
		v5 = getTestId("core-ui-flyout-nav-item", props.testId)
	end

	v4[tag] = v5

	local v6 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v.Gap.Small)
		}),
		IconContainer = 0,
		Text = 0
	}
	local iconContainer

	if props.icon then
		iconContainer = React.createElement(Foundation.View, {
			tag = "auto-xy padding-small",
			LayoutOrder = 1
		}, {
			Icon = React.createElement(Icon, {
				style = v.Color.Content.Emphasis,
				name = props.icon,
				size = IconSize.Medium
			})
		})
	end

	v6.IconContainer = iconContainer
	local text

	if props.text then
		text = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.text,
			tag = "auto-xy padding-y-small text-align-x-left text-truncate-end text-title-large text-wrap content-emphasis"
		})
	end

	v6.Text = text
	local v3 = {
		PrimaryNavigationButton = createElement2("TextButton", v4, v6),
		StatusIndicator = 0
	}
	local statusIndicator

	if props.notificationCount then
		statusIndicator = React.createElement(StatusIndicator, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -v.Gap.Medium, 0.5, 0),
			LayoutOrder = 3,
			value = props.notificationCount,
			variant = StatusIndicatorVariant.Emphasis,
			max = Constants.MAX_SHOWN_STATUS_INDICATOR_COUNT
		})
	end

	v3.StatusIndicator = statusIndicator
	return createElement(view, v2, v3)
end

return PrimaryNavigationItem
