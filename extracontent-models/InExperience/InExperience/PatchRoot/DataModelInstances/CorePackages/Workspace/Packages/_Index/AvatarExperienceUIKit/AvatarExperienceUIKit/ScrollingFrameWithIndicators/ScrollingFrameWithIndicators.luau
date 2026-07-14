local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local ReactOtter = require(AvatarExperienceUIKitParent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local IconButton = Foundation.IconButton
local InputSize = Foundation.Enums.InputSize
local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local makeOtterSpringValue = require(AvatarExperienceUIKit.Utils.makeOtterSpringValue)
local FFlagAXResetSubcategoryRowOnCategoryChange = require(AvatarExperienceUIKitParent.AvatarExperienceFlags).FFlagAXResetSubcategoryRowOnCategoryChange
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

local function scrollingFrameCanScrollLeft(p1) -- line: 34
	return p1.CanvasPosition.X > 0
end
local function scrollingFrameCanScrollRight(p2) -- line: 38
	return p2.AbsoluteCanvasSize.X - p2.CanvasPosition.X > p2.AbsoluteSize.X
end
local function getCanvasPosition(n1: number) -- line: 42
	return Vector2.new(n1, 0)
end
local function gradientTransparency(t4: {[any]: any}, n2: number, n3: number) -- line: 46
	local v32 = 1 - n3
	local v33 = v32 * t4[1]
	local v34 = v32 * t4[2]
	local v35 = t4[3]

	if v35 < 1 then
		return nil
	end

	local v36 = if not (v35 < n2) then n2 / v35 else 1
	local t5 = {}

	if v33 > 0 then
		table.insert(t5, NumberSequenceKeypoint.new(0, 1 - v33))
		table.insert(t5, NumberSequenceKeypoint.new(v36, 1 - v33))
		table.insert(t5, NumberSequenceKeypoint.new(v36 + v36 * v33, 1))
	else
		table.insert(t5, NumberSequenceKeypoint.new(0, 1))
	end

	if v34 > 0 then
		table.insert(t5, NumberSequenceKeypoint.new(1 - v36 * v34 - v36, 1))
		table.insert(t5, NumberSequenceKeypoint.new(1 - v36, 1 - v34))
		table.insert(t5, NumberSequenceKeypoint.new(1, 1 - v34))
	else
		table.insert(t5, NumberSequenceKeypoint.new(1, 1))
	end

	return NumberSequence.new(t5)
end
local function makeGradientTransparency(n4: number, n5: number) -- line: 83
	-- upvalues: gradientTransparency (copy)
	return function(t6: {[any]: any}) -- line: 84
		-- upvalues: gradientTransparency (copy), n4 (copy), n5 (copy)
		return gradientTransparency(t6, n4, n5)
	end
end
local function makeButtonTransparency(t7: {[any]: any}) -- line: 89
	return 1 - t7[1] * t7[2]
end
local function isVisibleFromTransparency(n6: number) -- line: 95
	return n6 < 1
end
local function ScrollingFrameWithIndicators(t8: {[any]: any}, p3) -- line: 118
	-- upvalues: useTokens (copy), useAnimatedBinding (copy), React (copy), getCanvasPosition (copy), gradientTransparency (copy), makeButtonTransparency (copy), isVisibleFromTransparency (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy), FFlagAXResetSubcategoryRowOnCategoryChange (copy), View (copy), IconButton (copy), InputSize (copy), t2 (copy), t3 (copy)
	local v44 = useTokens()
	local v45 = t8.BackgroundTransparency or v44.Color.Common.NavigationBar.Transparency
	local v46 = t8.BackgroundColor3 or v44.Color.Common.NavigationBar.Color3
	local v47, v48 = useAnimatedBinding(0)
	local v49, v50 = useAnimatedBinding(0)
	local v51, v52 = React.useBinding(0)
	local v53, v54 = useAnimatedBinding(0)
	local v55, v56 = React.useState(false)
	local v57, v58 = useAnimatedBinding(0)
	local v59 = React.useRef(nil)
	local v60 = React.useMemo(function() -- line: 133
		-- upvalues: v57 (copy), getCanvasPosition (copy)
		return v57:map(getCanvasPosition)
	end, {})
	local v61 = React.useMemo(function() -- line: 137
		-- upvalues: React (copy), v47 (copy), v49 (copy), v51 (copy), v44 (copy), v45 (copy), gradientTransparency (copy)
		local v75 = React.joinBindings({
			v47,
			v49,
			v51
		})
		local v76 = v44.Size.Size_300 * 2
		local v77 = v45

		return v75:map(function(t9: {[any]: any}) -- line: 84
			-- upvalues: gradientTransparency (copy), v76 (copy), v77 (copy)
			return gradientTransparency(t9, v76, v77)
		end)
	end, {
		v44,
		v45
	})
	local v62 = React.useMemo(function() -- line: 145
		-- upvalues: React (copy), v49 (copy), v53 (copy), makeButtonTransparency (copy)
		return React.joinBindings({
			v49,
			v53
		}):map(makeButtonTransparency)
	end, {})
	local v63 = React.useMemo(function() -- line: 149
		-- upvalues: React (copy), v47 (copy), v53 (copy), makeButtonTransparency (copy)
		return React.joinBindings({
			v47,
			v53
		}):map(makeButtonTransparency)
	end, {})
	local v64 = React.useMemo(function() -- line: 156
		-- upvalues: v63 (copy), isVisibleFromTransparency (copy)
		return v63:map(isVisibleFromTransparency)
	end, {})
	local v65 = React.useMemo(function() -- line: 160
		-- upvalues: v62 (copy), isVisibleFromTransparency (copy)
		return v62:map(isVisibleFromTransparency)
	end, {})
	local v66 = React.useCallback(function() -- line: 164
		-- upvalues: v59 (copy), v58 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
		local current = v59.current

		if current then
			v58(ReactOtter.instant(current.CanvasPosition.X))
			v58(makeOtterSpringValue(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, t1))
		end
	end, {})
	local v67 = React.useCallback(function() -- line: 177
		-- upvalues: v59 (copy), v58 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
		local current = v59.current

		if current then
			v58(ReactOtter.instant(current.CanvasPosition.X))
			v58(makeOtterSpringValue(0, t1))
		end
	end, {})

	local function onMouseEnter() -- line: 187
		-- upvalues: v54 (copy), makeOtterSpringValue (copy), t1 (copy), v56 (copy)
		v54(makeOtterSpringValue(1, t1))
		v56(true)
	end
	local function onMouseLeave() -- line: 192
		-- upvalues: v54 (copy), makeOtterSpringValue (copy), t1 (copy), v56 (copy)
		v54(makeOtterSpringValue(0, t1))
		v56(false)
	end
	local function onCanvasChanged(p4) -- line: 197
		-- upvalues: v48 (copy), makeOtterSpringValue (copy), t1 (copy), v50 (copy)
		local v81 = not (p4.CanvasPosition.X > 0) and 0 or 1

		v48(makeOtterSpringValue(v81, t1))

		local v82 = not (p4.AbsoluteCanvasSize.X - p4.CanvasPosition.X > p4.AbsoluteSize.X) and 0 or 1

		v50(makeOtterSpringValue(v82, t1))
	end
	local function onSizeChanged(p5) -- line: 204
		-- upvalues: v52 (copy)
		v52(p5.AbsoluteSize.X)
	end

	React.useEffect(function() -- line: 208
		-- upvalues: v59 (copy), v48 (copy), ReactOtter (copy), v50 (copy)
		local current = v59.current

		if current then
			local v85 = not (current.CanvasPosition.X > 0) and 0 or 1

			v48(ReactOtter.instant(v85))

			local v86 = not (current.AbsoluteCanvasSize.X - current.CanvasPosition.X > current.AbsoluteSize.X) and 0 or 1

			v50(ReactOtter.instant(v86))
		end
	end, {})

	if FFlagAXResetSubcategoryRowOnCategoryChange then
		local v72 = React.useCallback(function(n7: number) -- line: 223
			-- upvalues: v59 (copy), v58 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
			local current = v59.current

			if current then
				v58(ReactOtter.instant(current.CanvasPosition.X))
				v58(makeOtterSpringValue(n7, t1))
			end
		end, {})
		local v73 = React.useCallback(function(n8: number) -- line: 232
			-- upvalues: v59 (copy), v58 (copy), ReactOtter (copy)
			if v59.current then
				v58(ReactOtter.instant(n8))
			end
		end, {})

		React.useImperativeHandle(t8.controllerRef, function() -- line: 239
			-- upvalues: v72 (copy), v73 (copy), v59 (copy)
			return {
				scrollToOffset = v72,
				setOffset = v73,
				getScrollingFrame = function() -- line: 243
					-- upvalues: v59 (copy)
					return v59.current
				end
			}
		end, {
			v72,
			v73
		})
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = v45,
		BackgroundColor3 = v46,
		LayoutOrder = t8.LayoutOrder,
		ZIndex = t8.ZIndex,
		Position = t8.Position,
		ref = p3
	}, {
		ScrollingFrame = React.createElement("ScrollingFrame", {
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Selectable = false,
			CanvasSize = UDim2.fromScale(1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			ScrollingDirection = Enum.ScrollingDirection.X,
			CanvasPosition = v60,
			[React.Change.AbsoluteSize] = onSizeChanged,
			[React.Change.CanvasSize] = onCanvasChanged,
			[React.Change.AbsoluteCanvasSize] = onCanvasChanged,
			[React.Change.CanvasPosition] = onCanvasChanged,
			[React.Event.MouseEnter] = onMouseEnter,
			[React.Event.MouseLeave] = onMouseLeave,
			ref = v59
		}, React.createElement(React.Fragment, nil, t8.children)),
		OverlayFrame = React.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v46
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = v61
			}),
			LeftButton = React.createElement(View, {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				GroupTransparency = v63,
				Visible = v64
			}, React.createElement(IconButton, {
				isDisabled = not v55,
				size = InputSize.Small,
				icon = t2,
				onActivated = v67
			})),
			RightButton = React.createElement(View, {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(1, 0.5),
				AnchorPoint = Vector2.new(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				GroupTransparency = v62,
				Visible = v65
			}, React.createElement(IconButton, {
				isDisabled = not v55,
				size = InputSize.Small,
				icon = t3,
				onActivated = v66
			}))
		})
	})
end

return React.forwardRef(ScrollingFrameWithIndicators)
