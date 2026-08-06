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
local useSliderDirectionalInput = require(script.Parent.useSliderDirectionalInput)
local InputSize = require(Foundation.Enums.InputSize)
local Visibility = require(Foundation.Enums.Visibility)
local SliderVariant = require(Foundation.Enums.SliderVariant)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
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
	colorNamespace = ColorNamespace.Inverse
}
local t3 = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Escape,
	SelectionBehaviorDown = Enum.SelectionBehavior.Escape
}

local function Slider(p1, p2) -- line: 95
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), ControlState (copy), useBindable (copy), Flags (copy), useLastInputMode (copy), usePointerPosition (copy), useSliderVariants (copy), useSliderMotionStates (copy), Visibility (copy), calculateSliderValueFromPosition (copy), calculateSliderStepValue (copy), useSliderDirectionalInput (copy), InputMode (copy), calculatePixelsPerStep (copy), calculateNextStepValue (copy), calculateSliderPositionDelta (copy), View (copy), withCommonProps (copy), Constants (copy), StateLayerAffordance (copy), t3 (copy), PresentationContext (copy), t2 (copy), Knob (copy)
	local v36 = withDefaults(p1, t1)
	local v37 = useTokens()
	local v38, v39 = React.useState(ControlState.Initialize)
	local v40, v41 = React.useState(false)
	local v42, v43 = React.useState(false)
	local v44 = useBindable(v36.value):map(function(p3) -- line: 101
		-- upvalues: v36 (copy)
		return (math.clamp(p3, v36.range.Min, v36.range.Max))
	end)
	local v45 = if not Flags.FoundationSliderOffloadDraggingMath then React.useRef(nil) else nil
	local v46 = if not Flags.FoundationSliderOffloadDraggingMath then nil else React.useRef(nil)
	local v47 = if not Flags.FoundationSliderOffloadDraggingMath then nil else React.useRef(0)
	local v48 = if not Flags.FoundationSliderOffloadDraggingMath then nil else React.useRef(0)
	local v49 = useLastInputMode()
	local v50 = React.useRef(nil)

	React.useImperativeHandle(p2, function() -- line: 118
		-- upvalues: v50 (copy)
		return v50.current
	end, {})

	local v51 = if not Flags.FoundationSliderOffloadDraggingMath then usePointerPosition(v50.current) else nil
	local v52 = useSliderVariants(v37, v36.size, v36.variant)
	local v53 = useSliderMotionStates(v52.knob.style, v52.knob.dragStyle)
	local v54 = React.useMemo(function() -- line: 130
		-- upvalues: v42 (copy), v53 (copy), v40 (copy)
		if not v42 then
			return v53.Hidden
		end

		if v40 then
			return v53.Dragging
		end

		return v53.Idle
	end, {
		v37,
		v42,
		v40,
		v53
	})

	React.useEffect(function() -- line: 137
		-- upvalues: v36 (copy), Visibility (copy), v43 (copy), v40 (copy), v38 (copy), ControlState (copy)
		if v36.knobVisibility == Visibility.None then
			v43(false)

			return
		end

		if v36.knobVisibility == Visibility.Always then
			v43(true)

			return
		end

		v43(v40 or (v38 == ControlState.Hover or (v38 == ControlState.Selected or v38 == ControlState.Pressed)))
	end, {
		v36.knobVisibility,
		v38,
		v40
	})

	local v55 = if not Flags.FoundationSliderOffloadDraggingMath then React.useCallback(function(vector2: Vector2) -- line: 154
		-- upvalues: v50 (copy), calculateSliderValueFromPosition (copy), v36 (copy), calculateSliderStepValue (copy)
		if v50.current then
			local v67 = calculateSliderValueFromPosition(vector2, v50.current, v36.range)

			if v36.step then
				return calculateSliderStepValue(v67, v36.step, v36.range)
			end

			return v67
		end

		return 0
	end, {
		v50,
		v36.range,
		v36.step
	}) else nil
	local v56 = React.useCallback(function(n1: number) -- line: 167
		-- upvalues: v44 (copy), v36 (copy)
		if n1 ~= v44:getValue() and v36.onValueChanged then
			v36.onValueChanged(n1)
		end
	end, {
		v44,
		v36.onValueChanged
	})
	local v57 = if not Flags.FoundationSliderOffloadDraggingMath then React.useCallback(function() -- line: 177
		-- upvalues: v55 (copy), v51 (copy), v56 (copy)
		local v69 = v55(v51:getValue())

		v56(v69)
	end, {
		v55,
		v51,
		v56
	}) else nil

	if Flags.FoundationSliderAsSeenOnTV then
		local v58 = v38 == ControlState.Selected or v38 == ControlState.SelectedPressed

		useSliderDirectionalInput(v58 and not v36.isDisabled, v36.step, v36.range, {
			getValue = function() -- line: 185
				-- upvalues: v44 (copy)
				return v44:getValue()
			end,
			onStep = function(n2: number) -- line: 188
				-- upvalues: v56 (copy), v36 (copy), calculateSliderStepValue (copy)
				v56(if not v36.step then n2 else calculateSliderStepValue(n2, v36.step, v36.range))
			end
		})
	end

	local v59 = if not Flags.FoundationSliderOffloadDraggingMath then React.useCallback(function(_, vector2: Vector2) -- line: 228
		-- upvalues: v50 (copy), v45 (copy), v36 (copy), v49 (copy), InputMode (copy), calculatePixelsPerStep (copy), v44 (copy), calculateNextStepValue (copy), v56 (copy), v55 (copy), calculateSliderPositionDelta (copy)
		if v50.current and v45.current then
			if v36.step and v36.step > 0 then
				if v49 ~= InputMode.Directional then
					local v80 = v55(vector2)

					v56(v80)
					v45.current = vector2

					return
				end

				local v81 = vector2 - v45.current
				local v82 = math.abs(v81.X)
				local v83 = calculatePixelsPerStep(v50.current.AbsoluteSize.X, v36.step, v36.range)

				if v82 > v83 * 2 then
					v45.current = vector2

					return
				end

				if v82 < v83 / 2 then
					return
				end

				local v84 = v44:getValue()
				local v85 = calculateNextStepValue(v81.X, v84, v36.step, v36.range)

				if v85 ~= v84 then
					v56(v85)
					v45.current = vector2

					return
				end
			else
				local Magnitude = v50.current.AbsoluteSize.Magnitude
				local v87 = calculateSliderPositionDelta(vector2, v45.current, Magnitude)

				v45.current = vector2

				if v49 == InputMode.Directional and math.abs(v87) > 0.01 then
					return
				end

				local v88 = v55(vector2)

				v56(v88)
			end
		end
	end, {
		v36.step,
		v36.range,
		v49,
		v44,
		v56,
		v55
	}) else React.useCallback(function(_, _: Vector2) -- line: 197
		-- upvalues: v46 (copy), v36 (copy), v49 (copy), InputMode (copy), v48 (copy), v47 (copy), v44 (copy), v56 (copy), calculateSliderStepValue (copy)
		local current = v46.current

		if not current then
			return
		end

		local v74 = v36.range.Max - v36.range.Min
		local XScale = current.DragUDim2.X.Scale

		if v49 == InputMode.Directional and math.abs(XScale - v48.current) > 0.01 then
			v47.current = (v44:getValue() - v36.range.Min) / v74 - XScale
			v48.current = XScale

			return
		end

		v48.current = XScale

		local v76 = math.clamp(v47.current + XScale, 0, 1)
		local v77 = v36.range.Min + v76 * v74

		v56(if not v36.step then v77 else calculateSliderStepValue(v77, v36.step, v36.range))
	end, {
		v36.step,
		v36.range,
		v49,
		v44,
		v56
	})
	local v60 = if not Flags.FoundationSliderOffloadDraggingMath then React.useCallback(function(_, vector2: Vector2) -- line: 331
		-- upvalues: v45 (copy), v41 (copy), v36 (copy)
		v45.current = vector2
		v41(true)

		if v36.onDragStarted then
			v36.onDragStarted()
		end
	end, { v36.onDragStarted }) else React.useCallback(function(_, vector2: Vector2) -- line: 301
		-- upvalues: v41 (copy), v36 (copy), v48 (copy), v49 (copy), InputMode (copy), v47 (copy), v44 (copy), v50 (copy), calculateSliderValueFromPosition (copy), v56 (copy), calculateSliderStepValue (copy)
		v41(true)

		if v36.onDragStarted then
			v36.onDragStarted()
		end

		v48.current = 0

		local v91 = v36.range.Max - v36.range.Min

		if v49 == InputMode.Directional then
			v47.current = (v44:getValue() - v36.range.Min) / v91

			return
		end

		local v92 = if not v50.current then v36.range.Min else calculateSliderValueFromPosition(vector2, v50.current, v36.range)

		v47.current = (v92 - v36.range.Min) / v91
		v56(if not v36.step then v92 else calculateSliderStepValue(v92, v36.step, v36.range))
	end, {
		v36.onDragStarted,
		v36.step,
		v36.range,
		v49,
		v44,
		v56
	})
	local v61 = React.useCallback(function(_, _: Vector2) -- line: 339
		-- upvalues: v41 (copy), Flags (copy), v45 (copy), v36 (copy)
		v41(false)

		if not Flags.FoundationSliderOffloadDraggingMath then
			v45.current = nil
		end

		if v36.onDragEnded then
			v36.onDragEnded()
		end
	end, { v36.onDragEnded })
	local v62 = React.useCallback(function(p9) -- line: 350
		-- upvalues: v39 (copy), Flags (copy), ControlState (copy), v57 (copy)
		v39(p9)

		if not Flags.FoundationSliderOffloadDraggingMath and p9 == ControlState.Pressed then
			v57()
		end
	end, { v57 })

	if Flags.FoundationSliderOffloadDraggingMath then
		React.useEffect(function() -- line: 359
			-- upvalues: v46 (copy), v47 (copy)
			local current = v46.current

			if not current then
				return
			end

			local v99 = current:AddConstraintFunction(1, function(uDim2: UDim2, n3: number) -- line: 366
				-- upvalues: v47 (copy)
				local current2 = v47.current
				local v106 = math.clamp(uDim2.X.Scale, -current2, 1 - current2)

				return UDim2.fromScale(v106, 0), n3
			end)

			return function() -- line: 374
				-- upvalues: v99 (copy)
				v99:Disconnect()
			end
		end, {})
	end

	local uDim2 = UDim2.fromScale(1, 0.5)
	local v64 = if not v36.isContained then Vector2.new(0.5, 0.5) else v44:map(function(n4: number) -- line: 382
		-- upvalues: v36 (copy)
		local v101 = (n4 - v36.range.Min) / (v36.range.Max - v36.range.Min)

		return Vector2.new(v101, 0.5)
	end)

	return React.createElement(View, withCommonProps(v36, {
		Size = UDim2.new(v36.width, UDim.new(0, v52.hitbox.height)),
		GroupTransparency = if not v36.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		selectionGroup = if not Flags.FoundationSliderAsSeenOnTV then nil else t3,
		onStateChanged = v62,
		isDisabled = v36.isDisabled,
		ref = v50
	}), {
		DragDetector = if not Flags.FoundationSliderOffloadDraggingMath then React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v60,
			[React.Event.DragContinue] = v59,
			[React.Event.DragEnd] = v61,
			SelectionModeDragSpeed = if not Flags.FoundationSliderAsSeenOnTV then nil else UDim2.new(),
			Enabled = not v36.isDisabled
		}) else React.createElement("UIDragDetector", {
			ref = v46,
			DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
			DragAxis = Vector2.new(1, 0),
			ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
			DragRelativity = Enum.UIDragDetectorDragRelativity.Absolute,
			[React.Event.DragStart] = v60,
			[React.Event.DragContinue] = v59,
			[React.Event.DragEnd] = v61,
			SelectionModeDragSpeed = if not Flags.FoundationSliderAsSeenOnTV then nil else UDim2.new(),
			Enabled = not v36.isDisabled
		}),
		Bar = React.createElement(View, {
			tag = v52.bar.tag,
			testId = `{ v36.testId }--bar`
		}, {
			Fill = React.createElement(View, {
				tag = v52.fill.tag,
				Size = v44:map(function(n5: number) -- line: 431
					-- upvalues: v36 (copy)
					return UDim2.fromScale((n5 - v36.range.Min) / (v36.range.Max - v36.range.Min), 1)
				end),
				testId = `{ v36.testId }--fill`
			}, {
				Knob = if not v36.knob then if not Flags.FoundationToggleVisualUpdate then React.createElement(Knob, {
					AnchorPoint = v64,
					Position = uDim2,
					size = v36.size,
					style = v54.knobStyle,
					stroke = v52.knob.stroke,
					hasShadow = v52.knob.hasShadow,
					testId = `{ v36.testId }--knob`
				}) else React.createElement(PresentationContext.Provider, {
					value = t2
				}, {
					Knob = React.createElement(Knob, {
						AnchorPoint = v64,
						Position = uDim2,
						size = v36.size,
						style = v54.knobStyle,
						stroke = v52.knob.stroke,
						hasShadow = v52.knob.hasShadow,
						testId = `{ v36.testId }--knob`
					})
				}) else React.createElement(View, {
					tag = "size-0-0 auto-xy",
					AnchorPoint = v64,
					Position = uDim2,
					Visible = v42,
					testId = `{ v36.testId }--custom-knob`
				}, v36.knob)
			})
		})
	})
end

return React.forwardRef(Slider)
