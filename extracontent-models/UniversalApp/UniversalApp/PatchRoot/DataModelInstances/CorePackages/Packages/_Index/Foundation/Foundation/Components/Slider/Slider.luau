local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local Constants = require(Foundation.Constants)

local Services = require(Foundation.Utility.Wrappers.Services)
local GuiService = Services.GuiService
local InputMode = require(Foundation.Utility.Input.InputMode)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useBindable = require(Foundation.Utility.useBindable)
local useLastInputMode = require(Foundation.Utility.Input.useLastInputMode)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local calculateSliderFraction = require(script.Parent.calculateSliderFraction)
local calculateSliderStepValue = require(script.Parent.calculateSliderStepValue)
local calculateSliderValueFraction = require(script.Parent.calculateSliderValueFraction)
local getGuiInputPosition = require(script.Parent.getGuiInputPosition)
local getSelectionEntryDirection = require(script.Parent.getSelectionEntryDirection)
local useSliderCaptureKeys = require(script.Parent.useSliderCaptureKeys)
local useSliderDirectionalInput = require(script.Parent.useSliderDirectionalInput)

local InputSize = require(Foundation.Enums.InputSize)

local Visibility = require(Foundation.Enums.Visibility)

local Orientation = require(Foundation.Enums.Orientation)

local SliderVariant = require(Foundation.Enums.SliderVariant)

local SliderType = require(Foundation.Enums.SliderType)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local ControlState = require(Foundation.Enums.ControlState)
local CursorType = require(Foundation.Enums.CursorType)
local InternalSlider = require(Foundation.Components.InternalSlider)
local SliderThumb = require(script.Parent.SliderThumb)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local CursorComponent = require(Foundation.Providers.Cursor.CursorComponent)
local Flags = require(Foundation.Utility.Flags)
local Knob = require(Foundation.Components.Knob)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local getKnobSize = require(Foundation.Components.Knob.getKnobSize)
local usePresentationContext = PresentationContext.usePresentationContext
local useSliderVariants = require(Foundation.Components.Slider.useSliderVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)

local v = {
	range = NumberRange.new(0, 1),
	size = InputSize.Medium,
	width = UDim.new(1, 0),
	orientation = Orientation.Horizontal,
	variant = SliderVariant.Standard,
	isDisabled = false,
	isContained = false,
	knobVisibility = Visibility.Auto,
	testId = "--foundation-slider"
}

local v2 = { colorNamespace = ColorNamespace.Inverse }

local v3 = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop
}

local v4 = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Escape,
	SelectionBehaviorRight = Enum.SelectionBehavior.Escape,
	SelectionBehaviorUp = Enum.SelectionBehavior.Escape,
	SelectionBehaviorDown = Enum.SelectionBehavior.Escape
}

local selectionGroup = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop
}

