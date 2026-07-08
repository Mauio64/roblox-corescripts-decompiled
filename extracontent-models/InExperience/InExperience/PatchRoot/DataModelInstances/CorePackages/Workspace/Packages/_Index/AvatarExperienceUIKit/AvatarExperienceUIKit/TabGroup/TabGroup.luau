local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local useAnimatedBinding = require(AvatarExperienceUIKitParent.ReactOtter).useAnimatedBinding
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local ScrollingFrameWithIndicators = require(AvatarExperienceUIKit.ScrollingFrameWithIndicators.ScrollingFrameWithIndicators)
local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)
local TabGroupTab = require(script.Parent.TabGroupTab)
local t1 = {
	FillDirection = Enum.FillDirection.Horizontal,
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalFlex = Enum.UIFlexAlignment.None
}
local t2 = {
	Transparency = 1
}
local t3 = {
	dampingRatio = 1,
	frequency = 5
}

local function getActiveTabPosition(n1: number) -- line: 59
	return UDim2.new(0, n1, 1, 0)
end
local function getActiveTabSize(n2: number) -- line: 63
	return UDim2.new(0, n2, 0, 3)
end
local function TabGroup(t4: {[any]: any}, p1) -- line: 67
	-- upvalues: useTokens (copy), useAnimatedBinding (copy), React (copy), makeOtterSpringValue (copy), t3 (copy), TabGroupTab (copy), getActiveTabPosition (copy), getActiveTabSize (copy), ScrollingFrameWithIndicators (copy), View (copy), t2 (copy), t1 (copy)
	local v21 = useTokens()
	local v22, v23 = useAnimatedBinding(0)
	local v24, v25 = useAnimatedBinding(0)
	local v26 = React.useRef(nil)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = React.useCallback(function() -- line: 78
		-- upvalues: v28 (copy), v26 (copy), v27 (copy)
		local current = v28.current
		local current2 = v26.current
		local current3 = v27.current

		if not current or (not current2 or not current3) then
			return
		end

		local v40 = current.getScrollingFrame()

		if not v40 then
			return
		end

		local AbsoluteSizeX = v40.AbsoluteSize.X

		if AbsoluteSizeX <= 0 then
			return
		end

		local CanvasPositionX = v40.CanvasPosition.X
		local v43 = current3.AbsolutePosition.X - current2.AbsolutePosition.X
		local v44 = v43 + current3.AbsoluteSize.X

		if v43 < CanvasPositionX then
			current.scrollToOffset(v43)

			return
		end

		if v44 > CanvasPositionX + AbsoluteSizeX then
			current.scrollToOffset(v44 - AbsoluteSizeX)
		end
	end, {})
	local v30 = React.useCallback(function(p2) -- line: 107
		-- upvalues: v26 (copy), v27 (copy), t4 (copy), v23 (copy), makeOtterSpringValue (copy), t3 (copy), v25 (copy), v29 (copy)
		local current = v26.current

		v27.current = p2

		for _, v48 in t4.items do
			if v48.id == t4.activeTabId and v48.ref then
				v48.ref.current = p2
			end
		end

		if p2 and current then
			v23(makeOtterSpringValue(p2.AbsolutePosition.X - current.AbsolutePosition.X, t3))
			v25(makeOtterSpringValue(p2.AbsoluteSize.X, t3))
			v29()
		end
	end, {
		t4.activeTabId,
		t4.items,
		v29
	})

	React.useEffect(function() -- line: 130
		-- upvalues: v26 (copy), v27 (copy), v23 (copy), makeOtterSpringValue (copy), t3 (copy), v25 (copy), v29 (copy)
		local current = v26.current
		local current4 = v27.current

		if current4 and current then
			v23(makeOtterSpringValue(current4.AbsolutePosition.X - current.AbsolutePosition.X, t3))
			v25(makeOtterSpringValue(current4.AbsoluteSize.X, t3))
			v29()
		end
	end, { v29 })

	local t5 = {}

	for v32, v33 in t4.items do
		local v34 = t4.activeTabId == v33.id

		t5[v33.id] = React.createElement(TabGroupTab, {
			ref = if not v34 then v33.ref else v30,
			text = v33.text,
			onActivated = if not t4.onTabActivated then nil else function() -- line: 152
				-- upvalues: t4 (copy), v33 (copy)
				t4.onTabActivated(v33.id)
			end,
			isActive = v34,
			fontStyle = t4.tabFontStyle,
			padding = t4.tabPadding,
			textStyle = t4.tabTextStyle,
			activeTextStyle = t4.tabActiveTextStyle,
			LayoutOrder = v32
		})
	end

	local v35 = React.useMemo(function() -- line: 165
		-- upvalues: v22 (copy), getActiveTabPosition (copy)
		return v22:map(getActiveTabPosition)
	end, {})
	local v36 = React.useMemo(function() -- line: 169
		-- upvalues: v24 (copy), getActiveTabSize (copy)
		return v24:map(getActiveTabSize)
	end, {})

	return React.createElement(ScrollingFrameWithIndicators, {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = t4.BackgroundTransparency,
		BackgroundColor3 = t4.BackgroundColor3,
		LayoutOrder = t4.LayoutOrder,
		Position = t4.Position,
		ZIndex = t4.ZIndex,
		ref = p1,
		controllerRef = v28
	}, {
		InnerNavigation = React.createElement(View, {
			ClipsDescendants = false,
			ZIndex = -1,
			ref = v26,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = t2,
			layout = t1
		}, t5),
		ActiveTabIndicator = React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = v35,
			Size = v36,
			BackgroundColor3 = v21.Color.Content.Emphasis.Color3,
			AnchorPoint = Vector2.new(0, 1)
		})
	})
end

return React.forwardRef(TabGroup)
