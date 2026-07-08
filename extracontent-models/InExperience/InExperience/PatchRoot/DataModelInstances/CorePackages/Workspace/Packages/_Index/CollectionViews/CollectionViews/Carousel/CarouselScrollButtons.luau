local Parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(Parent.React)
local ReactIs = require(Parent.ReactIs)
local Foundation = require(Parent.Foundation)
local ControlState = Foundation.Enums.ControlState
local IconSize = Foundation.Enums.IconSize
local Icon = Foundation.Icon
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function ScrollButton(t1: {[any]: any}) -- line: 41
	-- upvalues: useTokens (copy), React (copy), ControlState (copy), View (copy), Icon (copy), IconSize (copy)
	local v13 = useTokens()
	local v14 = React.useCallback(function(p1) -- line: 43
		-- upvalues: ControlState (copy), t1 (copy)
		if p1 == ControlState.Hover or p1 == ControlState.Pressed then
			if t1.onScrollButtonEnter then
				t1.onScrollButtonEnter()

				return
			end
		elseif t1.onScrollButtonLeave then
			t1.onScrollButtonLeave()
		end
	end, {
		t1.onScrollButtonEnter,
		t1.onScrollButtonLeave
	})

	return React.createElement(View, {
		tag = "size-1000 radius-circle bg-over-media-100",
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		Visible = t1.Visible,
		onStateChanged = v14,
		onActivated = t1.onActivated
	}, {
		Icon = React.createElement(Icon, {
			name = t1.icon,
			size = IconSize.Large,
			style = v13.Color.Content.Emphasis,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	})
end
local function CarouselScrollButtons(t2: {[any]: any}) -- line: 73
	-- upvalues: React (copy), ReactIs (copy), ScrollButton (copy)
	local v16 = t2.buttonOffsetFromEdge or 0
	local v17, v18 = React.useState(false)
	local v19 = if not ReactIs.isBinding(t2.leftScrollingEnabled) then v17 and t2.leftScrollingEnabled else t2.leftScrollingEnabled:map(function(b1: boolean) -- line: 81
		-- upvalues: v17 (copy)
		return v17 and b1
	end)
	local v20 = if not ReactIs.isBinding(t2.rightScrollingEnabled) then v17 and t2.rightScrollingEnabled else t2.rightScrollingEnabled:map(function(b2: boolean) -- line: 92
		-- upvalues: v17 (copy)
		return v17 and b2
	end)
	local v21 = React.useCallback(function() -- line: 100
		-- upvalues: v18 (copy)
		v18(true)
	end, {})
	local v22 = React.useCallback(function() -- line: 103
		-- upvalues: v18 (copy)
		v18(false)
	end, {})

	return React.createElement("Frame", {
		AnchorPoint = t2.AnchorPoint,
		Position = t2.Position,
		Size = t2.Size,
		ZIndex = t2.ZIndex or 10,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		[React.Event.MouseEnter] = v21,
		[React.Event.MouseLeave] = v22
	}, {
		LeftScrollButton = React.createElement(ScrollButton, {
			icon = "chevron-large-left",
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, v16, 0.5, 0),
			Visible = v19,
			onScrollButtonEnter = t2.onScrollButtonEnter,
			onScrollButtonLeave = t2.onScrollButtonLeave,
			onActivated = t2.handleScrollLeft
		}),
		RightScrollButton = React.createElement(ScrollButton, {
			icon = "chevron-large-right",
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -v16, 0.5, 0),
			Visible = v20,
			onScrollButtonEnter = t2.onScrollButtonEnter,
			onScrollButtonLeave = t2.onScrollButtonLeave,
			onActivated = t2.handleScrollRight
		})
	})
end

return CarouselScrollButtons
