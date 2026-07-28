local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local ReactOtter = require(AvatarExperienceUIKitParent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local Responsive = require(AvatarExperienceUIKitParent.Responsive)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)
local shouldShowScrollArrowsForInputType = require(AvatarExperienceUIKit.Utils.shouldShowScrollArrowsForInputType)
local getFixedTabHeight = require(AvatarExperienceUIKit.Utils.getFixedTabHeight)
local FFlagAXCategoryMenuVisualFixes = require(AvatarExperienceUIKitParent.AvatarExperienceFlags).FFlagAXCategoryMenuVisualFixes
local t1 = {
	dampingRatio = 1,
	frequency = 5
}
local t2 = {
	name = IconName.ChevronLargeLeft,
	variant = IconVariant.Filled
}
local t3 = {
	name = IconName.ChevronLargeRight,
	variant = IconVariant.Filled
}

local function scrollingFrameCanScrollLeft(p1) -- line: 37
	return p1.CanvasPosition.X > 0
end
local function scrollingFrameCanScrollRight(p2) -- line: 41
	return p2.AbsoluteCanvasSize.X - p2.CanvasPosition.X > p2.AbsoluteSize.X
end
local function getCanvasPosition(n1: number) -- line: 45
	return Vector2.new(n1, 0)
end
local function gradientTransparency(t4: {[any]: any}, n2: number, n3: number) -- line: 49
	local v35 = 1 - n3
	local v36 = v35 * t4[1]
	local v37 = v35 * t4[2]
	local v38 = t4[3]

	if v38 < 1 then
		return nil
	end

	local v39 = if not (v38 < n2) then n2 / v38 else 1
	local t5 = {}

	if v36 > 0 then
		table.insert(t5, NumberSequenceKeypoint.new(0, 1 - v36))
		table.insert(t5, NumberSequenceKeypoint.new(v39, 1 - v36))
		table.insert(t5, NumberSequenceKeypoint.new(v39 + v39 * v36, 1))
	else
		table.insert(t5, NumberSequenceKeypoint.new(0, 1))
	end

	if v37 > 0 then
		table.insert(t5, NumberSequenceKeypoint.new(1 - v39 * v37 - v39, 1))
		table.insert(t5, NumberSequenceKeypoint.new(1 - v39, 1 - v37))
		table.insert(t5, NumberSequenceKeypoint.new(1, 1 - v37))
	else
		table.insert(t5, NumberSequenceKeypoint.new(1, 1))
	end

	return NumberSequence.new(t5)
end
local function makeGradientTransparency(n4: number, n5: number) -- line: 86
	-- upvalues: gradientTransparency (copy)
	return function(t6: {[any]: any}) -- line: 87
		-- upvalues: gradientTransparency (copy), n4 (copy), n5 (copy)
		return gradientTransparency(t6, n4, n5)
	end
end
local function makeButtonTransparency(t7: {[any]: any}) -- line: 92
	return 1 - t7[1] * t7[2]
end
local function isVisibleFromTransparency(n6: number) -- line: 98
	return n6 < 1
