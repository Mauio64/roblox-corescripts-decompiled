local parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

local Foundation = require(parent.Foundation)
local ControlState = Foundation.Enums.ControlState
local IconSize = Foundation.Enums.IconSize
local Icon = Foundation.Icon
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ScrollButton(props)
	local v = useTokens()
	local onStateChanged = React.useCallback(function(p)
		if p == ControlState.Hover or p == ControlState.Pressed then
			if props.onScrollButtonEnter then
				props.onScrollButtonEnter()
			end
		elseif props.onScrollButtonLeave then
			props.onScrollButtonLeave()
		end
	end, { props.onScrollButtonEnter, props.onScrollButtonLeave })

	return React.createElement(View, {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Visible = props.Visible,
		onStateChanged = onStateChanged,
		onActivated = props.onActivated,
		tag = "size-1000 radius-circle bg-over-media-100"
	}, {
		Icon = React.createElement(Icon, {
			name = props.icon,
			size = IconSize.Large,
			style = v.Color.Content.Emphasis,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
end

local function CarouselScrollButtons(props)
	local buttonOffsetFromEdge = props.buttonOffsetFromEdge or 0

	local state, setState = React.useState(false)
	local visible

	if ReactIs.isBinding(props.leftScrollingEnabled) then
		visible = props.leftScrollingEnabled:map(function(flag: boolean)
			return state and flag
		end)
	else
		visible = state and props.leftScrollingEnabled
	end

	local visible2

	if ReactIs.isBinding(props.rightScrollingEnabled) then
		visible2 = props.rightScrollingEnabled:map(function(flag: boolean)
			return state and flag
		end)
	else
		visible2 = state and props.rightScrollingEnabled
	end

	local v = React.useCallback(function()
		setState(true)
	end, {})
	local v2 = React.useCallback(function()
		setState(false)
	end, {})

	return React.createElement("Frame", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,
		ZIndex = props.ZIndex or 10,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.MouseEnter] = v,
		[React.Event.MouseLeave] = v2
	}, {
		LeftScrollButton = React.createElement(ScrollButton, {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, buttonOffsetFromEdge, 0.5, 0),
			Visible = visible,
			icon = "chevron-large-left",
			onScrollButtonEnter = props.onScrollButtonEnter,
			onScrollButtonLeave = props.onScrollButtonLeave,
			onActivated = props.handleScrollLeft
		}),
		RightScrollButton = React.createElement(ScrollButton, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -buttonOffsetFromEdge, 0.5, 0),
			Visible = visible2,
			icon = "chevron-large-right",
			onScrollButtonEnter = props.onScrollButtonEnter,
			onScrollButtonLeave = props.onScrollButtonLeave,
			onActivated = props.handleScrollRight
		})
	})
end

return CarouselScrollButtons
