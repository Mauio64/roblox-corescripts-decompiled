local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/React")
local ReactIs = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/ReactIs")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/Foundation")
local controlState = Foundation.Enums.ControlState
local iconSize = Foundation.Enums.IconSize
local icon = Foundation.Icon
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ScrollButton(props)
	local v5 = useTokens()
	local v6 = React.useCallback(function(p2)
		if p2 == controlState.Hover or p2 == controlState.Pressed then
			if props.onScrollButtonEnter then
				props.onScrollButtonEnter()
			end
		elseif props.onScrollButtonLeave then
			props.onScrollButtonLeave()
		end
	end, { props.onScrollButtonEnter, props.onScrollButtonLeave })

	return React.createElement(view, {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Visible = props.Visible,
		onStateChanged = v6,
		onActivated = props.onActivated,
		tag = "size-1000 radius-circle bg-over-media-100"
	}, {
		Icon = React.createElement(icon, {
			name = props.icon,
			size = iconSize.Large,
			style = v5.Color.Content.Emphasis,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
end

local function CarouselScrollButtons(props)
	local buttonOffsetFromEdge = props.buttonOffsetFromEdge or 0

	local state, setState = React.useState(false)
	local v5

	if ReactIs.isBinding(props.leftScrollingEnabled) then
		v5 = props.leftScrollingEnabled:map(function(p2)
			return state and p2
		end)
	else
		v5 = state and props.leftScrollingEnabled
	end

	local v6

	if ReactIs.isBinding(props.rightScrollingEnabled) then
		v6 = props.rightScrollingEnabled:map(function(p2)
			return state and p2
		end)
	else
		v6 = state and props.rightScrollingEnabled
	end

	local v7 = React.useCallback(function()
		setState(true)
	end, {})
	local v8 = React.useCallback(function()
		setState(false)
	end, {})

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		ZIndex = props.ZIndex or 10,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.MouseEnter] = v7,
		[React.Event.MouseLeave] = v8
	}, {
		LeftScrollButton = React.createElement(ScrollButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, buttonOffsetFromEdge, 0.5, 0),
			Visible = v5,
			icon = "chevron-large-left",
			onScrollButtonEnter = props.onScrollButtonEnter,
			onScrollButtonLeave = props.onScrollButtonLeave,
			onActivated = props.handleScrollLeft
		}),
		RightScrollButton = React.createElement(ScrollButton, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -buttonOffsetFromEdge, 0.5, 0),
			Visible = v6,
			icon = "chevron-large-right",
			onScrollButtonEnter = props.onScrollButtonEnter,
			onScrollButtonLeave = props.onScrollButtonLeave,
			onActivated = props.handleScrollRight
		})
	})
end

return CarouselScrollButtons
