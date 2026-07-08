local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)

require(Foundation.Components.Types)

local withDefaults = require(Foundation.Utility.withDefaults)
local withGuiObjectProps = require(Foundation.Utility.withGuiObjectProps)
local useCursor = require(Foundation.Providers.Cursor.useCursor)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)
local useTokens = require(Foundation.Providers.Style.useTokens)
local Visibility = require(Foundation.Enums.Visibility)
local ControlState = require(Foundation.Enums.ControlState)
local t1 = {
	frequency = 2
}
local t2 = {
	scrollBarVisibility = "Auto"
}

local function ScrollingFrame(t3: {[any]: any}, p1) -- line: 52
	-- upvalues: withDefaults (copy), t2 (copy), withGuiObjectProps (copy), useTokens (copy), useStyleTags (copy), React (copy), Visibility (copy), useCursor (copy), ReactOtter (copy), t1 (copy), ControlState (copy)
	local v17 = withDefaults(t3, t2)
	local v18 = withGuiObjectProps({
		selection = v17.selection
	}, {})
	local v19 = useTokens()
	local v20 = useStyleTags(t3.tag)
	local Shift_400 = v19.Color.Shift.Shift_400
	local v22 = React.useMemo(function() -- line: 58
		-- upvalues: v17 (copy), Visibility (copy), v19 (copy)
		if v17.scrollBarVisibility == Visibility.None then
			return 0
		end

		return v19.Size.Size_150
	end, { v17.scrollBarVisibility })
	local v23 = useCursor()
	local v24 = React.useRef(nil)
	local v25, v26 = ReactOtter.useAnimatedBinding(1)
	local v27 = React.useCallback(function(b1: boolean, n1: number?) -- line: 69
		-- upvalues: v24 (copy), v26 (copy), ReactOtter (copy), Shift_400 (copy), t1 (copy)
		if v24.current then
			task.cancel(v24.current)
		end

		if b1 then
			v26(ReactOtter.spring(Shift_400.Transparency, t1))
		end

		if n1 ~= nil then
			v24.current = task.delay(n1, function() -- line: 79
				-- upvalues: v26 (copy), ReactOtter (copy), t1 (copy)
				v26(ReactOtter.spring(1, t1))
			end)
		end
	end, { Shift_400 })

	React.useEffect(function() -- line: 85
		-- upvalues: v17 (copy), v27 (copy), ControlState (copy)
		if v17.scrollBarVisibility == "None" then
			v27(false, 0)

			return
		end

		if v17.scrollBarVisibility == "Always" then
			v27(true)

			return
		end

		v27(v17.controlState == ControlState.Hover or (v17.controlState == ControlState.Selected or v17.controlState == ControlState.Pressed), if v17.controlState ~= ControlState.Default then nil else 0)
	end, {
		v17.scrollBarVisibility,
		v17.controlState
	})

	return React.createElement("ScrollingFrame", {
		AutomaticCanvasSize = v17.AutomaticCanvasSize,
		CanvasSize = v17.CanvasSize,
		ClipsDescendants = v17.ClipsDescendants,
		ScrollingDirection = v17.ScrollingDirection,
		ScrollingEnabled = v17.ScrollingEnabled,
		ScrollBarImageColor3 = Shift_400.Color3,
		ScrollBarImageTransparency = v25,
		ScrollBarThickness = v22,
		VerticalScrollBarInset = v17.VerticalScrollBarInset,
		HorizontalScrollBarInset = v17.HorizontalScrollBarInset,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = v17.AutomaticSize,
		Size = UDim2.fromScale(1, 1),
		Selectable = v18.Selectable,
		NextSelectionUp = v18.NextSelectionUp,
		NextSelectionDown = v18.NextSelectionDown,
		NextSelectionLeft = v18.NextSelectionLeft,
		NextSelectionRight = v18.NextSelectionRight,
		SelectionImageObject = v18.SelectionImageObject or v23,
		SelectionOrder = v18.SelectionOrder,
		[React.Change.CanvasPosition] = if v17.scrollBarVisibility ~= "Auto" then v17.onCanvasPositionChanged else function(p2) -- line: 132
			-- upvalues: v27 (copy), v17 (copy)
			v27(true, 3)

			if v17.onCanvasPositionChanged then
				v17.onCanvasPositionChanged(p2)
			end
		end,
		[React.Change.AbsoluteCanvasSize] = v17.onAbsoluteCanvasSizeChanged,
		[React.Change.AbsoluteWindowSize] = v17.onAbsoluteWindowSizeChanged,
		ref = p1,
		[React.Tag] = v20
	}, v17.children)
end

return React.memo(React.forwardRef(ScrollingFrame))
