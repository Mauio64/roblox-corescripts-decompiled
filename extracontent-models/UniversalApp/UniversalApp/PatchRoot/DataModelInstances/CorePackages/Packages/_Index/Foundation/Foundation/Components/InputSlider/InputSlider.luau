local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local Components = Foundation.Components
local InputLabel = require(Components.InputLabel)
local Text = require(Components.Text)
require(Components.Types)
local View = require(Components.View)

local getStateLayerStyle = require(Components.Interactable.getStateLayerStyle)
local useSliderDirectionalInput = require(Components.InternalSlider.useSliderDirectionalInput)

local devAssert = require(Foundation.Utility.devAssert)
local getBindableValue = require(Foundation.Utility.getBindableValue)
local getDisabledStyle = require(Foundation.Utility.getDisabledStyle)
local mapBindable = require(Foundation.Utility.mapBindable)
local useLastInputMode = require(Foundation.Utility.Input.useLastInputMode)
local usePlugin = require(Foundation.Providers.Plugin.usePlugin)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local ControlState = require(Foundation.Enums.ControlState)

local InputLabelSize = require(Foundation.Enums.InputLabelSize)

local InputMode = require(Foundation.Utility.Input.InputMode)

local OnChangeCallbackReason = require(Foundation.Enums.OnChangeCallbackReason)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

require(Foundation.Providers.Style.Tokens)
local calculateInputSliderValue = require(script.Parent.calculateInputSliderValue)
local formatInputSliderValue = require(script.Parent.formatInputSliderValue)
local snapInputSliderValue = require(script.Parent.snapInputSliderValue)
local useInputSliderFill = require(script.Parent.useInputSliderFill)

local v = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop
}

local v2 = { sensitivity = 1, isDisabled = false, testId = "--foundation-input-slider" }

local function ScrubDragDetector(props)
	if not props.isPresent then
		return nil
	end

	return React.createElement("UIDragDetector", {
		DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
		SelectionModeDragSpeed = UDim2.new(),
		Enabled = props.isEnabled,
		[React.Tag] = `data-testid={props.testId}`,
		[React.Event.DragStart] = props.onDragStart,
		[React.Event.DragContinue] = props.onDragContinue,
		[React.Event.DragEnd] = props.onDragEnd
	})
end

local function isSelectedState(state): boolean -- 1 equivalent call inferred from this helper
	return state == ControlState.Selected or state == ControlState.SelectedPressed
end

local function isHoveredState(p): boolean -- 5 equivalent calls inferred from this helper
	return p == ControlState.Hover or p == ControlState.Pressed
end

local function isPointerOver(p, p2)
	return isHoveredState(p) or isHoveredState(p2) -- inferred equivalent call
end

local function getFieldStateLayerStyle(p, state, state2: boolean) -- 1 equivalent call inferred from this helper
	if state2 then
		return getStateLayerStyle(p, nil, ControlState.Pressed)
	end

	if isHoveredState(state) then -- inferred equivalent call
		return getStateLayerStyle(p, nil, state)
	end

	return nil
end

local function getContentStyles(p, flag: boolean, flag2: boolean)
	local v3

	if flag then
		v3 = p.Color.Content.Emphasis
	else
		v3 = p.Color.Content.Default
	end

	local v4

	if flag then
		v4 = p.Color.Content.Default
	else
		v4 = p.Color.Content.Muted
	end

	return getDisabledStyle(v3, flag2), getDisabledStyle(v4, flag2)
end

local function resolveSensitivity(sensitivity: number) -- 1 equivalent call inferred from this helper
	local v3 = sensitivity > 0
	devAssert(v3, `InputSlider: sensitivity must be positive, got {sensitivity}.`)
	return if v3 then sensitivity else 1
end

local function resolveStep(step: number?) -- 1 equivalent call inferred from this helper
	if step == nil then
		return nil
	end

	local v3 = step > 0
	devAssert(v3, `InputSlider: step must be positive, got {step}.`)
	return if v3 then step else nil
end

