local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local InputMode = require(Foundation.Utility.Input.InputMode)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useBindable = require(Foundation.Utility.useBindable)
local useLastInputMode = require(Foundation.Utility.Input.useLastInputMode)
local usePointerPosition = require(Foundation.Utility.usePointerPosition)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local calculateNextStepValue = require(script.Parent.calculateNextStepValue)
local calculatePixelsPerStep = require(script.Parent.calculatePixelsPerStep)
local calculateSliderPositionDelta = require(script.Parent.calculateSliderPositionDelta)
local calculateSliderStepValue = require(script.Parent.calculateSliderStepValue)
local calculateSliderValueFromPosition = require(script.Parent.calculateSliderValueFromPosition)
local InputSize = require(Foundation.Enums.InputSize)
local Visibility = require(Foundation.Enums.Visibility)
local SliderVariant = require(Foundation.Enums.SliderVariant)
local ColorMode = require(Foundation.Enums.ColorMode)
local ControlState = require(Foundation.Enums.ControlState)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local Flags = require(Foundation.Utility.Flags)
local Knob = require(Foundation.Components.Knob)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local useSliderMotionStates = require(Foundation.Components.Slider.useSliderMotionStates)
local useSliderVariants = require(Foundation.Components.Slider.useSliderVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local t1 = {
	isDisabled = false,
	isContained = false,
	testId = "--foundation-slider",
	range = NumberRange.new(0, 1),
	size = InputSize.Medium,
	width = UDim.new(1, 0),
	variant = SliderVariant.Standard,
	knobVisibility = Visibility.Auto
}
local t2 = {
	colorMode = ColorMode.Inverse
}

local function Slider(p1, p2) -- line: 86
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), ControlState (copy), useBindable (copy), useLastInputMode (copy), usePointerPosition (copy), useSliderVariants (copy), useSliderMotionStates (copy), Visibility (copy), calculateSliderValueFromPosition (copy), calculateSliderStepValue (copy), InputMode (copy), calculatePixelsPerStep (copy), calculateNextStepValue (copy), calculateSliderPositionDelta (copy), View (copy), withCommonProps (copy), Constants (copy), StateLayerAffordance (copy), Flags (copy), PresentationContext (copy), t2 (copy), Knob (copy)
	local v34 = withDefaults(p1, t1)
	local v35 = useTokens()
	local v36, v37 = React.useState(ControlState.Initialize)
	local v38, v39 = React.useState(false)
	local v40, v41 = React.useState(false)
	local v42 = useBindable(v34.value):map(function(p3) -- line: 92
		-- upvalues: v34 (copy)
		return (math.clamp(p3, v34.range.Min, v34.range.Max))
	end)
	local v43 = React.useRef(nil)
	local v44 = useLastInputMode()
	local v45 = React.useRef(nil)

	React.useImperativeHandle(p2, function() -- line: 99
		-- upvalues: v45 (copy)
		return v45.current
	end, {})

	local v46 = usePointerPosition(v45.current)
	local v47 = useSliderVariants(v35, v34.size, v34.variant)
	local v48 = useSliderMotionStates(v47.knob.style, v47.knob.dragStyle)
	local v49 = React.useMemo(function() -- line: 109
		-- upvalues: v40 (copy), v48 (copy), v38 (copy)
		if not v40 then
			return v48.Hidden
		end

		if v38 then
			return v48.Dragging
		end

		return v48.Idle
	end, {
		v35,
		v40,
		v38,
		v48
	})

	React.useEffect(function() -- line: 116
		-- upvalues: v34 (copy), Visibility (copy), v41 (copy), v38 (copy), v36 (copy), ControlState (copy)
		if v34.knobVisibility == Visibility.None then
			v41(false)

			return
		end

		if v34.knobVisibility == Visibility.Always then
			v41(true)

			return
		end

		v41(v38 or (v36 == ControlState.Hover or (v36 == ControlState.Selected or v36 == ControlState.Pressed)))
	end, {
		v34.knobVisibility,
		v36,
		v38
	})

	local v50 = React.useCallback(function(vector2: Vector2) -- line: 131
		-- upvalues: v45 (copy), calculateSliderValueFromPosition (copy), v34 (copy), calculateSliderStepValue (copy)
		if v45.current then
			local v61 = calculateSliderValueFromPosition(vector2, v45.current, v34.range)

			if v34.step then
				return calculateSliderStepValue(v61, v34.step, v34.range)
			end

			return v61
		end

		return 0
	end, {
		v45,
		v34.range,
		v34.step
	})
	local v51 = React.useCallback(function(n1: number) -- line: 144
		-- upvalues: v42 (copy), v34 (copy)
		if n1 ~= v42:getValue() and v34.onValueChanged then
			v34.onValueChanged(n1)
		end
	end, {
		v42,
		v34.onValueChanged
	})
	local v52 = React.useCallback(function() -- line: 152
		-- upvalues: v50 (copy), v46 (copy), v51 (copy)
		local v63 = v50(v46:getValue())

		v51(v63)
	end, {
		v50,
		v46,
		v51
	})
	local v53 = React.useCallback(function(_, vector2: Vector2) -- line: 157
		-- upvalues: v43 (copy), v39 (copy), v34 (copy)
		v43.current = vector2
		v39(true)

		if v34.onDragStarted then
			v34.onDragStarted()
		end
	end, { v34.onDragStarted })
	local v54 = React.useCallback(function(_, vector2: Vector2) -- line: 166
		-- upvalues: v45 (copy), v43 (copy), v34 (copy), v44 (copy), InputMode (copy), calculatePixelsPerStep (copy), v42 (copy), calculateNextStepValue (copy), v51 (copy), v50 (copy), calculateSliderPositionDelta (copy)
		if v45.current and v43.current then
			if v34.step and v34.step > 0 then
				if v44 ~= InputMode.Directional then
					local v68 = v50(vector2)

					v51(v68)
					v43.current = vector2

					return
				end

				local v69 = vector2 - v43.current
				local v70 = math.abs(v69.X)
				local v71 = calculatePixelsPerStep(v45.current.AbsoluteSize.X, v34.step, v34.range)

				if v70 > v71 * 2 then
					v43.current = vector2

					return
				end

				if v70 < v71 / 2 then
					return
				end

				local v72 = v42:getValue()
				local v73 = calculateNextStepValue(v69.X, v72, v34.step, v34.range)

				if v73 ~= v72 then
					v51(v73)
					v43.current = vector2

					return
				end
			else
				local Magnitude = v45.current.AbsoluteSize.Magnitude
				local v75 = calculateSliderPositionDelta(vector2, v43.current, Magnitude)

				v43.current = vector2

				if v44 == InputMode.Directional and math.abs(v75) > 0.01 then
					return
				end

				local v76 = v50(vector2)

				v51(v76)
			end
		end
	end, {
		v34.step,
		v34.range,
		v44,
		v42,
		v51,
		v50
	})
	local v55 = React.useCallback(function() -- line: 231
		-- upvalues: v39 (copy), v43 (copy), v34 (copy)
		v39(false)
		v43.current = nil

		if v34.onDragEnded then
			v34.onDragEnded()
		end
	end, { v34.onDragEnded })
	local v56 = React.useCallback(function(p6) -- line: 240
		-- upvalues: v37 (copy), ControlState (copy), v52 (copy)
		v37(p6)

		if p6 == ControlState.Pressed then
			v52()
		end
	end, { v52 })
	local uDim2 = UDim2.fromScale(1, 0.5)
	local v58 = if not v34.isContained then Vector2.new(0.5, 0.5) else v42:map(function(n2: number) -- line: 252
		-- upvalues: v34 (copy)
		local v79 = (n2 - v34.range.Min) / (v34.range.Max - v34.range.Min)

		return Vector2.new(v79, 0.5)
	end)

	return React.createElement(View, withCommonProps(v34, {
		Size = UDim2.new(v34.width, UDim.new(0, v47.hitbox.height)),
		GroupTransparency = if not v34.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onStateChanged = v56,
		isDisabled = v34.isDisabled,
		ref = v45
	}), {
		DragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v53,
			[React.Event.DragContinue] = v54,
			[React.Event.DragEnd] = v55,
			Enabled = not v34.isDisabled
		}),
		Bar = React.createElement(View, {
			tag = v47.bar.tag,
			testId = `{ v34.testId }--bar`
		}, {
			Fill = React.createElement(View, {
				tag = v47.fill.tag,
				Size = v42:map(function(n3: number) -- line: 286
					-- upvalues: v34 (copy)
					return UDim2.fromScale((n3 - v34.range.Min) / (v34.range.Max - v34.range.Min), 1)
				end),
				testId = `{ v34.testId }--fill`
			}, {
				Knob = if not v34.knob then if not Flags.FoundationToggleVisualUpdate then React.createElement(Knob, {
					AnchorPoint = v58,
					Position = uDim2,
					size = v34.size,
					style = v49.knobStyle,
					stroke = v47.knob.stroke,
					hasShadow = v47.knob.hasShadow,
					testId = `{ v34.testId }--knob`
				}) else React.createElement(PresentationContext.Provider, {
					value = t2
				}, {
					Knob = React.createElement(Knob, {
						AnchorPoint = v58,
						Position = uDim2,
						size = v34.size,
						style = v49.knobStyle,
						stroke = v47.knob.stroke,
						hasShadow = v47.knob.hasShadow,
						testId = `{ v34.testId }--knob`
					})
				}) else React.createElement(View, {
					tag = "size-0-0 auto-xy",
					AnchorPoint = v58,
					Position = uDim2,
					Visible = v40,
					testId = `{ v34.testId }--custom-knob`
				}, v34.knob)
			})
		})
	})
end

return React.forwardRef(Slider)
