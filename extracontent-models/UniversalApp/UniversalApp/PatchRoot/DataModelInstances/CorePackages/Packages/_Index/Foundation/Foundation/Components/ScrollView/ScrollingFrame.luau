local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

require(Foundation.Components.Types)
local withDefaults = require(Foundation.Utility.withDefaults)
local withGuiObjectProps = require(Foundation.Utility.withGuiObjectProps)

local useCursor = require(Foundation.Providers.Cursor.useCursor)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)
local useTokens = require(Foundation.Providers.Style.useTokens)

local Visibility = require(Foundation.Enums.Visibility)

local ControlState = require(Foundation.Enums.ControlState)

local v = { frequency = 2 }

local v2 = { scrollBarVisibility = "Auto" }

local function ScrollingFrame(p, ref)
	local v3 = withDefaults(p, v2)
	local v4 = withGuiObjectProps({ selection = v3.selection }, {})
	local v5 = useTokens()
	local v6 = useStyleTags(p.tag)
	local shift_400 = v5.Color.Shift.Shift_400

	local scrollBarThickness = React.useMemo(function()
		if v3.scrollBarVisibility == Visibility.None then
			return 0
		end

		return v5.Size.Size_150
	end, { v3.scrollBarVisibility })
	local v7 = useCursor()

	local ref2 = React.useRef(nil)
	local scrollBarImageTransparency, v8 = ReactOtter.useAnimatedBinding(1)
	local v9 = React.useCallback(function(flag: boolean, duration: number?)
		if ref2.current then
			task.cancel(ref2.current)
		end

		if flag then
			v8(ReactOtter.spring(shift_400.Transparency, v))
		end

		if duration ~= nil then
			ref2.current = task.delay(duration, function()
				v8(ReactOtter.spring(1, v))
			end)
		end
	end, { shift_400 })

	React.useEffect(function()
		if v3.scrollBarVisibility == "None" then
			v9(false, 0)
		elseif v3.scrollBarVisibility == "Always" then
			v9(true)
		else
			v9(
				v3.controlState == ControlState.Hover or v3.controlState == ControlState.Selected or v3.controlState == ControlState.Pressed,
				v3.controlState == ControlState.Default and 0 or nil
			)
		end
	end, { v3.scrollBarVisibility, v3.controlState })

	return React.createElement("ScrollingFrame", {
		AutomaticCanvasSize = v3.AutomaticCanvasSize,
		CanvasSize = v3.CanvasSize,
		ClipsDescendants = v3.ClipsDescendants,
		ScrollingDirection = v3.ScrollingDirection,
		ScrollingEnabled = v3.ScrollingEnabled,
		ScrollBarImageColor3 = shift_400.Color3,
		ScrollBarImageTransparency = scrollBarImageTransparency,
		ScrollBarThickness = scrollBarThickness,
		VerticalScrollBarInset = v3.VerticalScrollBarInset,
		HorizontalScrollBarInset = v3.HorizontalScrollBarInset,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = v3.AutomaticSize,
		Size = UDim2.fromScale(1, 1),
		Selectable = v4.Selectable,
		NextSelectionUp = v4.NextSelectionUp,
		NextSelectionDown = v4.NextSelectionDown,
		NextSelectionLeft = v4.NextSelectionLeft,
		NextSelectionRight = v4.NextSelectionRight,
		SelectionImageObject = v4.SelectionImageObject or v7,
		SelectionOrder = v4.SelectionOrder,
		[React.Change.CanvasPosition] = v3.scrollBarVisibility == "Auto" and function(p2)
			v9(true, 3)

			if v3.onCanvasPositionChanged then
				v3.onCanvasPositionChanged(p2)
			end
		end or v3.onCanvasPositionChanged,
		[React.Change.AbsoluteCanvasSize] = v3.onAbsoluteCanvasSizeChanged,
		[React.Change.AbsoluteWindowSize] = v3.onAbsoluteWindowSizeChanged,
		ref = ref,
		[React.Tag] = v6
	}, v3.children)
end

return React.memo(React.forwardRef(ScrollingFrame))