end
local function ScrollingFrameWithIndicators(t8: {[any]: any}, p3) -- line: 121
	-- upvalues: useTokens (copy), FFlagAXCategoryMenuVisualFixes (copy), useAnimatedBinding (copy), React (copy), Responsive (copy), shouldShowScrollArrowsForInputType (copy), getCanvasPosition (copy), gradientTransparency (copy), makeButtonTransparency (copy), isVisibleFromTransparency (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy), getFixedTabHeight (copy), View (copy), IconButton (copy), InputSize (copy), t2 (copy), t3 (copy)
	local v47 = useTokens()
	local v48 = t8.BackgroundTransparency or v47.Color.Common.NavigationBar.Transparency
	local v49 = t8.BackgroundColor3 or v47.Color.Common.NavigationBar.Color3
	local v50 = if not FFlagAXCategoryMenuVisualFixes then v47.Size.Size_100 else v47.Size.Size_150
	local v51 = if not FFlagAXCategoryMenuVisualFixes then v50 else v50 * 2
	local v52, v53 = useAnimatedBinding(0)
	local v54, v55 = useAnimatedBinding(0)
	local v56, v57 = React.useBinding(0)
	local v58, v59 = useAnimatedBinding(0)
	local v60, v61 = React.useState(false)
	local u62 = nil

	if FFlagAXCategoryMenuVisualFixes then
		local v63 = Responsive.useLastInput()

		u62 = shouldShowScrollArrowsForInputType(v63)
	end

	local v64, v65 = useAnimatedBinding(0)
	local v66 = React.useRef(nil)
	local v67 = React.useMemo(function() -- line: 150
		-- upvalues: v64 (copy), getCanvasPosition (copy)
		return v64:map(getCanvasPosition)
	end, {})
	local v68 = React.useMemo(function() -- line: 154
		-- upvalues: React (copy), v52 (copy), v54 (copy), v56 (copy), v47 (copy), v48 (copy), gradientTransparency (copy)
		local v85 = React.joinBindings({
			v52,
			v54,
			v56
		})
		local v86 = v47.Size.Size_300 * 2
		local v87 = v48

		return v85:map(function(t9: {[any]: any}) -- line: 87
			-- upvalues: gradientTransparency (copy), v86 (copy), v87 (copy)
			return gradientTransparency(t9, v86, v87)
		end)
	end, {
		v47,
		v48
	})
	local v69 = React.useMemo(function() -- line: 162
		-- upvalues: React (copy), v54 (copy), v58 (copy), makeButtonTransparency (copy)
		return React.joinBindings({
			v54,
			v58
		}):map(makeButtonTransparency)
	end, {})
	local v70 = React.useMemo(function() -- line: 166
		-- upvalues: React (copy), v52 (copy), v58 (copy), makeButtonTransparency (copy)
		return React.joinBindings({
			v52,
			v58
		}):map(makeButtonTransparency)
	end, {})
	local v71 = React.useMemo(function() -- line: 173
		-- upvalues: v70 (copy), isVisibleFromTransparency (copy)
		return v70:map(isVisibleFromTransparency)
	end, {})
	local v72 = React.useMemo(function() -- line: 177
		-- upvalues: v69 (copy), isVisibleFromTransparency (copy)
		return v69:map(isVisibleFromTransparency)
	end, {})
	local v73 = React.useCallback(function() -- line: 181
		-- upvalues: v66 (copy), v65 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
		local current = v66.current

		if current then
			v65(ReactOtter.instant(current.CanvasPosition.X))
			v65(makeOtterSpringValue(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, t1))
		end
	end, {})
	local v74 = React.useCallback(function() -- line: 194
		-- upvalues: v66 (copy), v65 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
		local current = v66.current

		if current then
			v65(ReactOtter.instant(current.CanvasPosition.X))
			v65(makeOtterSpringValue(0, t1))
		end
	end, {})

	local function onMouseEnter() -- line: 204
		-- upvalues: FFlagAXCategoryMenuVisualFixes (copy), u62 (ref), v59 (copy), makeOtterSpringValue (copy), t1 (copy), v61 (copy)
		if FFlagAXCategoryMenuVisualFixes and not u62 then
			return
		end

		v59(makeOtterSpringValue(1, t1))
		v61(true)
	end
	local function onMouseLeave() -- line: 212
		-- upvalues: FFlagAXCategoryMenuVisualFixes (copy), u62 (ref), v59 (copy), makeOtterSpringValue (copy), t1 (copy), v61 (copy)
		if FFlagAXCategoryMenuVisualFixes and not u62 then
			return
		end

		v59(makeOtterSpringValue(0, t1))
		v61(false)
	end

	if FFlagAXCategoryMenuVisualFixes then
		React.useEffect(function() -- line: 223
			-- upvalues: u62 (ref), v59 (copy), ReactOtter (copy), v61 (copy)
			if not u62 then
				v59(ReactOtter.instant(0))
				v61(false)
			end
		end, { u62 })
	end

	local function onCanvasChanged(p4) -- line: 231
		-- upvalues: v53 (copy), makeOtterSpringValue (copy), t1 (copy), v55 (copy)
		local v91 = not (p4.CanvasPosition.X > 0) and 0 or 1

		v53(makeOtterSpringValue(v91, t1))

		local v92 = not (p4.AbsoluteCanvasSize.X - p4.CanvasPosition.X > p4.AbsoluteSize.X) and 0 or 1

		v55(makeOtterSpringValue(v92, t1))
	end
	local function onSizeChanged(p5) -- line: 238
		-- upvalues: v57 (copy)
		v57(p5.AbsoluteSize.X)
	end

	React.useEffect(function() -- line: 242
		-- upvalues: v66 (copy), v53 (copy), ReactOtter (copy), v55 (copy)
		local current = v66.current

		if current then
			local v95 = not (current.CanvasPosition.X > 0) and 0 or 1

			v53(ReactOtter.instant(v95))

			local v96 = not (current.AbsoluteCanvasSize.X - current.CanvasPosition.X > current.AbsoluteSize.X) and 0 or 1

			v55(ReactOtter.instant(v96))
		end
	end, {})

	if FFlagAXCategoryMenuVisualFixes then
		local v79 = React.useCallback(function(n7: number) -- line: 257
			-- upvalues: v66 (copy), v65 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
			local current = v66.current

			if current then
				v65(ReactOtter.instant(current.CanvasPosition.X))
				v65(makeOtterSpringValue(n7, t1))
			end
		end, {})
		local v80 = React.useCallback(function(n8: number) -- line: 266
			-- upvalues: v66 (copy), v65 (copy), ReactOtter (copy)
			if v66.current then
				v65(ReactOtter.instant(n8))
			end
		end, {})

		React.useImperativeHandle(t8.controllerRef, function() -- line: 273
			-- upvalues: v79 (copy), v80 (copy), v66 (copy)
			return {
				scrollToOffset = v79,
				setOffset = v80,
				getScrollingFrame = function() -- line: 277
					-- upvalues: v66 (copy)
					return v66.current
				end
			}
		end, {
			v79,
			v80
		})
	end

	local Size_1000 = v47.Size.Size_1000
	local v82 = getFixedTabHeight(v47)
	local v83 = v50 + v82 + v51

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = if not FFlagAXCategoryMenuVisualFixes then UDim2.fromScale(1, 0) else UDim2.new(1, 0, 0, Size_1000),
		AutomaticSize = if not FFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
		ClipsDescendants = not FFlagAXCategoryMenuVisualFixes and nil,
		BackgroundTransparency = v48,
		BackgroundColor3 = v49,
		LayoutOrder = t8.LayoutOrder,
		ZIndex = t8.ZIndex,
		Position = t8.Position,
		ref = p3
	}, {
		ScrollingFrame = React.createElement("ScrollingFrame", {
			ClipsDescendants = true,
			Size = if not FFlagAXCategoryMenuVisualFixes then UDim2.fromScale(1, 0) else UDim2.new(1, 0, 0, v83),
			Position = if not FFlagAXCategoryMenuVisualFixes then nil else UDim2.fromOffset(0, -v50),
			AutomaticSize = if not FFlagAXCategoryMenuVisualFixes then Enum.AutomaticSize.Y else Enum.AutomaticSize.None,
			Selectable = false,
			CanvasSize = UDim2.fromScale(1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ElasticBehavior = if not FFlagAXCategoryMenuVisualFixes then Enum.ElasticBehavior.Always else Enum.ElasticBehavior.Never,
			ScrollingDirection = Enum.ScrollingDirection.X,
			CanvasPosition = v67,
			[React.Change.AbsoluteSize] = onSizeChanged,
			[React.Change.CanvasSize] = onCanvasChanged,
			[React.Change.AbsoluteCanvasSize] = onCanvasChanged,
			[React.Change.CanvasPosition] = onCanvasChanged,
			[React.Event.MouseEnter] = onMouseEnter,
			[React.Event.MouseLeave] = onMouseLeave,
			ref = v66
		}, if not FFlagAXCategoryMenuVisualFixes then React.createElement(React.Fragment, nil, t8.children) else {
			FocusCursorInset = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v50),
				PaddingBottom = UDim.new(0, v51),
				PaddingLeft = UDim.new(0, v50),
				PaddingRight = UDim.new(0, v50)
			}),
			Content = React.createElement(React.Fragment, nil, t8.children)
		}),
		OverlayFrame = React.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v49
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = v68
			}),
			LeftButton = React.createElement(View, {
				BackgroundTransparency = 1,
				Position = if not FFlagAXCategoryMenuVisualFixes then UDim2.fromScale(0, 0.5) else UDim2.new(0, 0, 0, v82 / 2),
				AnchorPoint = Vector2.new(0, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				GroupTransparency = v70,
				Visible = v71
			}, React.createElement(IconButton, {
				isDisabled = not v60,
				size = InputSize.Small,
				icon = t2,
				onActivated = v74
			})),
			RightButton = React.createElement(View, {
				BackgroundTransparency = 1,
				Position = if not FFlagAXCategoryMenuVisualFixes then UDim2.fromScale(1, 0.5) else UDim2.new(1, 0, 0, v82 / 2),
				AnchorPoint = Vector2.new(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				GroupTransparency = v69,
				Visible = v72
			}, React.createElement(IconButton, {
				isDisabled = not v60,
				size = InputSize.Small,
				icon = t3,
				onActivated = v73
			}))
		})
	})
end

return React.forwardRef(ScrollingFrameWithIndicators)
