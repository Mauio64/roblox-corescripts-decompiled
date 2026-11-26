local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useTokens = Foundation.Hooks.useTokens
local text = Foundation.Text
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local statusIndicator = Foundation.StatusIndicator
local statusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Constants")
local getTestId = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local function PrimaryNavigationItem(props)
	local v5 = useTokens()
	local createElement = React.createElement
	local view = Foundation.View
	local v6 = { tag = "size-full-0 auto-y", LayoutOrder = props.layoutOrder }

	local createElement2 = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = "",
		[React.Event.Activated] = props.onActivated
	}
	local tag = React.Tag
	local v10 = if fFlagLuaAppAddTestIdsForArrow then getTestId("core-ui-flyout-nav-item", props.testId) else nil
	v9[tag] = v10

	local v11 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Gap.Small)
		}),
		IconContainer = 0,
		Text = 0
	}

	local v12 = if props.icon then React.createElement(
		Foundation.View,
		{ tag = "auto-xy padding-small", LayoutOrder = 1 },
		{
			Icon = React.createElement(icon, {
				style = v5.Color.Content.Emphasis,
				name = props.icon,
				size = iconSize.Medium
			})
		}
	) else nil
	v11.IconContainer = v12

	local v13 = if props.text then React.createElement(text, {
		LayoutOrder = 2,
		Text = props.text,
		tag = "auto-xy padding-y-small text-align-x-left text-truncate-end text-title-large text-wrap content-emphasis"
	}) else nil
	v11.Text = v13
	local v7 = {
		PrimaryNavigationButton = createElement2("TextButton", v9, v11),
		StatusIndicator = 0
	}

	local v14 = if props.notificationCount then React.createElement(statusIndicator, {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -v5.Gap.Medium, 0.5, 0),
		LayoutOrder = 3,
		value = props.notificationCount,
		variant = statusIndicatorVariant.Emphasis,
		max = Constants.MAX_SHOWN_STATUS_INDICATOR_COUNT
	}) else nil
	v7.StatusIndicator = v14
	return createElement(view, v6, v7)
end

return PrimaryNavigationItem
