local GamepadService = game:GetService("GamepadService")
local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local ReactOtter = require(AvatarExperienceUIKitParent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local ScrollingFrameWithIndicators = require(AvatarExperienceUIKit.ScrollingFrameWithIndicators.ScrollingFrameWithIndicators)
local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)
local getCenterScrollOffset = require(AvatarExperienceUIKit.Utils.getCenterScrollOffset)
local AvatarExperienceFlags = require(AvatarExperienceUIKitParent.AvatarExperienceFlags)
local FFlagAXCategoryMenuVisualFixes = AvatarExperienceFlags.FFlagAXCategoryMenuVisualFixes
local FFlagAXScrollHighlightedTabIntoView = AvatarExperienceFlags.FFlagAXScrollHighlightedTabIntoView
local t1 = {
	Transparency = 1
}
local TabGroupTab = require(script.Parent.TabGroupTab)
local t2 = {
	FillDirection = Enum.FillDirection.Horizontal,
	SortOrder = Enum.SortOrder.LayoutOrder,
	HorizontalFlex = Enum.UIFlexAlignment.None
}
local t3 = {
	Transparency = 1
}
local t4 = {
	dampingRatio = 1,
	frequency = 5
}

local function getActiveTabPosition(n1: number) -- line: 70
	return UDim2.new(0, n1, 1, 0)
end
local function getActiveTabSize(n2: number) -- line: 74
	return UDim2.new(0, n2, 0, 3)
