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

local function scrollingFrameCanScrollLeft(p1) -- line: 31
	return p1.CanvasPosition.X > 0
end
local function scrollingFrameCanScrollRight(p2) -- line: 35
	return p2.AbsoluteCanvasSize.X - p2.CanvasPosition.X > p2.AbsoluteSize.X
end
local function getCanvasPosition(n1: number) -- line: 39
	return Vector2.new(n1, 0)
end
local function gradientTransparency(t4: {[any]: any}, n2: number, n3: number) -- line: 43
	local v31 = 1 - n3
	local v32 = v31 * t4[1]
	local v33 = v31 * t4[2]
	local v34 = t4[3]

	if v34 < 1 then
		return nil
	end

	local v35 = if not (v34 < n2) then n2 / v34 else 1
	local t5 = {}

	if v32 > 0 then
		table.insert(t5, NumberSequenceKeypoint.new(0, 1 - v32))
		table.insert(t5, NumberSequenceKeypoint.new(v35, 1 - v32))
		table.insert(t5, NumberSequenceKeypoint.new(v35 + v35 * v32, 1))
	else
		table.insert(t5, NumberSequenceKeypoint.new(0, 1))
	end

	if v33 > 0 then
		table.insert(t5, NumberSequenceKeypoint.new(1 - v35 * v33 - v35, 1))
		table.insert(t5, NumberSequenceKeypoint.new(1 - v35, 1 - v33))
		table.insert(t5, NumberSequenceKeypoint.new(1, 1 - v33))
	else
		table.insert(t5, NumberSequenceKeypoint.new(1, 1))
	end

	return NumberSequence.new(t5)
end
local function makeGradientTransparency(n4: number, n5: number) -- line: 80
	-- upvalues: gradientTransparency (copy)
	return function(t6: {[any]: any}) -- line: 81
		-- upvalues: gradientTransparency (copy), n4 (copy), n5 (copy)
		return gradientTransparency(t6, n4, n5)
	end
end
local function makeButtonTransparency(t7: {[any]: any}) -- line: 86
	return 1 - t7[1] * t7[2]
end
local function isVisibleFromTransparency(n6: number) -- line: 92
	return n6 < 1