local function InputSlider(p, ref)
	local v3 = withDefaults(p, v2)
	local v4 = useTokens()
	local v5 = usePlugin()
	local v6 = useLastInputMode()

	local range = v3.range
	local step = resolveStep(v3.step) -- inferred equivalent call
	local sensitivity = resolveSensitivity(v3.sensitivity) -- inferred equivalent call
	local isDisabled = v3.isDisabled

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(0)
	local ref6 = React.useRef(false)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(ControlState.Initialize)
	local state6, setState6 = React.useState(ControlState.Initialize)
	local v7, v8 = React.useBinding("")
	local selectedState = isSelectedState(state5) -- inferred equivalent call
	local strokestandardstrokepositioninnerstrokesystememphasis = state or state2 or state4
	local getValue = React.useCallback(function()
		return (math.clamp(getBindableValue(v3.value), range.Min, range.Max))
	end, { v3.value, range })

	local v9 = React.useCallback(function(p2: number, p3)
		if p2 ~= getValue() then
			v3.onValueChanged(p2, p3)
		end
	end, { v3.onValueChanged, getValue })

	local v10 = React.useCallback(function()
		local current = ref2.current

		if current == nil or isDisabled then
			return
		end

		current:CaptureFocus()

		task.defer(function()
			if current.Parent ~= nil and current:IsFocused() then
				current.SelectionStart = 1
				current.CursorPosition = utf8.len(current.Text) + 1
			end
		end)
	end, { isDisabled })

	local onDragStart = React.useCallback(function(_, vector2: Vector2)
		if isDisabled then
			return
		end

		setState3(true)
		ref3.current = {
			pressX = vector2.X,
			originX = vector2.X,
			startValue = getValue(),
			hasStarted = false
		}
	end, { isDisabled, getValue })

	local onDragContinue = React.useCallback(function(_, vector2: Vector2)
		local current = ref3.current

		if current == nil then
			return
		end

		if not current.hasStarted then
			if math.abs(vector2.X - current.pressX) < 3 then
				return
			end

			current.hasStarted = true
			current.originX = vector2.X

			ref6.current = false
			setState2(true)

			if v3.onDragStarted then
				v3.onDragStarted()
			end
		end

		v9(
			calculateInputSliderValue(current.startValue, vector2.X - current.originX, sensitivity * 0.25, step, range),
			OnChangeCallbackReason.Drag
		)
	end, { v3.onDragStarted, v9, sensitivity, step, range })

	local onDragEnd = React.useCallback(function()
		setState3(false)
		local current = ref3.current
		ref3.current = nil

		if current == nil then
			return
		end

		if current.hasStarted then
			setState2(false)

			if v3.onDragEnded then
				v3.onDragEnded()
			end
		else
			v10()
		end
	end, { v3.onDragEnded, v10 })

	local ref7 = React.useRef(v3.onDragEnded)
	ref7.current = v3.onDragEnded

	local v11 = React.useCallback(function()
		local current = ref3.current
		ref3.current = nil

		if current == nil or not current.hasStarted then
			return
		end

		setState2(false)

		if ref7.current then
			ref7.current()
		end
	end, {})

	React.useEffect(function()
		return function()
			local current = ref3.current

			ref3.current = nil

			if current ~= nil and current.hasStarted and ref7.current then
				ref7.current()
			end
		end
	end, {})

	local v12 = React.useCallback(function(p2)
		local text = formatInputSliderValue(getValue())
		ref4.current = false
		v8(text)
		p2.Text = text
		setState(true)
	end, { getValue })

	local v13 = React.useCallback(function(p2, flag: boolean, p3)
		setState(false)
		local v13

		if p3 == nil then
			v13 = false
		else
			v13 = p3.KeyCode == Enum.KeyCode.Escape
		end

		if ref4.current or v13 then
			ref4.current = false
			return
		end

		local text = tonumber(p2.Text)
		local v14 = text ~= text

		if text == nil or v14 or p2.Text == formatInputSliderValue(getValue()) then
			return
		end

		local v15 = snapInputSliderValue(text, step, range)

		if v15 ~= getValue() then
			ref6.current = true
		end

		local v16

		if flag then
			v16 = OnChangeCallbackReason.Keyboard
		else
			v16 = OnChangeCallbackReason.FocusLost
		end

		v9(v15, v16)
	end, { getValue, v9, range, step })

	local v14 = React.useCallback(function(p2)
		v8(p2.Text)
	end, {})

	local v15 = React.useCallback(function()
		local current = ref2.current

		if current and current:IsFocused() then
			ref4.current = true
			current:ReleaseFocus()
		end
	end, {})

	local v16 = React.useCallback(function()
		ref5.current = getValue()
		setState4(true)
	end, { getValue })

	local v17 = React.useCallback(function()
		setState4(false)
	end, {})

	local onExit = React.useCallback(function()
		v9(ref5.current, OnChangeCallbackReason.Keyboard)
		setState4(false)
	end, { v9 })

	useSliderDirectionalInput(state4 and not isDisabled, step or 1, range, false, (React.useMemo(function()
		return {
			getValue = getValue,
			onStep = function(p2: number)
				if step == nil then
					local v18 = getValue()
					p2 = math.clamp(v18 + math.sign(p2 - v18) * 1, range.Min, range.Max)
				end

				v9(p2, OnChangeCallbackReason.Keyboard)
			end,
			onExit = onExit
		}
	end, { getValue, v9, onExit, step, range })))

	React.useEffect(function()
		local v18

		if v6 == nil then
			v18 = false
		else
			v18 = v6 ~= InputMode.Directional
		end

		if state4 and (not selectedState or state or v18) then
			setState4(false)
		end
	end, { state4, selectedState, state, v6 })

	local onActivated = React.useCallback(function(_, p2)
		local v18 = p2.KeyCode == Enum.KeyCode.Return or p2.KeyCode == Enum.KeyCode.KeypadEnter

		if not v18 and p2.KeyCode ~= Enum.KeyCode.ButtonA then
			return
		end

		if state4 then
			v17()
		elseif v18 then
			v10()
		else
			v16()
		end
	end, { state4, v17, v10, v16 })

	React.useEffect(function()
		if isDisabled then
			setState4(false)
			v15()
			v11()
		end
	end, { isDisabled, v11 })
	local v18 = not (isDisabled or state) and (state2 or isHoveredState(state5) or isHoveredState(state6)) -- inferred equivalent call
	React.useEffect(function()
		if v5 == nil or not v18 then
			return
		end

		local mouse = v5:GetMouse()
		local icon = mouse.Icon
		mouse.Icon = "rbxasset://SystemCursors/SizeEW"
		return function()
			mouse.Icon = icon
		end
	end, { v5, v18 })

	local v19 = useInputSliderFill(v3.value, range, isDisabled, ref6)

	local text = React.useMemo(function()
		if state then
			return v7
		end

		return mapBindable(v3.value, function(value: number)
			return formatInputSliderValue((math.clamp(value, range.Min, range.Max)))
		end)
	end, { state, v7, v3.value, range })
	local v20

	if strokestandardstrokepositioninnerstrokesystememphasis then
		v20 = v4.Color.Content.Emphasis
	else
		v20 = v4.Color.Content.Default
	end

	local v21

	if strokestandardstrokepositioninnerstrokesystememphasis then
		v21 = v4.Color.Content.Default
	else
		v21 = v4.Color.Content.Muted
	end

	local disabledStyle = getDisabledStyle(v20, isDisabled)
	local disabledStyle2 = getDisabledStyle(v21, isDisabled)
	local backgroundStyle

	if not (isDisabled or state or state4) then
		backgroundStyle = getFieldStateLayerStyle(v4, state5, state2) -- inferred equivalent call
	end

	local v22 = useStyleTags("text-body-small text-align-x-left text-align-y-center gui-object-defaults")

	local v23 = {
		isPresent = state2 or state3 or v6 ~= InputMode.Directional,
		isEnabled = not state and (not isDisabled or state3),
		onDragStart = onDragStart,
		onDragContinue = onDragContinue,
		onDragEnd = onDragEnd
	}

	local createElement = React.createElement

	local v24 = {
		Size = UDim2.new(v3.width or UDim.new(1, 0), UDim.new()),
		tag = "col gap-small auto-y",
		selectionGroup = 0,
		ref = 0
	}
	local selectionGroup

	if state4 then
		selectionGroup = v
	end

	v24.selectionGroup = selectionGroup
	v24.ref = ref
	local v25 = withCommonProps(v3, v24)
	local label

	if v3.label and v3.label ~= "" then
		label = React.createElement(View, {
			tag = "auto-xy",
			onStateChanged = setState6,
			stateLayer = { affordance = StateLayerAffordance.None },
			selection = { Selectable = false },
			isDisabled = isDisabled,
			LayoutOrder = 1,
			testId = `{v3.testId}--label`
		}, {
			Text = React.createElement(InputLabel, {
				Text = v3.label,
				size = InputLabelSize.XSmall,
				isDisabled = isDisabled,
				testId = `{v3.testId}--label-text`
			}),
			DragDetector = React.createElement(
				ScrubDragDetector,
				Dash.join(v23, {
					testId = `{v3.testId}--label--drag-detector`
				})
			)
		})
	end

	local createElement2 = React.createElement
	local v26 = {
		tag = {
			["size-full-600 radius-small"] = true,
			["stroke-standard stroke-position-inner stroke-system-emphasis"] = strokestandardstrokepositioninnerstrokesystememphasis
		},
		stateLayer = { affordance = StateLayerAffordance.None },
		backgroundStyle = { Color3 = Color3.new(1, 1, 1), Transparency = 0.001 },
		cursor = {
			radius = UDim.new(0, v4.Radius.Small),
			offset = v4.Stroke.Thick,
			borderWidth = v4.Stroke.Thick
		},
		onStateChanged = setState5,
		onActivated = onActivated,
		isDisabled = isDisabled,
		LayoutOrder = 2,
		testId = `{v3.testId}--field`
	}
	local children = {
		Fill = React.createElement("UIGradient", {
			Color = v19.color,
			Transparency = v19.transparency,
			Offset = v19.offset,
			[React.Tag] = `data-testid={v3.testId}--fill`
		}),
		DragDetector = React.createElement(
			ScrubDragDetector,
			Dash.join(v23, {
				testId = `{v3.testId}--field--drag-detector`
			})
		),
		StateLayer = 0,
		Content = 0
	}
	local stateLayer

	if backgroundStyle then
		stateLayer = React.createElement(View, {
			tag = "size-full radius-small",
			backgroundStyle = backgroundStyle,
			ZIndex = 2,
			testId = `{v3.testId}--state-layer`
		})
	end

	children.StateLayer = stateLayer

	local createElement3 = React.createElement

	local v27 = {
		Value = React.createElement("TextBox", {
			Text = text,
			ClearTextOnFocus = false,
			TextEditable = not isDisabled,
			Interactable = state,
			Selectable = false,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromScale(0, 1),
			TextColor3 = disabledStyle.Color3,
			TextTransparency = disabledStyle.Transparency,
			LayoutOrder = 1,
			ref = ref2,
			[React.Tag] = `{v22} data-testid={v3.testId}--textbox`,
			[React.Event.Focused] = v12,
			[React.Event.FocusLost] = v13,
			[React.Change.Text] = v14
		}),
		Suffix = 0
	}
	local suffix

	if v3.suffix then
		suffix = React.createElement(Text, {
			Text = v3.suffix,
			tag = "auto-xy text-body-small",
			textStyle = disabledStyle2,
			LayoutOrder = 2,
			testId = `{v3.testId}--suffix`
		})
	end

	v27.Suffix = suffix
	children.Content = createElement3(
		View,
		{ tag = "row align-y-center gap-xxsmall size-full padding-x-small", ZIndex = 3 },
		v27
	)
	return createElement(View, v25, {
		Label = label,
		Field = createElement2(View, v26, children)
	})
end

return React.memo(React.forwardRef(InputSlider))