end
local function TabGroup(t5: {[any]: any}, p1) -- line: 78
	-- upvalues: useTokens (copy), useAnimatedBinding (copy), React (copy), FFlagAXCategoryMenuVisualFixes (copy), makeOtterSpringValue (copy), t4 (copy), ReactOtter (copy), FFlagAXScrollHighlightedTabIntoView (copy), getCenterScrollOffset (copy), GamepadService (copy), TabGroupTab (copy), getActiveTabPosition (copy), getActiveTabSize (copy), View (copy), t3 (copy), t2 (copy), ScrollingFrameWithIndicators (copy), t1 (copy)
	local v28 = useTokens()
	local v29, v30 = useAnimatedBinding(0)
	local v31, v32 = useAnimatedBinding(0)
	local v33 = React.useRef(nil)
	local v34 = React.useRef(nil)
	local v35 = React.useRef(nil)
	local v36 = React.useCallback(function(n3: number, n4: number, b1: boolean?) -- line: 87
		-- upvalues: FFlagAXCategoryMenuVisualFixes (copy), v31 (copy), v30 (copy), makeOtterSpringValue (copy), t4 (copy), v32 (copy), ReactOtter (copy)
		if not b1 and (not FFlagAXCategoryMenuVisualFixes or v31:getValue() > 0) then
			v30(makeOtterSpringValue(n3, t4))
			v32(makeOtterSpringValue(n4, t4))

			return
		end

		v30(ReactOtter.instant(n3))
		v32(ReactOtter.instant(n4))
	end, {})
	local v37 = React.useCallback(function() -- line: 100
		-- upvalues: v35 (copy), v33 (copy), v34 (copy)
		local current = v35.current
		local current2 = v33.current
		local current3 = v34.current

		if not current or (not current2 or not current3) then
			return
		end

		local v54 = current.getScrollingFrame()

		if not v54 then
			return
		end

		local AbsoluteSizeX = v54.AbsoluteSize.X

		if AbsoluteSizeX <= 0 then
			return
		end

		local CanvasPositionX = v54.CanvasPosition.X
		local v57 = current3.AbsolutePosition.X - current2.AbsolutePosition.X
		local v58 = v57 + current3.AbsoluteSize.X

		if v57 < CanvasPositionX then
			current.scrollToOffset(v57)

			return
		end

		if v58 > CanvasPositionX + AbsoluteSizeX then
			current.scrollToOffset(v58 - AbsoluteSizeX)
		end
	end, {})
	local u38 = nil

	if FFlagAXScrollHighlightedTabIntoView then
		u38 = React.useCallback(function(p2) -- line: 137
			-- upvalues: v35 (copy), getCenterScrollOffset (copy)
			local current = v35.current

			if not current then
				return
			end

			local v61 = current.getScrollingFrame()

			if not v61 then
				return
			end

			if not p2 or not p2:IsDescendantOf(game) or not p2:IsDescendantOf(v61) then
				return
			end

			local AbsoluteWindowSizeX = v61.AbsoluteWindowSize.X
			local CanvasPositionX = v61.CanvasPosition.X
			local v64 = p2.AbsolutePosition.X - v61.AbsolutePosition.X + CanvasPositionX
			local v65 = getCenterScrollOffset(v64, p2.AbsoluteSize.X, CanvasPositionX, AbsoluteWindowSizeX)

			if v65 == nil then
				return
			end

			current.scrollToOffset(v65)
		end, {})
	end

	local v39 = React.useCallback(function(p3) -- line: 167
		-- upvalues: v33 (copy), v34 (copy), t5 (copy), v36 (copy), FFlagAXScrollHighlightedTabIntoView (copy), u38 (ref), v37 (copy)
		local current = v33.current

		v34.current = p3

		for _, v69 in t5.items do
			if v69.id == t5.activeTabId and v69.ref then
				v69.ref.current = p3
			end
		end

		if p3 and current then
			local v70 = p3.AbsolutePosition.X - current.AbsolutePosition.X
			local AbsoluteSizeX = p3.AbsoluteSize.X

			v36(v70, AbsoluteSizeX)

			if FFlagAXScrollHighlightedTabIntoView and u38 then
				u38(p3)

				return
			end

			v37()
		end
	end, {
		t5.activeTabId,
		t5.items,
		v37,
		u38,
		v36
	})

	React.useEffect(function() -- line: 198
		-- upvalues: v33 (copy), v34 (copy), v36 (copy), FFlagAXCategoryMenuVisualFixes (copy), FFlagAXScrollHighlightedTabIntoView (copy), u38 (ref), v37 (copy)
		local current = v33.current
		local current4 = v34.current

		if current4 and current then
			local v74 = current4.AbsolutePosition.X - current.AbsolutePosition.X
			local AbsoluteSizeX = current4.AbsoluteSize.X

			v36(v74, AbsoluteSizeX, FFlagAXCategoryMenuVisualFixes)

			if FFlagAXScrollHighlightedTabIntoView and u38 then
				u38(current4)

				return
			end

			v37()
		end
	end, {
		v37,
		u38,
		v36
	})

	if FFlagAXScrollHighlightedTabIntoView then
		React.useEffect(function() -- line: 220
			-- upvalues: v35 (copy), GamepadService (copy), u38 (ref)
			local current = v35.current

			if not current then
				return
			end

			local v77 = current.getScrollingFrame()

			if not v77 then
				return
			end

			local connection = v77.SelectionChanged:Connect(function(_: boolean, _, p5) -- line: 232
				-- upvalues: GamepadService (copy), u38 (ref)
				if GamepadService.GamepadCursorEnabled then
					return
				end

				if u38 then
					u38(p5)
				end
			end)

			return function() -- line: 244
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, {})
	end

	if FFlagAXCategoryMenuVisualFixes then
		React.useEffect(function() -- line: 257
			-- upvalues: t5 (copy), v34 (copy), v30 (copy), ReactOtter (copy), v32 (copy)
			local v79 = false

			if t5.activeTabId ~= nil then
				for _, v81 in t5.items do
					if v81.id == t5.activeTabId then
						v79 = true

						break
					end
				end
			end

			if not v79 then
				v34.current = nil
				v30(ReactOtter.instant(0))
				v32(ReactOtter.instant(0))
			end
		end, {
			t5.activeTabId,
			t5.items
		})
		React.useImperativeHandle(t5.controllerRef, function() -- line: 276
			-- upvalues: v35 (copy)
			return {
				scrollToOffset = function(n5: number) -- line: 278
					-- upvalues: v35 (copy)
					local current = v35.current

					if current then
						current.scrollToOffset(n5)
					end
				end,
				setOffset = function(n6: number) -- line: 284
					-- upvalues: v35 (copy)
					local current = v35.current

					if current then
						current.setOffset(n6)
					end
				end,
				getScrollingFrame = function() -- line: 290
					-- upvalues: v35 (copy)
					local current = v35.current

					if current then
						return (current.getScrollingFrame())
					end

					return nil
				end
			}
		end, {})
	end

	local t6 = {}

	for v41, v42 in t5.items do
		local v43 = t5.activeTabId == v42.id

		t6[v42.id] = React.createElement(TabGroupTab, {
			ref = if not v43 then v42.ref else v39,
			text = v42.text,
			onActivated = if not t5.onTabActivated then nil else function() -- line: 305
				-- upvalues: t5 (copy), v42 (copy)
				t5.onTabActivated(v42.id)
			end,
			isActive = v43,
			fontStyle = t5.tabFontStyle,
			padding = t5.tabPadding,
			textStyle = t5.tabTextStyle,
			activeTextStyle = t5.tabActiveTextStyle,
			LayoutOrder = v41
		})
	end

	local v44 = React.useMemo(function() -- line: 318
		-- upvalues: v29 (copy), getActiveTabPosition (copy)
		return v29:map(getActiveTabPosition)
	end, {})
	local v45 = React.useMemo(function() -- line: 322
		-- upvalues: v31 (copy), getActiveTabSize (copy)
		return v31:map(getActiveTabSize)
	end, {})
	local v46 = React.createElement(View, {
		ZIndex = -1,
		ref = v33,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		backgroundStyle = t3,
		layout = t2
	}, t6)
	local v47 = React.createElement("Frame", {
		BorderSizePixel = 0,
		Position = v44,
		Size = v45,
		BackgroundColor3 = v28.Color.Content.Emphasis.Color3,
		AnchorPoint = Vector2.new(0, 1)
	})

	return React.createElement(ScrollingFrameWithIndicators, {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = t5.BackgroundTransparency,
		BackgroundColor3 = t5.BackgroundColor3,
		LayoutOrder = t5.LayoutOrder,
		Position = t5.Position,
		ZIndex = t5.ZIndex,
		ref = p1,
		controllerRef = v35
	}, if not FFlagAXCategoryMenuVisualFixes then {
		InnerNavigation = v46,
		ActiveTabIndicator = v47
	} else {
		Content = React.createElement(View, {
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			backgroundStyle = t1
		}, {
			InnerNavigation = v46,
			ActiveTabIndicator = v47
		})
	})
end

return React.forwardRef(TabGroup)