end
local function ScrollingFrameWithIndicators(t8: {[any]: any}, p3) -- line: 105
	-- upvalues: useTokens (copy), useAnimatedBinding (copy), React (copy), getCanvasPosition (copy), gradientTransparency (copy), makeButtonTransparency (copy), isVisibleFromTransparency (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy), View (copy), IconButton (copy), InputSize (copy), t2 (copy), t3 (copy)
	local v43 = useTokens()
	local v44 = t8.BackgroundTransparency or v43.Color.Common.NavigationBar.Transparency
	local v45 = t8.BackgroundColor3 or v43.Color.Common.NavigationBar.Color3
	local v46, v47 = useAnimatedBinding(0)
	local v48, v49 = useAnimatedBinding(0)
	local v50, v51 = React.useBinding(0)
	local v52, v53 = useAnimatedBinding(0)
	local v54, v55 = React.useState(false)
	local v56, v57 = useAnimatedBinding(0)
	local v58 = React.useRef(nil)
	local v59 = React.useMemo(function() -- line: 120
		-- upvalues: v56 (copy), getCanvasPosition (copy)
		return v56:map(getCanvasPosition)
	end, {})
	local v60 = React.useMemo(function() -- line: 124
		-- upvalues: React (copy), v46 (copy), v48 (copy), v50 (copy), v43 (copy), v44 (copy), gradientTransparency (copy)
		local v72 = React.joinBindings({
			v46,
			v48,
			v50
		})
		local v73 = v43.Size.Size_300 * 2
		local v74 = v44

		return v72:map(function(t9: {[any]: any}) -- line: 81
			-- upvalues: gradientTransparency (copy), v73 (copy), v74 (copy)
			return gradientTransparency(t9, v73, v74)
		end)
	end, {
		v43,
		v44
	})
	local v61 = React.useMemo(function() -- line: 132
		-- upvalues: React (copy), v48 (copy), v52 (copy), makeButtonTransparency (copy)
		return React.joinBindings({
			v48,
			v52
		}):map(makeButtonTransparency)
	end, {})
	local v62 = React.useMemo(function() -- line: 136
		-- upvalues: React (copy), v46 (copy), v52 (copy), makeButtonTransparency (copy)
		return React.joinBindings({
			v46,
			v52
		}):map(makeButtonTransparency)
	end, {})
	local v63 = React.useMemo(function() -- line: 143
		-- upvalues: v62 (copy), isVisibleFromTransparency (copy)
		return v62:map(isVisibleFromTransparency)
	end, {})
	local v64 = React.useMemo(function() -- line: 147
		-- upvalues: v61 (copy), isVisibleFromTransparency (copy)
		return v61:map(isVisibleFromTransparency)
	end, {})
	local v65 = React.useCallback(function() -- line: 151
		-- upvalues: v58 (copy), v57 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
		local current = v58.current

		if current then
			v57(ReactOtter.instant(current.CanvasPosition.X))
			v57(makeOtterSpringValue(current.AbsoluteCanvasSize.X - current.AbsoluteSize.X, t1))
		end
	end, {})
	local v66 = React.useCallback(function() -- line: 164
		-- upvalues: v58 (copy), v57 (copy), ReactOtter (copy), makeOtterSpringValue (copy), t1 (copy)
		local current = v58.current

		if current then
			v57(ReactOtter.instant(current.CanvasPosition.X))
			v57(makeOtterSpringValue(0, t1))
		end
	end, {})

	local function onMouseEnter() -- line: 174
		-- upvalues: v53 (copy), makeOtterSpringValue (copy), t1 (copy), v55 (copy)
		v53(makeOtterSpringValue(1, t1))
		v55(true)
	end
	local function onMouseLeave() -- line: 179
		-- upvalues: v53 (copy), makeOtterSpringValue (copy), t1 (copy), v55 (copy)
		v53(makeOtterSpringValue(0, t1))
		v55(false)
	end
	local function onCanvasChanged(p4) -- line: 184
		-- upvalues: v47 (copy), makeOtterSpringValue (copy), t1 (copy), v49 (copy)
		local v78 = not (p4.CanvasPosition.X > 0) and 0 or 1

		v47(makeOtterSpringValue(v78, t1))

		local v79 = not (p4.AbsoluteCanvasSize.X - p4.CanvasPosition.X > p4.AbsoluteSize.X) and 0 or 1

		v49(makeOtterSpringValue(v79, t1))
	end
	local function onSizeChanged(p5) -- line: 191
		-- upvalues: v51 (copy)
		v51(p5.AbsoluteSize.X)
	end

	React.useEffect(function() -- line: 195
		-- upvalues: v58 (copy), v47 (copy), ReactOtter (copy), v49 (copy)
		local current = v58.current

		if current then
			local v82 = not (current.CanvasPosition.X > 0) and 0 or 1

			v47(ReactOtter.instant(v82))

			local v83 = not (current.AbsoluteCanvasSize.X - current.CanvasPosition.X > current.AbsoluteSize.X) and 0 or 1

			v49(ReactOtter.instant(v83))
		end
	end, {})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = v44,
		BackgroundColor3 = v45,
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
			CanvasPosition = v59,
			[React.Change.AbsoluteSize] = onSizeChanged,
			[React.Change.CanvasSize] = onCanvasChanged,
			[React.Change.AbsoluteCanvasSize] = onCanvasChanged,
			[React.Change.CanvasPosition] = onCanvasChanged,
			[React.Event.MouseEnter] = onMouseEnter,
			[React.Event.MouseLeave] = onMouseLeave,
			ref = v58
		}, React.createElement(React.Fragment, nil, t8.children)),
		OverlayFrame = React.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v45
		}, {
			Gradient = React.createElement("UIGradient", {
				Transparency = v60
			}),
			LeftButton = React.createElement(View, {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				GroupTransparency = v62,
				Visible = v63
			}, React.createElement(IconButton, {
				isDisabled = not v54,
				size = InputSize.Small,
				icon = t2,
				onActivated = v66
			})),
			RightButton = React.createElement(View, {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(1, 0.5),
				AnchorPoint = Vector2.new(1, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				GroupTransparency = v61,
				Visible = v64
			}, React.createElement(IconButton, {
				isDisabled = not v54,
				size = InputSize.Small,
				icon = t3,
				onActivated = v65
			}))
		})
	})
end

return React.forwardRef(ScrollingFrameWithIndicators)