local function Slider(props, ref9)
	if Flags.FoundationSliderRebuild then
		local v5 = withDefaults(props, v)
		local v6 = v5.orientation == Orientation.Vertical
		local v7 = props.type == SliderType.Range
		local v8 = useSliderVariants(useTokens(), v5.size, v5.variant, v6)

		local v9 = useBindable(props.type == SliderType.Range and 0 or props.value)
		local v10

		if props.type == SliderType.Range then
			v10 = props.value
		else
			v10 = NumberRange.new(0)
		end

		local v11 = useBindable(v10)

		local thumbs = React.useMemo(function()
			if v7 then
				return {
					{
						value = v11:map(function(range: NumberRange)
							return range.Min
						end),
						testId = `{v5.testId}--min`
					},
					{
						value = v11:map(function(range: NumberRange)
							return range.Max
						end),
						testId = `{v5.testId}--max`
					}
				}
			end

			return {
				{
					value = v9:map(function(value: number)
						return (math.clamp(value, v5.range.Min, v5.range.Max))
					end),
					testId = `{v5.testId}--thumb`
				}
			}
		end, { v7, v11, v9, v5.range.Min, v5.range.Max, v5.testId })

		local onValueChanged = React.useCallback(function(p: number, p2: number)
			if props.type == SliderType.Range then
				if props.onValueChanged then
					local value = v11:getValue()
					local onValueChanged = props.onValueChanged
					local v12

					if p == 1 then
						v12 = NumberRange.new(p2, value.Max)
					else
						v12 = NumberRange.new(value.Min, p2)
					end

					onValueChanged(v12)
				end
			elseif props.onValueChanged then
				props.onValueChanged(p2)
			end
		end, { props.type, props.onValueChanged, v11 })

		local renderThumb = React.useCallback(function(p: number, p2)
			if v5.knob then
				if v7 then
					return v5.knob
				end

				return React.createElement(
					View,
					{
						tag = "size-0-0 auto-xy",
						Visible = p2.isVisible,
						testId = `{v5.testId}--custom-knob`
					},
					v5.knob
				)
			else
				local createElement = React.createElement
				local provider = PresentationContext.Provider
				local createElement2 = React.createElement
				local v12 = {
					size = v5.size,
					style = 0,
					stroke = 0,
					hasShadow = 0,
					testId = 0
				}
				local style

				if p2.isVisible then
					if p2.isDragging then
						style = v8.knob.dragStyle
					else
						style = v8.knob.style
					end
				else
					style = { Color3 = v8.knob.style.Color3, Transparency = 1 }
				end

				v12.style = style
				local stroke

				if v8.knob.stroke then
					stroke = {
						Color = v8.knob.stroke.Color,
						Thickness = v8.knob.stroke.Thickness,
						Transparency = 0
					}
					local v13

					if typeof(v8.knob.stroke.Transparency) == "number" then
						v13 = v8.knob.stroke.Transparency
					end

					stroke.Transparency = blendTransparencies(v13, p2.isVisible and 0 or 1)
				end

				v12.stroke = stroke

				v12.hasShadow = v8.knob.hasShadow
				local testId

				if v7 then
					testId = `{thumbs[p].testId}--knob`
				else
					testId = `{v5.testId}--knob`
				end

				v12.testId = testId
				return createElement(provider, { value = v2 }, { Knob = createElement2(Knob, v12) })
			end
		end, { v5.knob, v5.size, v5.testId, v7, v8, thumbs })

		local renderTrack = React.useCallback(function(object)
			local fill

			if v7 then
				fill = React.createElement(View, {
					tag = v8.fill.tag,
					Position = object:map(function(p)
						return p.Position
					end),
					Size = object:map(function(p)
						return p.Size
					end),
					testId = `{v5.testId}--fill`
				})
			else
				local createElement = React.createElement
				local v12 = {
					tag = v8.fill.tag,
					AnchorPoint = 0,
					Position = 0,
					Size = 0,
					testId = 0
				}
				local anchorPoint

				if v6 then
					anchorPoint = Vector2.new(0, 1)
				end

				v12.AnchorPoint = anchorPoint
				local position

				if v6 then
					position = UDim2.fromScale(0, 1)
				end

				v12.Position = position
				v12.Size = v9:map(function(p: number)
					local v13 = calculateSliderValueFraction(p, v5.range)

					if v6 then
						return (UDim2.fromScale(1, v13))
					end

					return (UDim2.fromScale(v13, 1))
				end)

				v12.testId = `{v5.testId}--fill`
				fill = createElement(View, v12)
			end

			local createElement = React.createElement
			local v12 = { tag = v8.bar.tag, Size = 0, testId = 0 }
			local size

			if v6 then
				size = UDim2.new(0, v8.bar.height, 1, 0)
			else
				size = UDim2.new(1, 0, 0, v8.bar.height)
			end

			v12.Size = size

			v12.testId = `{v5.testId}--bar`
			return createElement(View, v12, { Fill = fill })
		end, { v5.range, v5.testId, v7, v6, v9, v8 })

		return React.createElement(InternalSlider, withCommonProps(v5, {
			thumbs = thumbs,
			onValueChanged = onValueChanged,
			renderThumb = renderThumb,
			renderTrack = renderTrack,
			range = v5.range,
			step = v5.step,
			size = v5.size,
			width = v5.width,
			orientation = v5.orientation,
			isDisabled = v5.isDisabled,
			isContained = v5.isContained,
			knobVisibility = v5.knobVisibility,
			onDragStarted = v5.onDragStarted,
			onDragEnded = v5.onDragEnded,
			ref = ref9
		}))
	else
		local v5 = withDefaults(props, v)
		local isVertical = v5.orientation == Orientation.Vertical
		local v6 = props.type == SliderType.Range
		local v7 = props.type == SliderType.Range and 0 or props.value
		local onValueChanged

		if props.type == SliderType.Range then
			onValueChanged = nil
		else
			onValueChanged = props.onValueChanged
		end

		local onValueChanged2

		if props.type == SliderType.Range then
			onValueChanged2 = props.onValueChanged
		else
			onValueChanged2 = nil
		end

		local v8 = useTokens()
		local state, setState = React.useState(ControlState.Initialize)
		local state2, setState2 = React.useState(false)
		local state3, setState3 = React.useState(false)
		local state4, setState4

		if Flags.FoundationSliderCapture then
			state4, setState4 = React.useState(false)
		else
			state4 = nil
			setState4 = nil
		end

		local state5, setState5

		if Flags.FoundationSliderCapture then
			state5, setState5 = React.useState(false)
		else
			setState5 = nil
			state5 = nil
		end

		local ref

		if Flags.FoundationSliderCapture then
			ref = React.useRef(nil)
		else
			ref = nil
		end

		local ref2

		if Flags.FoundationSliderCapture then
			ref2 = React.useRef(nil)
		else
			ref2 = nil
		end

		local ref3

		if Flags.FoundationSliderCapture then
			ref3 = React.useRef(false)
		else
			ref3 = nil
		end

		local ref4 = React.useRef(false)
		local state6, setState6 = React.useState(false)
		local mapped = useBindable(v7):map(function(value)
			return (math.clamp(value, v5.range.Min, v5.range.Max))
		end)
		local v9

		if props.type == SliderType.Range then
			v9 = props.value
		else
			v9 = NumberRange.new(0)
		end

		local v10 = useBindable(v9)

		local ref5 = React.useRef(nil)

		local ref6 = React.useRef(0)
		local minDragTranslation, v11 = React.useBinding(UDim2.new())
		local maxDragTranslation, v12 = React.useBinding(UDim2.new())
		local v13 = React.useCallback(function(p: number)
			if isVertical then
				v11(UDim2.fromScale(0, p - 1))
				v12(UDim2.fromScale(0, p))
			else
				v11(UDim2.fromScale(-p, 0))
				v12(UDim2.fromScale(1 - p, 0))
			end
		end, { isVertical })

		local ref7 = React.useRef(0)
		local v14 = useLastInputMode()
		local ref8 = React.useRef(nil)
		React.useImperativeHandle(ref9, function()
			return ref8.current
		end, {})

		local referenceUIInstance, v15 = React.useBinding(nil)
		local ref10 = ReactUtils.useComposedRef(ref8, v15)

		local v16 = useSliderVariants(v8, v5.size, v5.variant, isVertical)

		local style = React.useMemo(function()
			if not state3 then
				return { Color3 = v16.knob.style.Color3, Transparency = 1 }
			end

			if state2 and not v6 then
				return v16.knob.dragStyle
			end

			return v16.knob.style
		end, { v16, state3, state2, v6 })

		local v17 = state == ControlState.Selected
			or state == ControlState.SelectedPressed
			or Flags.FoundationSliderCapture and state4
		local v18

		if Flags.FoundationSliderCapture then
			v18 = React.useCallback(function()
				if state4 then
					if v6 then
						setState5(not state5)
					end
				else
					setState4(true)
				end
			end, { state4, v6, state5 })
		end

		if Flags.FoundationSliderCapture then
			useSliderCaptureKeys(v17 and not v5.isDisabled, v18)
		end

		if Flags.FoundationSliderCapture then
			React.useEffect(function()
				if v5.isDisabled then
					setState4(false)
				end
			end, { v5.isDisabled })

			React.useEffect(function()
				local function redirectDragSelection() -- 1 equivalent call inferred from this helper
					local selectedObject = GuiService.SelectedObject
					local v19

					if selectedObject == ref8.current then
						v19 = true
					elseif selectedObject == nil or ref8.current == nil then
						v19 = false
					else
						v19 = selectedObject:IsDescendantOf(ref8.current)

						if v19 then
							if selectedObject == ref.current then
								v19 = false
							else
								v19 = selectedObject ~= ref2.current
							end
						end
					end

					if v19 then
						GuiService.SelectedObject = ref.current
					end
				end

				redirectDragSelection() -- inferred equivalent call
				local selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(redirectDragSelection)
				return function()
					selectedObjectChangedConnection:Disconnect()
				end
			end, {})

			React.useEffect(function()
				if not state4 then
					return
				end

				GuiService.SelectedObject = ref2.current
				local selectedObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
					if GuiService.SelectedObject ~= ref2.current then
						setState4(false)
					end
				end)
				return function()
					selectedObjectChangedConnection:Disconnect()
				end
			end, { state4 })
		end

		React.useEffect(function()
			if v5.isDisabled then
				setState3(false)
			elseif v5.knobVisibility == Visibility.None then
				setState3(v17)
			elseif v5.knobVisibility == Visibility.Always then
				setState3(true)
			else
				setState3(state2 or state == ControlState.Hover or state == ControlState.Selected or state == ControlState.Pressed)
			end
		end, { v5.knobVisibility, state, state2, v5.isDisabled, v17 })

		local v19 = React.useCallback(function(p: number)
			if p ~= mapped:getValue() and onValueChanged then
				onValueChanged(p)
			end
		end, { mapped, onValueChanged })

		local v20 = React.useCallback(function(range: NumberRange)
			local value = v10:getValue()

			if
				onValueChanged2
				and (typeof(value) ~= "NumberRange" or range.Min ~= value.Min or range.Max ~= value.Max)
			then
				onValueChanged2(range)
			end
		end, { v10, onValueChanged2 })

		local v21 = React.useCallback(function(flag: boolean)
			setState6(flag)

			if Flags.FoundationSliderCapture then
				setState5(flag)
			end

			setState2(true)

			if v5.onDragStarted then
				v5.onDragStarted()
			end
		end, { v5.onDragStarted })

		local onDragEnded = React.useCallback(function()
			setState2(false)

			if v5.onDragEnded then
				v5.onDragEnded()
			end
		end, { v5.onDragEnded })

		local onDragStarted = React.useCallback(function()
			v21(false)
		end, { v21 })
		local onDragStarted2 = React.useCallback(function()
			v21(true)
		end, { v21 })

		local v22 = React.useCallback(function(p: number)
			return (math.clamp((p - v5.range.Min) / (v5.range.Max - v5.range.Min), 0, 1))
		end, { v5.range.Min, v5.range.Max })
		local v23 = React.useCallback(function(p: number)
			return v5.range.Min + p * (v5.range.Max - v5.range.Min)
		end, { v5.range.Min, v5.range.Max })
		local v24 = React.useCallback(function(p: number)
			local v24 = v23(p)

			if v5.step then
				return (calculateSliderStepValue(v24, v5.step, v5.range))
			end

			return v24
		end, { v23, v5.step, v5.range })

		local getBounds = React.useCallback(function()
			local v25 = v22(v10:getValue().Max)

			if v5.step and v5.step > 0 then
				local v26 = math.floor((v23(v25) - v5.range.Min) / v5.step + 0.5)
				v25 = v22(v5.range.Min + v26 * v5.step)
			end

			return 0, v25
		end, { v10, v22, v5.step, v23, v5.range.Min })

		local getBounds2 = React.useCallback(function()
			local v25 = v22(v10:getValue().Min)

			if v5.step and v5.step > 0 then
				local v26 = math.floor((v23(v25) - v5.range.Min) / v5.step + 0.5)
				v25 = v22(v5.range.Min + v26 * v5.step)
			end

			return v25, 1
		end, { v10, v22, v5.step, v23, v5.range.Min })

		local onSeek = React.useCallback(function(p: number)
			local value = v10:getValue()
			v20(NumberRange.new(math.min(v24(p), value.Max), value.Max))
		end, { v10, v20, v24 })
		local onSeek2 = React.useCallback(function(p: number)
			local value = v10:getValue()
			v20(NumberRange.new(value.Min, (math.max(v24(p), value.Min))))
		end, { v10, v20, v24 })

		local v25 = React.useCallback(function(value: number, flag: boolean)
			if flag then
				local v25, v26 = getBounds2()
				onSeek2((math.clamp(value, v25, v26)))
			else
				local v25, v26 = getBounds()
				onSeek((math.clamp(value, v25, v26)))
			end
		end, { getBounds2, getBounds, onSeek2, onSeek })

		local v26 = React.useCallback(function(_, vector2: Vector2)
			if not v6 or v14 == InputMode.Directional or not ref8.current then
				return
			end

			local v26 = calculateSliderFraction(getGuiInputPosition(vector2, ref8.current), ref8.current, isVertical)
			local value = v10:getValue()
			local v27 = v22(value.Min)
			local v28 = v22(value.Max)
			local current

			if math.abs(v28 - v26) < math.abs(v26 - v27) then
				current = true
			elseif v27 == v28 then
				current = v28 < v26
			else
				current = false
			end

			ref4.current = current

			if Flags.FoundationSliderCapture then
				setState5(current)
			end

			v21(current)
			v25(v26, current)
		end, { v6, v14, isVertical, v10, v21, v25, v22 })

		local v27 = React.useCallback(function(_, vector2: Vector2)
			if not v6 or v14 == InputMode.Directional or not ref8.current then
				return
			end

			v25(
				calculateSliderFraction(getGuiInputPosition(vector2, ref8.current), ref8.current, isVertical),
				ref4.current
			)
		end, { v6, v14, isVertical, v25 })

		local v28 = React.useCallback(function()
			if not v6 then
				return
			end

			onDragEnded()
		end, { v6, onDragEnded })
		local v29

		if Flags.FoundationSliderCapture then
			v29 = React.useCallback(function()
				setState4(false)
				GuiService.SelectedObject = ref.current
			end, {})
		else
			v29 = nil
		end

		local useMemo = React.useMemo
		local function fn()
			local v30 = {
				getValue = function()
					if not (Flags.FoundationSliderCapture and v6) then
						return mapped:getValue()
					end

					local value = v10:getValue()
					return if state5 then value.Max else value.Min
				end,
				onStep = 0,
				onExit = 0
			}
			local onStep

			if Flags.FoundationSliderCapture then
				onStep = function(p: number)
					if not v6 then
						v19(p)

						return
					end

					local value = v10:getValue()

					if state5 then
						v20(NumberRange.new(value.Min, (math.max(p, value.Min))))
					else
						v20(NumberRange.new(math.min(p, value.Max), value.Max))
					end
				end
			else
				onStep = function(p: number)
					if v5.step then
						p = calculateSliderStepValue(p, v5.step, v5.range)
					end

					v19(p)
				end
			end

			v30.onStep = onStep
			local onExit

			if Flags.FoundationSliderCapture then
				onExit = v29
			end

			v30.onExit = onExit
			return v30
		end

		local step = v5.step
		local range = v5.range
		local v30

		if Flags.FoundationSliderCapture then
			v30 = v6
		end

		local v31

		if Flags.FoundationSliderCapture then
			v31 = v10
		end

		local v32

		if Flags.FoundationSliderCapture then
			v32 = state5
		end

		local v48

		if Flags.FoundationSliderCapture then
			v48 = v20
		end

		local v49

		if Flags.FoundationSliderCapture then
			v49 = v29
		end

		local v50 = useMemo(fn, {
			mapped,
			v19,
			step,
			range,
			v30,
			v31,
			v32,
			v48,
			v49
		})

		local v51 = v17 and not v5.isDisabled
		local v52

		if Flags.FoundationSliderCapture then
			v52 = v51 and state4
		else
			v52 = v51 and not v6
		end

		useSliderDirectionalInput(v52, v5.step, v5.range, isVertical, v50)

		local v53 = React.useCallback(function(_, _: Vector2)
			local current = ref5.current

			if not current then
				return
			end

			local v54 = v5.range.Max - v5.range.Min
			local current2

			if isVertical then
				current2 = -current.DragUDim2.Y.Scale
			else
				current2 = current.DragUDim2.X.Scale
			end

			if v14 == InputMode.Directional and math.abs(current2 - ref7.current) > 0.01 then
				ref6.current = (mapped:getValue() - v5.range.Min) / v54 - current2
				ref7.current = current2
				v13(ref6.current)
			else
				ref7.current = current2

				local v56 = math.clamp(ref6.current + current2, 0, 1)
				local v57 = v5.range.Min + v56 * v54

				if v5.step then
					v57 = calculateSliderStepValue(v57, v5.step, v5.range)
				end

				v19(v57)
			end
		end, { v5.step, v5.range, v14, mapped, v19, isVertical, v13 })

		local v54 = React.useCallback(function(_, vector2: Vector2)
			setState2(true)

			if v5.onDragStarted then
				v5.onDragStarted()
			end

			ref7.current = 0

			local v55 = v5.range.Max - v5.range.Min

			if v14 == InputMode.Directional then
				ref6.current = (mapped:getValue() - v5.range.Min) / v55
				v13(ref6.current)
			else
				local v56

				if ref8.current then
					v56 = v5.range.Min + calculateSliderFraction(
						getGuiInputPosition(vector2, ref8.current),
						ref8.current,
						isVertical
					) * v55
				else
					v56 = v5.range.Min
				end

				ref6.current = (v56 - v5.range.Min) / v55

				if v5.step then
					v56 = calculateSliderStepValue(v56, v5.step, v5.range)
				end

				v19(v56)

				v13(ref6.current)
			end
		end, { v5.onDragStarted, v5.step, v5.range, v14, mapped, v19, isVertical, v13 })

		local v55 = React.useCallback(function(_, _: Vector2)
			setState2(false)

			if v5.onDragEnded then
				v5.onDragEnded()
			end
		end, { v5.onDragEnded })

		local onStateChanged = React.useCallback(function(p)
			setState(p)

			if Flags.FoundationSliderCapture then
				local current = p == ControlState.Selected or p == ControlState.SelectedPressed

				if v6 and current and not ref3.current then
					setState5(getSelectionEntryDirection(isVertical) < 0)
				end

				ref3.current = current
			end
		end, { v6, isVertical })

		local v57 = usePresentationContext()
		React.useEffect(function()
			local current = ref5.current

			if not current then
				return
			end

			current.ReferenceUIInstance = ref8.current
		end, {})
		local udim

		if isVertical then
			udim = UDim2.fromScale(0.5, 0)
		else
			udim = UDim2.fromScale(1, 0.5)
		end

		local anchorPoint

		if v5.isContained then
			anchorPoint = mapped:map(function(p: number)
				local v59 = (p - v5.range.Min) / (v5.range.Max - v5.range.Min)

				if isVertical then
					return (Vector2.new(0.5, 1 - v59))
				end

				return (Vector2.new(v59, 0.5))
			end)
		else
			anchorPoint = Vector2.new(0.5, 0.5)
		end

		local udim2 = UDim.new(0, getKnobSize(v8, v5.size).X.Offset)
		local udim3

		if isVertical then
			udim3 = UDim2.new(udim2, v5.width)
		else
			udim3 = UDim2.new(v5.width, udim2)
		end

		local stroke = React.useMemo(function()
			local stroke = v16.knob.stroke

			if stroke == nil then
				return nil
			end

			local v60 = { Color = stroke.Color, Thickness = stroke.Thickness, Transparency = 0 }
			local v61

			if typeof(stroke.Transparency) == "number" then
				v61 = stroke.Transparency
			end

			v60.Transparency = blendTransparencies(v61, state3 and 0 or 1)
			return v60
		end, { v16, state3 })

		local v60, v61 = React.useBinding(Vector2.zero)
		local onAbsoluteSizeChanged = React.useCallback(function(p)
			v61(p.AbsoluteSize)
		end, {})
		local knobAppearance = React.useMemo(function()
			local v64 = { size = v5.size, style = 0, stroke = 0, hasShadow = 0 }
			local style2

			if state3 and state2 and not state6 then
				style2 = v16.knob.dragStyle
			else
				style2 = style
			end

			v64.style = style2

			v64.stroke = stroke
			v64.hasShadow = v16.knob.hasShadow
			return v64
		end, {
			v5.size,
			state3,
			state2,
			state6,
			v16.knob.dragStyle,
			style,
			stroke,
			v16.knob.hasShadow
		})

		local knobAppearance2 = React.useMemo(function()
			local v65 = { size = v5.size, style = 0, stroke = 0, hasShadow = 0 }
			local style2

			if state3 and state2 and state6 then
				style2 = v16.knob.dragStyle
			else
				style2 = style
			end

			v65.style = style2

			v65.stroke = stroke
			v65.hasShadow = v16.knob.hasShadow
			return v65
		end, {
			v5.size,
			state3,
			state2,
			state6,
			v16.knob.dragStyle,
			style,
			stroke,
			v16.knob.hasShadow
		})

		local mapped2 = v10:map(function(range2: NumberRange)
			return v22(range2.Min)
		end)

		local mapped3 = v10:map(function(range2: NumberRange)
			return v22(range2.Max)
		end)

		local v65 = v17 and (not Flags.FoundationSliderCapture or state4)
		local v66

		if Flags.FoundationSliderCapture and v6 then
			v66 = if state5 then mapped3 else mapped2
		end

		local anchorPoint2

		if Flags.FoundationSliderCapture and v6 then
			if v5.isContained then
				anchorPoint2 = v66:map(function(p: number)
					if isVertical then
						return (Vector2.new(0.5, 1 - p))
					end

					return (Vector2.new(p, 0.5))
				end)
			else
				anchorPoint2 = Vector2.new(0.5, 0.5)
			end
		end

		local size

		if Flags.FoundationSliderCapture and v6 then
			if v5.knob then
				size = v60:map(function(vector2: Vector2)
					return UDim2.fromOffset(vector2.X, vector2.Y)
				end)
			else
				size = getKnobSize(v8, v5.size)
			end
		end

		local onStateChanged2

		if Flags.FoundationSliderCapture then
			onStateChanged2 = React.useCallback(function(_) end, {})
		end

		local v70 = Flags.FoundationSliderCapture

		if v70 then
			v70 = v14 == InputMode.Directional and v17
		end

		local dragDetector

		if not v70 then
			if v6 then
				dragDetector = React.createElement("UIDragDetector", {
					DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
					[React.Event.DragStart] = v26,
					[React.Event.DragContinue] = v27,
					[React.Event.DragEnd] = v28,
					SelectionModeDragSpeed = UDim2.new(),
					Enabled = not v5.isDisabled
				})
			else
				local createElement = React.createElement
				local v73 = {}
				v73.ref = ref5
				v73.ReferenceUIInstance = referenceUIInstance
				v73.DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine
				local dragAxis

				if isVertical then
					dragAxis = Vector2.new(0, 1)
				else
					dragAxis = Vector2.new(1, 0)
				end

				v73.DragAxis = dragAxis
				v73.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
				v73.DragRelativity = Enum.UIDragDetectorDragRelativity.Absolute
				v73.MinDragTranslation = minDragTranslation
				v73.MaxDragTranslation = maxDragTranslation
				v73[React.Event.DragStart] = v54
				v73[React.Event.DragContinue] = v53
				v73[React.Event.DragEnd] = v55
				v73.SelectionModeDragSpeed = UDim2.new()
				v73.Enabled = not v5.isDisabled
				dragDetector = createElement("UIDragDetector", v73)
			end
		end

		local children

		if v6 then
			children = { Fill = 0, MinKnob = 0, MaxKnob = 0, SelectionCursor = 0 }
			local createElement = React.createElement
			local v72 = {
				tag = v16.fill.tag,
				AnchorPoint = Vector2.new(0, 0),
				Position = 0,
				Size = 0,
				testId = 0
			}
			local position

			if isVertical then
				position = mapped3:map(function(p: number)
					return UDim2.fromScale(0, 1 - p)
				end)
			else
				position = mapped2:map(function(p: number)
					return UDim2.fromScale(p, 0)
				end)
			end

			v72.Position = position

			v72.Size = v10:map(function(range2: NumberRange)
				local v74 = v22(range2.Max) - v22(range2.Min)

				if isVertical then
					return (UDim2.fromScale(1, v74))
				end

				return (UDim2.fromScale(v74, 1))
			end)

			v72.testId = `{v5.testId}--fill`
			children.Fill = createElement(View, v72)

			local createElement2 = React.createElement
			local v74 = {
				trackRef = ref8,
				fraction = mapped2,
				isVertical = isVertical,
				isDisabled = v5.isDisabled,
				isDragEnabled = not v70,
				knobAppearance = knobAppearance,
				knob = v5.knob,
				isContained = v5.isContained,
				onSeek = onSeek,
				getBounds = getBounds,
				onDragStarted = onDragStarted,
				onDragEnded = onDragEnded,
				Visible = state3,
				onAbsoluteSizeChanged = 0,
				LayoutOrder = 1,
				testId = 0
			}
			local onAbsoluteSizeChanged2

			if Flags.FoundationSliderCapture then
				onAbsoluteSizeChanged2 = onAbsoluteSizeChanged
			end

			v74.onAbsoluteSizeChanged = onAbsoluteSizeChanged2

			v74.testId = `{v5.testId}--min`
			children.MinKnob = createElement2(SliderThumb, v74)

			local createElement3 = React.createElement
			local v76 = {
				trackRef = ref8,
				fraction = mapped3,
				isVertical = isVertical,
				isDisabled = v5.isDisabled,
				isDragEnabled = not v70,
				knobAppearance = knobAppearance2,
				knob = v5.knob,
				isContained = v5.isContained,
				onSeek = onSeek2,
				getBounds = getBounds2,
				onDragStarted = onDragStarted2,
				onDragEnded = onDragEnded,
				Visible = state3,
				onAbsoluteSizeChanged = 0,
				LayoutOrder = 2,
				testId = 0
			}

			if not Flags.FoundationSliderCapture then
				onAbsoluteSizeChanged = nil
			end

			v76.onAbsoluteSizeChanged = onAbsoluteSizeChanged

			v76.testId = `{v5.testId}--max`
			children.MaxKnob = createElement3(SliderThumb, v76)
			local selectionCursor

			if Flags.FoundationSliderCapture and v65 then
				selectionCursor = React.createElement(View, {
					Size = size,
					AnchorPoint = anchorPoint2,
					Position = v66:map(function(p: number)
						if isVertical then
							return (UDim2.fromScale(0.5, 1 - p))
						end

						return (UDim2.fromScale(p, 0.5))
					end),
					ZIndex = 3,
					selection = { Selectable = true },
					selectionGroup = selectionGroup,
					cursor = CursorType.Invisible,
					onStateChanged = onStateChanged2,
					ref = ref2,
					testId = `{v5.testId}--selection-cursor`
				}, {
					Cursor = React.createElement(CursorComponent, {
						isVisible = true,
						cornerRadius = UDim.new(0.5, 0),
						offset = v8.Padding.XSmall,
						borderWidth = v8.Stroke.Thicker,
						colorNamespace = v57.colorNamespace
					})
				})
			end

			children.SelectionCursor = selectionCursor
		else
			children = { Fill = 0 }
			local createElement = React.createElement
			local v72 = {
				tag = v16.fill.tag,
				AnchorPoint = 0,
				Position = 0,
				Size = 0,
				testId = 0
			}
			local anchorPoint3

			if isVertical then
				anchorPoint3 = Vector2.new(0, 1)
			end

			v72.AnchorPoint = anchorPoint3
			local position

			if isVertical then
				position = UDim2.fromScale(0, 1)
			end

			v72.Position = position
			v72.Size = mapped:map(function(p: number)
				local v75 = (p - v5.range.Min) / (v5.range.Max - v5.range.Min)

				if isVertical then
					return (UDim2.fromScale(1, v75))
				end

				return (UDim2.fromScale(v75, 1))
			end)

			v72.testId = `{v5.testId}--fill`
			local selectionCursor

			if v65 then
				local createElement2 = React.createElement
				local size2

				if v5.knob then
					size2 = v60:map(function(vector2: Vector2)
						return UDim2.fromOffset(vector2.X, vector2.Y)
					end)
				else
					size2 = getKnobSize(v8, v5.size)
				end

				local v77 = {
					Size = size2,
					AnchorPoint = anchorPoint,
					Position = udim,
					selection = Flags.FoundationSliderCapture and { Selectable = true } or nil,
					selectionGroup = 0,
					cursor = 0,
					onStateChanged = 0,
					ref = 0,
					testId = 0
				}
				local selectionGroup2

				if Flags.FoundationSliderCapture then
					selectionGroup2 = selectionGroup
				end

				v77.selectionGroup = selectionGroup2
				local cursor

				if Flags.FoundationSliderCapture then
					cursor = CursorType.Invisible
				end

				v77.cursor = cursor
				v77.onStateChanged = onStateChanged2
				v77.ref = ref2
				v77.testId = `{v5.testId}--selection-cursor`
				selectionCursor = createElement2(View, v77, {
					Cursor = React.createElement(CursorComponent, {
						isVisible = true,
						cornerRadius = UDim.new(0.5, 0),
						offset = v8.Padding.XSmall,
						borderWidth = v8.Stroke.Thicker,
						colorNamespace = v57.colorNamespace
					})
				})
			end

			local knob

			if v5.knob then
				knob = React.createElement(View, {
					tag = "size-0-0 auto-xy",
					AnchorPoint = anchorPoint,
					Position = udim,
					Visible = state3,
					onAbsoluteSizeChanged = onAbsoluteSizeChanged,
					testId = `{v5.testId}--custom-knob`
				}, v5.knob)
			else
				knob = React.createElement(PresentationContext.Provider, { value = v2 }, {
					Knob = React.createElement(Knob, {
						AnchorPoint = anchorPoint,
						Position = udim,
						size = v5.size,
						style = style,
						stroke = stroke,
						hasShadow = v16.knob.hasShadow,
						testId = `{v5.testId}--knob`
					})
				})
			end

			children.Fill = createElement(View, v72, {
				SelectionCursor = selectionCursor,
				Knob = knob
			})
		end

		local size2

		if isVertical then
			size2 = UDim2.new(0, v16.bar.height, 1, 0)
		else
			size2 = UDim2.new(1, 0, 0, v16.bar.height)
		end

		local element = React.createElement(
			View,
			{ tag = v16.bar.tag, Size = size2, testId = `{v5.testId}--bar` },
			children
		)

		local v73 = { DragDetector = dragDetector, Bar = element }

		if Flags.FoundationSliderCapture then
			local createElement = React.createElement
			local groupTransparency

			if v5.isDisabled then
				groupTransparency = Constants.DISABLED_TRANSPARENCY
			end

			local selectionGroup2 = if state4 then v3 else v4

			if v6 then
				ref10 = ref8
			end

			local v77 = withCommonProps(v5, {
				Size = udim3,
				GroupTransparency = groupTransparency,
				selectionGroup = selectionGroup2,
				ref = ref10
			})

			local createElement2 = React.createElement

			local v79 = {
				Size = UDim2.fromScale(1, 1),
				stateLayer = { affordance = StateLayerAffordance.None },
				cursor = 0,
				onStateChanged = 0,
				isDisabled = 0,
				ref = 0,
				ZIndex = 0,
				testId = 0
			}
			local cursor

			if state4 then
				cursor = CursorType.Invisible
			end

			v79.cursor = cursor
			v79.onStateChanged = onStateChanged
			v79.isDisabled = v5.isDisabled
			v79.ref = ref

			v79.testId = `{v5.testId}--focus-target`
			return createElement(View, v77, {
				FocusTarget = createElement2(View, v79, { DragDetector = dragDetector }),
				Bar = element
			})
		else
			local createElement = React.createElement
			local groupTransparency

			if v5.isDisabled then
				groupTransparency = Constants.DISABLED_TRANSPARENCY
			end

			local v74 = {
				Size = udim3,
				GroupTransparency = groupTransparency,
				stateLayer = { affordance = StateLayerAffordance.None },
				selectionGroup = 0,
				cursor = 0,
				onStateChanged = 0,
				isDisabled = 0,
				ref = 0
			}
			local selectionGroup2

			if not v6 then
				selectionGroup2 = v16.selectionGroup
			end

			v74.selectionGroup = selectionGroup2
			v74.cursor = CursorType.Invisible
			v74.onStateChanged = onStateChanged
			v74.isDisabled = v5.isDisabled

			if v6 then
				ref10 = ref8
			end

			v74.ref = ref10
			return createElement(View, withCommonProps(v5, v74), v73)
		end
	end
end

return React.forwardRef(Slider)
