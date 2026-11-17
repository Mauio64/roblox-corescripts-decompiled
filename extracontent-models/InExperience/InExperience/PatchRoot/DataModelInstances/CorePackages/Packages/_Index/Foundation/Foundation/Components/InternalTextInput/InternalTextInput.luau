local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local Components = Foundation.Components
local Icon = require(Components.Icon)
local Padding = require(Components.Padding)
local ScrollView = require(Components.ScrollView)
require(Components.Types)
local View = require(Components.View)

local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local getBindableValue = require(Foundation.Utility.getBindableValue)
local getDisabledStyle = require(Foundation.Utility.getDisabledStyle)
local getMultiLineTextHeight = require(Foundation.Utility.getMultiLineTextHeight)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local mapBindable = require(Foundation.Utility.mapBindable)
local normalizeFontFace = require(Foundation.Utility.normalizeFontFace)
local truncateTextToCursor = require(script.Parent.truncateTextToCursor)
local useBindable = require(Foundation.Utility.useBindable)
local usePreferredInput = require(Foundation.Utility.usePreferredInput)
local useStyleTags = require(Foundation.Providers.Style.useStyleTags)
local useTextInputVariants = require(Components.TextInput.useTextInputVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local InputFocusBehavior = require(Foundation.Enums.InputFocusBehavior)

local InputSize = require(Foundation.Enums.InputSize)

local InputVariant = require(Foundation.Enums.InputVariant)

local Radius = require(Foundation.Enums.Radius)

require(Foundation.Enums.ControlState)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local v = {
	size = InputSize.Large,
	variant = InputVariant.Standard,
	numLines = 1,
	testId = "--foundation-internal-text-input",
	Selectable = true
}

local memo = React.memo(React.forwardRef(function(props, ref)
	local isBoundsChecker = props.isBoundsChecker
	local isMultiLine = props.isMultiLine or isBoundsChecker

	local createElement = React.createElement

	local v2 = {}
	v2.ClearTextOnFocus = false
	v2.Selectable = false
	v2.Active = not isBoundsChecker and nil
	v2.Visible = not isBoundsChecker and nil
	v2.FontFace = normalizeFontFace(props.fontStyle.Font)
	v2.TextSize = props.fontStyle.FontSize
	v2.LineHeight = props.fontStyle.LineHeight
	local textColor

	if props.textStyle then
		textColor = props.textStyle.Color3
	end

	v2.TextColor3 = textColor
	local textTransparency

	if props.textStyle then
		textTransparency = props.textStyle.Transparency
	end

	v2.TextTransparency = textTransparency
	v2.MultiLine = isMultiLine
	v2.TextWrapped = isMultiLine
	local textYAlignment

	if isMultiLine then
		textYAlignment = Enum.TextYAlignment.Top
	else
		textYAlignment = Enum.TextYAlignment.Center
	end

	v2.TextYAlignment = textYAlignment
	v2.TextEditable = not isBoundsChecker and not props.isDisabled
	v2.Interactable = props.Interactable
	v2.PlaceholderText = props.placeholder
	local textInputType

	if isPluginSecurity() then
		textInputType = props.textInputType
	end

	v2.TextInputType = textInputType
	local size

	if props.Size == nil then
		size = UDim2.fromScale(1, 1)
	else
		size = props.Size
	end

	v2.Size = size
	v2.AutomaticSize = props.automaticSize
	local text

	if not isBoundsChecker then
		text = props.text
	end

	v2.Text = text
	v2.ref = ref
	v2[React.Tag] = props.tag
	v2[React.Change.Text] = props.onTextChanged
	v2[React.Change.CursorPosition] = props.onCursorPositionChanged
	v2[React.Event.Focused] = props.onFocusGained
	v2[React.Event.FocusLost] = props.onFocusLost
	v2[React.Event.InputChanged] = props.onInputChanged
	v2[React.Event.InputEnded] = props.onInputEnded
	return createElement("TextBox", v2, props.padding and {
		Padding = React.createElement(Padding, { value = props.padding })
	} or nil, props.children)
end))

local function InternalTextInput(p, p2)
	if p.Selectable == nil then
		p.Selectable = true
	end

	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local v4 = math.max(1, v2.numLines)
	local isMultiLine = v4 > 1
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef("")
	local ref6 = React.useRef(getBindableValue(v2.text))

	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(Vector2.zero)

	local state, setState = React.useState(false)
	local interactable, v5 = React.useBinding(false)
	local v6 = React.useCallback(function(flag: boolean)
		v5(flag)
		setState(flag)
	end, {})

	local v7 = useTextInputVariants(v3, v2.size, v2.variant, v2.radius, state, v2.hasError)
	local container = v7.container
	local v8 = useStyleTags(v7.textBox.tag)

	local v9 = usePreferredInput()
	local state2, setState2 = React.useState(false)
	local v10 = v9 == Enum.PreferredInput.Touch

	local standard = v3.Stroke.Standard
	local v11 = math.ceil(standard) * 2
	local v12 = math.ceil(v3.Stroke.Thick) * 2

	local disabledStyle = getDisabledStyle(v3.Color.Content.Emphasis, v2.isDisabled)
	local fontStyle = v7.textBox.fontStyle
	local fontSize = fontStyle.FontSize
	local lineHeight = fontStyle.LineHeight

	local setSelectionStart = React.useCallback(function(selectionStart)
		if ref.current then
			ref.current.SelectionStart = selectionStart
		end

		if ref2.current then
			ref2.current.SelectionStart = selectionStart
		end
	end, {})

	local setCursorPosition = React.useCallback(function(cursorPosition)
		if ref.current then
			ref.current.CursorPosition = cursorPosition
		end

		if ref2.current then
			ref2.current.CursorPosition = cursorPosition
		end
	end, {})

	local v13 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current == nil or current.Parent == nil then
			return
		end

		local v13 = utf8.len(current.Text)

		if v13 then
			setSelectionStart(0)
			setCursorPosition(v13 + 1)
		end
	end, { setSelectionStart, setCursorPosition })

	local focus = React.useCallback(function()
		if ref.current == nil then
			return
		end

		ref.current:CaptureFocus()

		if v2.focusBehavior == InputFocusBehavior.Highlight then
			task.spawn(v13)
		end
	end, { v13, v2.focusBehavior })

	local releaseFocus = React.useCallback(function()
		if ref.current then
			ref.current:ReleaseFocus()
		end
	end, {})

	local getIsFocused = React.useCallback(function()
		if ref.current then
			return (ref.current:IsFocused())
		end

		return nil
	end, {})

	local getSelectionStart = React.useCallback(function()
		if ref.current then
			return ref.current.SelectionStart
		end

		return nil
	end, {})

	local getCursorPosition = React.useCallback(function()
		if ref.current then
			return ref.current.CursorPosition
		end

		return nil
	end, {})

	local onActivated = React.useCallback(function()
		if ref.current then
			ref.current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p2, function()
		return {
			getIsFocused = getIsFocused,
			focus = focus,
			releaseFocus = releaseFocus,
			getSelectionStart = getSelectionStart,
			getCursorPosition = getCursorPosition,
			setCursorPosition = setCursorPosition,
			setSelectionStart = setSelectionStart
		}
	end, {
		getCursorPosition,
		getIsFocused,
		getSelectionStart,
		focus,
		releaseFocus,
		setCursorPosition,
		setSelectionStart
	})

	local onTextChanged = React.useCallback(function(instance)
		if instance == nil or instance.Parent == nil or ref5.current ~= "" then
			return
		end

		local text = instance.Text

		if text == ref6.current then
			return
		end

		ref6.current = text

		if isMultiLine and ref3.current then
			ref3.current.Text = text
		end

		v2.onChanged(text)
	end, { v2.onChanged, isMultiLine, state2 })

	local ref9 = React.useRef(false)

	local onFocusGained = React.useCallback(function()
		if v2.isDisabled then
			return
		end

		if isMultiLine and v10 then
			if ref.current and ref.current.Parent then
				ref5.current = ref.current.Text
			end

			setState2(true)
		end

		v6(true)

		if v2.onFocus then
			v2.onFocus()
		end

		local focusBehavior = v2.focusBehavior

		if focusBehavior == InputFocusBehavior.Clear then
			ref5.current = ""

			if ref.current then
				ref.current.Text = ""
			end

			if ref2.current then
				ref2.current.Text = ""
			end
		elseif focusBehavior == InputFocusBehavior.Highlight then
			ref9.current = true
		end
	end, { v2.onFocus, v2.isDisabled, v10, isMultiLine, v2.focusBehavior })

	local onInputChanged = React.useCallback(function(_, p3)
		if p3.UserInputType == Enum.UserInputType.MouseMovement then
			ref9.current = false
		end
	end, {})

	local onInputEnded = React.useCallback(function(_, p3)
		if not ref9.current then
			return
		end

		ref9.current = false

		if p3.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v13()
	end, { setSelectionStart, setCursorPosition, v13 })

	local onFocusLost = React.useCallback(function(_, flag: boolean, p3)
		v6(false)
		ref9.current = false

		if isMultiLine then
			setState2(false)
		end

		if v2.onFocusLost then
			v2.onFocusLost(p3)
		end

		if flag and v2.onReturnPressed then
			v2.onReturnPressed()
		end
	end, { v2.onReturnPressed, isMultiLine, v2.onFocusLost })

	local v14 = React.useCallback(function(p3, current: Vector2)
		ref7.current = current

		if v2.onDragStarted then
			v2.onDragStarted(p3, current)
		end
	end, { v2.onDragStarted })

	local v15 = React.useCallback(function(p3, vector2: Vector2)
		if v2.onDrag then
			v2.onDrag(p3, vector2)
		end
	end, { v2.onDrag })

	local v16 = React.useCallback(function(p3, vector2: Vector2)
		if ref7.current == vector2 then
			focus()
		else
			releaseFocus()
			v6(false)
		end

		ref7.current = nil

		if v2.onDragEnded then
			v2.onDragEnded(p3, vector2)
		end
	end, { v2.onDragEnded })

	local cursor = React.useMemo(function()
		return {
			radius = UDim.new(0, container.radius),
			offset = v3.Stroke.Thick,
			borderWidth = v3.Stroke.Thick
		}
	end, { v3, container.radius })

	local v17 = React.useMemo(function()
		return getMultiLineTextHeight(fontSize, v4, lineHeight)
	end, { fontSize, v4, lineHeight })

	local padding, v18 = React.useMemo(function()
		local v18 = math.round((container.minHeight - v11 - getMultiLineTextHeight(fontSize, 1, lineHeight)) * 2) / 2

		local udim = UDim.new(0, (math.floor(v18 / 2)))
		local udim2 = UDim.new(0, (math.ceil(v18 / 2)))
		local v19 = v17 + math.round(v18) + v11

		return { top = udim, bottom = udim2, left = UDim.new(0, 0), right = UDim.new(0, 0) }, v19
	end, { container.minHeight, v11, v12, fontSize, v17, lineHeight })

	local padding2 = React.useMemo(function()
		local left

		if v2.horizontalPadding then
			left = v2.horizontalPadding.innerLeft
		end

		local right

		if v2.horizontalPadding then
			right = v2.horizontalPadding.innerRight
		end

		return { left = left, right = right }
	end, { v2.horizontalPadding })

	local v19 = padding.bottom.Offset + padding.top.Offset
	local udim = UDim2.new(1, 0, 0, v17 + v19)

	local layout = React.useMemo(function()
		if isMultiLine then
			return {
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Center
			}
		end

		return nil
	end, { isMultiLine })

	local scroll = React.useMemo(function()
		if isMultiLine then
			return {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always
			}
		end

		return nil
	end, { isMultiLine })

	local onCursorPositionChanged = React.useCallback(function(p3)
		local current = ref4.current
		local current2 = ref3.current

		if current == nil or current2 == nil then
			return
		end

		local v20 = p3.TextSize * p3.LineHeight
		local y = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p3)
		local y2 = current2.TextBounds.Y

		local v21 = y - padding.top.Offset + padding.bottom.Offset

		local v22 = y + current.AbsoluteSize.Y - padding.top.Offset - padding.bottom.Offset

		if y2 - v20 < v21 then
			current.CanvasPosition += Vector2.new(0, y2 - v20 - v21)
		end

		if v22 < y2 then
			current.CanvasPosition += Vector2.new(0, y2 - v22)
		end
	end, { padding })

	local scrollingFrameRef = React.useCallback(function(current)
		if current == nil then
			return
		end

		ref4.current = current
		current.ClipsDescendants = true
		current.CanvasPosition = ref8.current
	end, {})

	local v20 = React.useCallback(function(object)
		if object then
			object.Text = ref5.current
			ref5.current = ""
			task.delay(0, function()
				if object.Parent ~= nil then
					object:CaptureFocus()
				end
			end)
		end
	end, {})

	local onCanvasPositionChanged = React.useCallback(function(p3)
		ref8.current = p3.CanvasPosition
	end, {})

	local dragDetector = React.useMemo(function()
		if not (v2.onDragStarted or v2.onDrag or v2.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v14,
			[React.Event.DragContinue] = v15,
			[React.Event.DragEnd] = v16,
			Enabled = not (state or v2.isDisabled)
		})
	end, { v14, v15, v16, state, v2.isDisabled })
	local v21

	if v2.horizontalPadding then
		v21 = v2.horizontalPadding.left or UDim.new(0, 0)
	else
		v21 = UDim.new(0, 0)
	end

	local v22 = useBindable(v21)
	local v23

	if v2.horizontalPadding then
		v23 = v2.horizontalPadding.right or UDim.new(0, 0)
	else
		v23 = UDim.new(0, 0)
	end

	local v24 = useBindable(v23)

	local position = React.useMemo(function()
		if v2.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v3.Stroke.Standard) / 2))
		end

		return nil
	end, { v2.hasClearButton, container.minHeight, v3.Stroke.Standard })

	local ref10 = ReactUtils.useComposedRef(ref2, v20)

	local createElement = React.createElement

	local v25 = {
		ref = v2.inputRef,
		Size = UDim2.new(1, 0, 0, v18),
		selection = {
			Selectable = v2.Selectable and not v2.isDisabled,
			NextSelectionUp = v2.NextSelectionUp,
			NextSelectionDown = v2.NextSelectionDown,
			NextSelectionLeft = v2.NextSelectionLeft,
			NextSelectionRight = v2.NextSelectionRight
		},
		cursor = cursor,
		stroke = 0,
		cornerRadius = 0,
		padding = 0,
		onActivated = 0,
		isDisabled = 0,
		backgroundStyle = 0,
		stateLayer = 0,
		tag = 0,
		testId = 0
	}
	local stroke

	if container.strokeStyle and container.strokeThickness then
		stroke = {
			Color = container.strokeStyle.Color3,
			Transparency = 0,
			Thickness = 0,
			BorderStrokePosition = 0
		}
		local transparency

		if v2.isDisabled then
			transparency = blendTransparencies(container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY)
		else
			transparency = container.strokeStyle.Transparency
		end

		stroke.Transparency = transparency

		stroke.Thickness = container.strokeThickness
		local borderStrokePosition

		if state then
			borderStrokePosition = Enum.BorderStrokePosition.Center
		else
			borderStrokePosition = Enum.BorderStrokePosition.Inner
		end

		stroke.BorderStrokePosition = borderStrokePosition
	end

	v25.stroke = stroke
	local cornerRadius

	if v2.radius == Radius.Circle then
		cornerRadius = UDim.new(0, (math.ceil(container.minHeight / 2)))
	end

	v25.cornerRadius = cornerRadius

	local padding3 = {
		left = v22:map(function(p3)
			return UDim.new(0, standard) + p3
		end),
		right = 0,
		top = 0,
		bottom = 0
	}
	local right

	if v2.trailingElement == nil and v2.hasClearButton then
		right = UDim.new(0, standard)
	else
		right = v24:map(function(p3)
			return UDim.new(0, standard) + p3
		end)
	end

	padding3.right = right

	padding3.top = UDim.new(0, standard)
	padding3.bottom = UDim.new(0, standard)
	v25.padding = padding3
	local onActivated2

	if not v2.isDisabled then
		onActivated2 = focus
	end

	v25.onActivated = onActivated2
	v25.isDisabled = v2.isDisabled
	local backgroundStyle

	if Flags.FoundationFixColorOnScrubbableNumberInput and v2.backgroundGradient then
		backgroundStyle = getDisabledStyle({ Color3 = Color3.new(1, 1, 1), Transparency = 0.001 }, v2.isDisabled)
	elseif container.bgStyle then
		backgroundStyle = getDisabledStyle({
			Color3 = container.bgStyle.Color3,
			Transparency = not Flags.FoundationFixColorOnScrubbableNumberInput and v2.backgroundGradient and 0 or container.bgStyle.Transparency
		}, v2.isDisabled)
	end

	v25.backgroundStyle = backgroundStyle

	v25.stateLayer = { affordance = StateLayerAffordance.None }
	v25.tag = container.tag
	v25.testId = `{v2.testId}--outer-container`
	local v26 = withCommonProps(v2, v25)

	local v27 = {
		DragDetector = dragDetector,
		Background = v2.backgroundGradient,
		Leading = 0,
		TextBoxWrapper = 0,
		Clear = 0,
		Trailing = 0
	}
	local leading

	if v2.leadingElement then
		local createElement2 = React.createElement
		local groupTransparency

		if v2.isDisabled then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		leading = createElement2(
			View,
			{
				GroupTransparency = groupTransparency,
				LayoutOrder = 1,
				tag = "size-0-full auto-x",
				testId = `{v2.testId}--leading`
			},
			v2.leadingElement
		)
	end

	v27.Leading = leading

	local createElement2 = React.createElement
	local v28 = if isMultiLine then ScrollView else View

	if not isMultiLine then
		onCanvasPositionChanged = nil
	end

	if not isMultiLine then
		scrollingFrameRef = nil
	end

	local v29 = {
		LayoutOrder = 2,
		selection = { Selectable = false },
		scroll = scroll,
		layout = layout,
		onCanvasPositionChanged = onCanvasPositionChanged,
		scrollingFrameRef = scrollingFrameRef,
		padding = padding2,
		tag = "fill size-full clip",
		testId = `{v2.testId}--textbox-wrapper`
	}
	local textBox

	if not state2 then
		local createElement3 = React.createElement
		local v30 = {
			text = v2.text,
			placeholder = v2.placeholder,
			textInputType = v2.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = isMultiLine,
			isDisabled = v2.isDisabled,
			ref = ref,
			tag = `{v8 or ""} data-testid={v2.testId}--textbox`,
			Interactable = 0,
			Size = 0,
			automaticSize = 0,
			padding = 0,
			onFocusGained = 0,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0,
			onInputChanged = 0,
			onInputEnded = 0
		}
		local interactable2

		if dragDetector ~= nil then
			interactable2 = interactable
		end

		v30.Interactable = interactable2
		local size

		if isMultiLine then
			size = udim
		end

		v30.Size = size
		v30.automaticSize = mapBindable(v2.text, function(p3)
			if isMultiLine and not state2 and p3 ~= "" then
				return Enum.AutomaticSize.Y
			end

			return nil
		end)

		v30.padding = padding
		v30.onFocusGained = onFocusGained
		local onFocusLost2

		if not (isMultiLine and v10) then
			onFocusLost2 = onFocusLost
		end

		v30.onFocusLost = onFocusLost2
		v30.onTextChanged = onTextChanged
		local onCursorPositionChanged2

		if isMultiLine then
			onCursorPositionChanged2 = onCursorPositionChanged
		end

		v30.onCursorPositionChanged = onCursorPositionChanged2
		v30.onInputChanged = onInputChanged
		v30.onInputEnded = onInputEnded
		local boundsChecker

		if isMultiLine then
			boundsChecker = React.createElement(memo, {
				isBoundsChecker = true,
				fontStyle = fontStyle,
				textStyle = disabledStyle,
				Size = UDim2.new(1, 0, 1, v19),
				ref = ref3
			})
		end

		textBox = createElement3(memo, v30, { BoundsChecker = boundsChecker })
	end

	local mobileTextBox

	if isMultiLine and state2 then
		local createElement3 = React.createElement
		local v30 = {
			text = v2.text,
			placeholder = v2.placeholder,
			textInputType = v2.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = isMultiLine,
			isDisabled = v2.isDisabled,
			padding = padding,
			ref = ref10,
			tag = `{v8 or ""} data-testid={v2.testId}--mobile-textbox`,
			Interactable = 0,
			Size = 0,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0
		}

		if dragDetector == nil then
			interactable = nil
		end

		v30.Interactable = interactable
		v30.Size = udim

		if not (isMultiLine and v10) then
			onFocusLost = nil
		end

		v30.onFocusLost = onFocusLost
		v30.onTextChanged = onTextChanged

		if not isMultiLine then
			onCursorPositionChanged = nil
		end

		v30.onCursorPositionChanged = onCursorPositionChanged
		mobileTextBox = createElement3(memo, v30)
	end

	v27.TextBoxWrapper = createElement2(v28, v29, {
		TextBox = textBox,
		MobileTextBox = mobileTextBox
	})
	local clear

	if v2.hasClearButton then
		local createElement3 = React.createElement
		local v30 = {
			isDisabled = v2.isDisabled,
			GroupTransparency = 0,
			LayoutOrder = 3,
			Visible = 0,
			tag = 0
		}
		local groupTransparency

		if v2.isDisabled then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		v30.GroupTransparency = groupTransparency

		v30.Visible = mapBindable(v2.text, function(p3): boolean
			return p3 ~= ""
		end)

		v30.tag = v7.clearButton.tag
		clear = createElement3(View, v30, {
			ClearButton = React.createElement(View, {
				onActivated = onActivated,
				padding = UDim.new(0, v7.clearButton.padding),
				Position = position,
				stateLayer = { affordance = StateLayerAffordance.None },
				tag = "anchor-center-left auto-xy",
				testId = `{v2.testId}--clear-button`
			}, {
				Icon = React.createElement(Icon, { name = v7.clearButton.icon })
			})
		})
	end

	v27.Clear = clear
	local trailing

	if v2.trailingElement then
		local createElement3 = React.createElement
		local groupTransparency

		if v2.isDisabled then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		trailing = createElement3(
			View,
			{
				GroupTransparency = groupTransparency,
				LayoutOrder = 4,
				tag = "size-0-full auto-x",
				testId = `{v2.testId}--trailing`
			},
			v2.trailingElement
		)
	end

	v27.Trailing = trailing
	return createElement(View, v26, v27)
end

return React.memo(React.forwardRef(InternalTextInput))
