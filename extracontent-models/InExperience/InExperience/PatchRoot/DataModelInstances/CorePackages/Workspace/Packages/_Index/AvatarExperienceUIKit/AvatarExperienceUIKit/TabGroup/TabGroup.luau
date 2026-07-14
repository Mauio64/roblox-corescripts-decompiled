local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local useAnimatedBinding = require(AvatarExperienceUIKitParent.ReactOtter).useAnimatedBinding
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local ScrollingFrameWithIndicators = require(AvatarExperienceUIKit.ScrollingFrameWithIndicators.ScrollingFrameWithIndicators)
local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)
local FFlagAXResetSubcategoryRowOnCategoryChange = require(AvatarExperienceUIKitParent.AvatarExperienceFlags).FFlagAXResetSubcategoryRowOnCategoryChange
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

local function getActiveTabPosition(n1: number) -- line: 62
	return UDim2.new(0, n1, 1, 0)
end
local function getActiveTabSize(n2: number) -- line: 66
	return UDim2.new(0, n2, 0, 3)
end
local function TabGroup(t4: {[any]: any}, p1) -- line: 70
	-- upvalues: useTokens (copy), useAnimatedBinding (copy), React (copy), makeOtterSpringValue (copy), t3 (copy), FFlagAXResetSubcategoryRowOnCategoryChange (copy), TabGroupTab (copy), getActiveTabPosition (copy), getActiveTabSize (copy), ScrollingFrameWithIndicators (copy), View (copy), t2 (copy), t1 (copy)
	local v22 = useTokens()
	local v23, v24 = useAnimatedBinding(0)
	local v25, v26 = useAnimatedBinding(0)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = React.useRef(nil)
	local v30 = React.useCallback(function() -- line: 81
		-- upvalues: v29 (copy), v27 (copy), v28 (copy)
		local current = v29.current
		local current2 = v27.current
		local current3 = v28.current

		if not current or (not current2 or not current3) then
			return
		end

		local v41 = current.getScrollingFrame()

		if not v41 then
			return
		end

		local AbsoluteSizeX = v41.AbsoluteSize.X

		if AbsoluteSizeX <= 0 then
			return
		end

		local CanvasPositionX = v41.CanvasPosition.X
		local v44 = current3.AbsolutePosition.X - current2.AbsolutePosition.X
		local v45 = v44 + current3.AbsoluteSize.X

		if v44 < CanvasPositionX then
			current.scrollToOffset(v44)

			return
		end

		if v45 > CanvasPositionX + AbsoluteSizeX then
			current.scrollToOffset(v45 - AbsoluteSizeX)
		end
	end, {})
	local v31 = React.useCallback(function(p2) -- line: 110
		-- upvalues: v27 (copy), v28 (copy), t4 (copy), v24 (copy), makeOtterSpringValue (copy), t3 (copy), v26 (copy), v30 (copy)
		local current = v27.current

		v28.current = p2

		for _, v49 in t4.items do
			if v49.id == t4.activeTabId and v49.ref then
				v49.ref.current = p2
			end
		end

		if p2 and current then
			v24(makeOtterSpringValue(p2.AbsolutePosition.X - current.AbsolutePosition.X, t3))
			v26(makeOtterSpringValue(p2.AbsoluteSize.X, t3))
			v30()
		end
	end, {
		t4.activeTabId,
		t4.items,
		v30
	})

	React.useEffect(function() -- line: 133
		-- upvalues: v27 (copy), v28 (copy), v24 (copy), makeOtterSpringValue (copy), t3 (copy), v26 (copy), v30 (copy)
		local current = v27.current
		local current4 = v28.current

		if current4 and current then
			v24(makeOtterSpringValue(current4.AbsolutePosition.X - current.AbsolutePosition.X, t3))
			v26(makeOtterSpringValue(current4.AbsoluteSize.X, t3))
			v30()
		end
	end, { v30 })

	if FFlagAXResetSubcategoryRowOnCategoryChange then
		React.useEffect(function() -- line: 155
			-- upvalues: t4 (copy), v28 (copy), v26 (copy), makeOtterSpringValue (copy), t3 (copy)
			local v52 = false

			if t4.activeTabId ~= nil then
				for _, v54 in t4.items do
					if v54.id == t4.activeTabId then
						v52 = true

						break
					end
				end
			end

			if not v52 then
				v28.current = nil
				v26(makeOtterSpringValue(0, t3))
			end
		end, {
			t4.activeTabId,
			t4.items
		})
		React.useImperativeHandle(t4.controllerRef, function() -- line: 173
			-- upvalues: v29 (copy)
			return {
				scrollToOffset = function(n3: number) -- line: 175
					-- upvalues: v29 (copy)
					local current = v29.current

					if current then
						current.scrollToOffset(n3)
					end
				end,
				setOffset = function(n4: number) -- line: 181
					-- upvalues: v29 (copy)
					local current = v29.current

					if current then
						current.setOffset(n4)
					end
				end,
				getScrollingFrame = function() -- line: 187
					-- upvalues: v29 (copy)
					local current = v29.current

					if current then
						return (current.getScrollingFrame())
					end

					return nil
				end
			}
		end, {})
	end

	local t5 = {}

	for v33, v34 in t4.items do
		local v35 = t4.activeTabId == v34.id

		t5[v34.id] = React.createElement(TabGroupTab, {
			ref = if not v35 then v34.ref else v31,
			text = v34.text,
			onActivated = if not t4.onTabActivated then nil else function() -- line: 202
				-- upvalues: t4 (copy), v34 (copy)
				t4.onTabActivated(v34.id)
			end,
			isActive = v35,
			fontStyle = t4.tabFontStyle,
			padding = t4.tabPadding,
			textStyle = t4.tabTextStyle,
			activeTextStyle = t4.tabActiveTextStyle,
			LayoutOrder = v33
		})
	end

	local v36 = React.useMemo(function() -- line: 215
		-- upvalues: v23 (copy), getActiveTabPosition (copy)
		return v23:map(getActiveTabPosition)
	end, {})
	local v37 = React.useMemo(function() -- line: 219
		-- upvalues: v25 (copy), getActiveTabSize (copy)
		return v25:map(getActiveTabSize)
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
		controllerRef = v29
	}, {
		InnerNavigation = React.createElement(View, {
			ClipsDescendants = false,
			ZIndex = -1,
			ref = v27,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = t2,
			layout = t1
		}, t5),
		ActiveTabIndicator = React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = v36,
			Size = v37,
			BackgroundColor3 = v22.Color.Content.Emphasis.Color3,
			AnchorPoint = Vector2.new(0, 1)
		})
	})
end

return React.forwardRef(TabGroup)
