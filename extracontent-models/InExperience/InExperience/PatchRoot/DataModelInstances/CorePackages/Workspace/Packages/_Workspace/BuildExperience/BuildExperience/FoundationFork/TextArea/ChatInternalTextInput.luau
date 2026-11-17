local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local components = foundation.Components
local Icon = require(components.Icon)
local Padding = require(components.Padding)
local normalizeFontFace = require(foundation.Utility.normalizeFontFace)
local ScrollView = require(components.ScrollView)
require(components.Types)
local View = require(components.View)

local Constants = require(foundation.Constants)
local blendTransparencies = require(foundation.Utility.blendTransparencies)
local getBindableValue = require(foundation.Utility.getBindableValue)
local getDisabledStyle = require(foundation.Utility.getDisabledStyle)
local getMultiLineTextHeight = require(foundation.Utility.getMultiLineTextHeight)
local isPluginSecurity = require(foundation.Utility.isPluginSecurity)
local mapBindable = require(foundation.Utility.mapBindable)
local truncateTextToCursor = require(foundation.Components.InternalTextInput.truncateTextToCursor)
local chatTextAreaDebug = require(script.Parent.chatTextAreaDebug)
local measureTextLineCount = require(script.Parent.measureTextLineCount)
local useComposerFocusLock = require(script.Parent.useComposerFocusLock)
local useComposerKeyboardConnections = require(script.Parent.useComposerKeyboardConnections)

local useBindable = require(foundation.Utility.useBindable)
local usePreferredInput = require(foundation.Utility.usePreferredInput)
local useStyleTags = require(foundation.Providers.Style.useStyleTags)
local useTextInputVariants = require(components.TextInput.useTextInputVariants)
local useTokens = require(foundation.Providers.Style.useTokens)
local withCommonProps = require(foundation.Utility.withCommonProps)
local withDefaults = require(foundation.Utility.withDefaults)

local InputFocusBehavior = require(foundation.Enums.InputFocusBehavior)

local InputSize = require(foundation.Enums.InputSize)

local InputVariant = require(foundation.Enums.InputVariant)

local Radius = require(foundation.Enums.Radius)

local ControlState = require(foundation.Enums.ControlState)
local StateLayerAffordance = require(foundation.Enums.StateLayerAffordance)

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
	v2.PlaceholderText = props.placeholder
	local textInputType

	if isPluginSecurity() then
		textInputType = props.textInputType
	end

	v2.TextInputType = textInputType
	v2.ManualFocusRelease = props.manualFocusRelease and true or nil
	v2.ShouldEmitReturnEvents = props.shouldEmitReturnEvents and true or nil
	v2.OverlayNativeInput = props.overlayNativeInput and true or nil
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
		if typeof(props.text) == "string" then
		end

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
		p = table.clone(p)
		p.Selectable = true
	end

	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef("")
	local ref6 = React.useRef(getBindableValue(v2.text))

	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(Vector2.zero)
	local ref9 = React.useRef(false)
	local ref10 = React.useRef(0)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v4 = useTextInputVariants(v3, v2.size, v2.variant, v2.radius, state2, v2.hasError)
	local container = v4.container
	local v5

	if v2.leadingElement == nil then
		if v2.trailingElement ~= nil then
			v5 = v3.Gap.XSmall
		end
	else
		v5 = v3.Gap.Small
	end

	local tag

	if v5 == nil and v2.trailingElement and typeof(container.tag) == "string" then
		tag = string.gsub(container.tag, "gap%-large", "gap-xsmall")
	else
		tag = container.tag
	end

	local v6

	if state2 and v2.variant == InputVariant.Standard and not v2.hasError then
		v6 = v3.Color.Stroke.Default
	else
		v6 = container.strokeStyle
	end

	local v7 = useStyleTags(v4.textBox.tag)

	local isDisabled = v2.isDisabled
	local isDisabled2 = v2.isDisabled and v2.trailingElement == nil

	local v8 = usePreferredInput()
	local state3, setState3 = React.useState(false)
	local v9 = v8 == Enum.PreferredInput.Touch

	local standard = v3.Stroke.Standard
	local v10 = math.ceil(standard) * 2
	local v11 = math.ceil(v3.Stroke.Thick) * 2

	useComposerFocusLock(isDisabled == true, { ref, ref2 })

	local disabledStyle = getDisabledStyle(v3.Color.Content.Emphasis, isDisabled)
	local fontStyle = v4.textBox.fontStyle
	local fontSize = fontStyle.FontSize
	local lineHeight = fontStyle.LineHeight

	local multiLineTextHeight = getMultiLineTextHeight(fontSize, 1, lineHeight)
	local state4, setState4 = React.useState(1)
	local state5, setState5 = React.useState(multiLineTextHeight)
	local v12 = v2.maxLines ~= nil
	local state6, setState6 = React.useState(function()
		return getBindableValue(v2.text)
	end)

	React.useEffect(function()
		chatTextAreaDebug.setEnabled(v2.composerDebug == true)
		return function() end
	end, { v2.composerDebug })

	local v13 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current and current.AbsoluteSize.X > 0 then
			return current.AbsoluteSize.X
		end

		local current2 = ref4.current

		if current2 and current2.AbsoluteWindowSize.X > 0 then
			return current2.AbsoluteWindowSize.X
		end

		return 0
	end, {})

	local v14 = React.useCallback(function(text: string)
		local v14 = measureTextLineCount({
			text = text,
			maxLines = v2.maxLines,
			singleLineHeight = multiLineTextHeight,
			layoutWidth = v13(),
			font = normalizeFontFace(fontStyle.Font),
			fontSize = fontSize
		})
		local v15

		if v14.boundsY and v14.boundsY > 0 then
			v15 = math.ceil(v14.boundsY)
		else
			v15 = multiLineTextHeight
		end

		setState5((math.max(v15, v14.lineCount * multiLineTextHeight)))
		return v14.lineCount
	end, { fontSize, lineHeight, fontStyle.Font, v2.maxLines, v13, multiLineTextHeight })
	local text3

	if v12 then
		text3 = v2.text
	else
		text3 = getBindableValue(v2.text)
	end

	if not v2.maxLines then
		state4 = math.max(1, v2.numLines)
	end

	local isMultiLine = v2.alwaysMultiLine and true or state4 > 1

	React.useEffect(function()
		if not v12 then
			return function() end
		end

		local bindableValue = getBindableValue(v2.text)
		setState6(bindableValue)
		setState4(v14(bindableValue))
		task.defer(function()
			setState4(v14(bindableValue))
		end)

		if typeof(v2.text) == "table" and v2.text.getValue ~= nil then
			return React.__subscribeToBinding(v2.text, function(current: string)
				if current == ref6.current then
					return
				end

				chatTextAreaDebug.log("syncFromParent", `len={utf8.len(current) or #current}`)
				ref6.current = current
				setState6(current)
				setState4(v14(current))
				task.defer(function()
					setState4(v14(current))
				end)
			end)
		end

		return function() end
	end, { v2.text, v14, v12 })

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

	local v15 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current == nil or current.Parent == nil then
			return
		end

		local v15 = utf8.len(current.Text)

		if v15 then
			setSelectionStart(0)
			setCursorPosition(v15 + 1)
		end
	end, { setSelectionStart, setCursorPosition })

	local focus = React.useCallback(function()
		if ref.current == nil then
			return
		end

		ref.current:CaptureFocus()

		if v2.focusBehavior == InputFocusBehavior.Highlight then
			task.spawn(v15)
		end
	end, { v15, v2.focusBehavior })

	local releaseFocus = React.useCallback(function()
		if ref.current then
			ref.current:ReleaseFocus()
		end

		if ref2.current then
			ref2.current:ReleaseFocus()
		end

		setState3(false)
		setState2(false)
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
			setHover = setState,
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

		if ref9.current and text ~= "" or text == ref6.current then
			return
		end

		ref6.current = text

		if isMultiLine and ref3.current then
			ref3.current.Text = text
		end

		if v12 then
			setState6(text)
		end

		if v2.maxLines then
			setState4(v14(text))
			task.defer(function()
				setState4(v14(text))
			end)
		end

		v2.onChanged(text)
	end, { v2.onChanged, isMultiLine, state3, v2.maxLines, v14, v12 })

	local ref11 = React.useRef(false)

	local onInputChanged = React.useCallback(function(_, p3)
		if p3.UserInputType == Enum.UserInputType.MouseMovement then
			ref11.current = false
		end
	end, {})

	local v16 = React.useCallback(function(_, p3)
		if not ref11.current then
			return
		end

		ref11.current = false

		if p3.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v15()
	end, { setSelectionStart, setCursorPosition, v15 })

	local v17 = React.useCallback(function(current: string)
		ref6.current = current

		if v12 then
			setState6(current)
		end

		if v2.maxLines then
			setState4(v14(current))
		end

		v2.onChanged(current)
	end, { v2.maxLines, v14, v2.onChanged, v12 })
	local v18

	if v2.onReturnPressed == nil then
		v18 = false
	else
		v18 = not v9
	end

	local v19 = React.useCallback(function(_, p3: string)
		if v2.onReturnPressed == nil then
			return
		end

		local now = os.clock()

		if now - ref10.current < 0.15 then
			chatTextAreaDebug.log("returnSubmit", `source={p3} skipped=debounced`)
			return
		end

		chatTextAreaDebug.log("returnSubmit", `source={p3}`)
		ref10.current = now
		ref9.current = true
		v2.onReturnPressed()

		task.delay(0.15, function()
			ref9.current = false
		end)
	end, { v2.onReturnPressed })

	local onReturnPressed = React.useCallback(function(_: boolean, flag: boolean)
		local current = ref.current

		if current == nil or current:IsFocused() ~= true then
			return
		end

		if not flag then
			v19(current, "UserInputService.InputBegan")
			return
		end

		local text = current.Text
		task.defer(function()
			if current.Parent == nil then
				return
			end

			local text2 = current.Text

			if text2 ~= text then
				chatTextAreaDebug.log("returnNewline", "source=UserInputService.InputBegan-shift engineInserted=true")

				v17(text2)
			end
		end)
	end, { v19, v17 })

	local v20 = useComposerKeyboardConnections({
		enabled = v18 == true,
		onReturnPressed = onReturnPressed
	})

	local connect = v20.connect
	local disconnect = v20.disconnect

	local onFocusGained = React.useCallback(function()
		if isDisabled then
			return
		end

		if isMultiLine and v9 then
			if ref.current and ref.current.Parent then
				ref5.current = ref.current.Text
			end

			setState3(true)
		end

		setState2(true)

		if v2.onFocus then
			v2.onFocus()
		end

		if v18 then
			connect()
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
			ref11.current = true
		end
	end, { v2.onFocus, isDisabled, v9, isMultiLine, v2.focusBehavior, v18, connect })

	local onInputEnded = React.useCallback(function(p3, p4)
		v16(p3, p4)
	end, { v16 })

	local onFocusLost = React.useCallback(function(p3, flag: boolean, p4)
		chatTextAreaDebug.log("textBox.FocusLost", `enterPressed={flag}`)

		if v18 then
			disconnect()
		end

		setState2(false)
		ref11.current = false

		if isMultiLine then
			setState3(false)
		end

		if v2.onFocusLost then
			v2.onFocusLost(p4)
		end

		if flag and v18 then
			v19(p3, "TextBox.FocusLost")
		end
	end, { isMultiLine, v2.onFocusLost, v18, v19, disconnect })

	local onStateChanged = React.useCallback(function(p3)
		setState(p3 == ControlState.Hover)
	end, {})

	local v21 = React.useCallback(function(p3, current: Vector2)
		ref7.current = current

		if v2.onDragStarted then
			v2.onDragStarted(p3, current)
		end
	end, { v2.onDragStarted })

	local v22 = React.useCallback(function(p3, vector2: Vector2)
		if v2.onDrag then
			v2.onDrag(p3, vector2)
		end
	end, { v2.onDrag })

	local v23 = React.useCallback(function(p3, vector2: Vector2)
		if ref7.current == vector2 then
			focus()
		else
			releaseFocus()
			setState2(false)
		end

		ref7.current = nil

		if v2.onDragEnded then
			v2.onDragEnded(p3, vector2)
		end
	end, { v2.onDragEnded, focus, releaseFocus })
	local v24

	if v2.maxLines then
		v24 = getMultiLineTextHeight(fontSize, v2.maxLines, lineHeight)
	else
		v24 = nil
	end

	local v25 = React.useMemo(function()
		if v2.maxLines then
			return (math.clamp(math.max(multiLineTextHeight, state5), multiLineTextHeight, v24))
		end

		return getMultiLineTextHeight(fontSize, state4, lineHeight)
	end, { v2.maxLines, multiLineTextHeight, state5, v24, fontSize, state4, lineHeight })

	local v26 = React.useMemo(function()
		local multiLineTextHeight2 = getMultiLineTextHeight(fontSize, 1, lineHeight)
		local v26 = multiLineTextHeight2 + math.round(math.round((container.minHeight - v10 - multiLineTextHeight2) * 2) / 2) + v10
		return UDim.new(0, (math.ceil(v26 / 2)))
	end, { container.minHeight, v10, fontSize, lineHeight })

	local cornerRadius = React.useMemo(function()
		if v2.maxLines then
			return v26
		end

		if v2.radius == Radius.Circle then
			return UDim.new(0, (math.ceil(container.minHeight / 2)))
		end

		return nil
	end, { v2.maxLines, v26, container.minHeight, v2.radius })

	local cursor = React.useMemo(function()
		local radius

		if cornerRadius then
			radius = cornerRadius
		else
			radius = UDim.new(0, container.radius)
		end

		return { radius = radius, offset = v3.Stroke.Thick, borderWidth = v3.Stroke.Thick }
	end, { v3, container.radius, cornerRadius })

	local v27, v28 = React.useMemo(function()
		local v27 = math.round((container.minHeight - v10 - getMultiLineTextHeight(fontSize, 1, lineHeight)) * 2) / 2

		local udim = UDim.new(0, (math.floor(v27 / 2)))
		local udim2 = UDim.new(0, (math.ceil(v27 / 2)))
		local v28 = v25 + math.round(v27) + v10

		return { top = udim, bottom = udim2, left = UDim.new(0, 0), right = UDim.new(0, 0) }, v28
	end, { container.minHeight, v10, v11, fontSize, v25, lineHeight })

	local v29 = v27.bottom.Offset + v27.top.Offset
	local textPaddingOnParent = v2.textPaddingOnParent == true
	local padding

	if not textPaddingOnParent then
		padding = v27
	end

	local v30

	if textPaddingOnParent then
		v30 = v25
	else
		v30 = v25 + v29
	end

	local v31

	if isMultiLine then
		if v2.maxLines == nil then
			v31 = false
		else
			v31 = not state3
		end
	else
		v31 = isMultiLine
	end

	local v32

	if textPaddingOnParent then
		v32 = state5
	else
		v32 = state5 + v29
	end

	local v55

	if v31 then
		v55 = math.max(v30, v32)
	else
		v55 = v30
	end

	local v56

	if textPaddingOnParent then
		v56 = v55 + v29
	else
		v56 = v55
	end

	local udim = UDim2.new(1, 0, 0, v55)
	local udim2 = UDim2.new(1, 0, 0, v30)

	React.useEffect(function()
		if v2.maxLines then
			chatTextAreaDebug.log("layout", `lineCount={state4} borderFrameHeight={v28}`)
		end

		return function() end
	end, { state4, v28, v2.maxLines })

	local layout = React.useMemo(function()
		if not isMultiLine then
			return nil
		end

		local v58 = { FillDirection = Enum.FillDirection.Vertical, ItemLineAlignment = 0 }
		local itemLineAlignment

		if v2.maxLines == nil then
			itemLineAlignment = Enum.ItemLineAlignment.Center
		else
			itemLineAlignment = Enum.ItemLineAlignment.Start
		end

		v58.ItemLineAlignment = itemLineAlignment
		return v58
	end, { isMultiLine, v2.maxLines })

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

		local v60 = p3.TextSize * p3.LineHeight
		local y = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p3)
		local y2 = current2.TextBounds.Y

		local v61 = y - v27.top.Offset + v27.bottom.Offset

		local v62 = y + current.AbsoluteSize.Y - v27.top.Offset - v27.bottom.Offset

		if y2 - v60 < v61 then
			current.CanvasPosition += Vector2.new(0, y2 - v60 - v61)
		end

		if v62 < y2 then
			current.CanvasPosition += Vector2.new(0, y2 - v62)
		end
	end, { v27 })

	local scrollingFrameRef = React.useCallback(function(current)
		if current == nil then
			return
		end

		ref4.current = current
		current.ClipsDescendants = true
		current.CanvasPosition = ref8.current
	end, {})

	local v61 = React.useCallback(function(object)
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
			[React.Event.DragStart] = v21,
			[React.Event.DragContinue] = v22,
			[React.Event.DragEnd] = v23,
			Enabled = not (state2 or isDisabled)
		})
	end, { v21, v22, v23, state2, isDisabled, v2.onDragStarted, v2.onDrag, v2.onDragEnded })
	local v64

	if v2.horizontalPadding then
		v64 = v2.horizontalPadding.left or UDim.new(0, 0)
	else
		v64 = UDim.new(0, 0)
	end

	local v65 = useBindable(v64)
	local v66

	if v2.horizontalPadding then
		v66 = v2.horizontalPadding.right or UDim.new(0, 0)
	else
		v66 = UDim.new(0, 0)
	end

	local v67 = useBindable(v66)

	local position = React.useMemo(function()
		if v2.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v3.Stroke.Standard) / 2))
		end

		return nil
	end, { v2.hasClearButton, container.minHeight, v3.Stroke.Standard })

	local ref12 = ReactUtils.useComposedRef(ref2, v61)

	local createElement = React.createElement

	local v70 = {
		Size = UDim2.new(1, 0, 0, v28),
		selection = {
			Selectable = v2.Selectable and not isDisabled,
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
		onStateChanged = 0,
		isDisabled = 0,
		backgroundStyle = 0,
		stateLayer = 0,
		layout = 0,
		tag = 0,
		testId = 0
	}
	local stroke

	if v6 and container.strokeThickness then
		stroke = { Color = v6.Color3, Transparency = 0, Thickness = 0, BorderStrokePosition = 0 }
		local transparency

		if isDisabled then
			transparency = blendTransparencies(v6.Transparency, Constants.DISABLED_TRANSPARENCY)
		else
			transparency = v6.Transparency
		end

		stroke.Transparency = transparency

		stroke.Thickness = container.strokeThickness
		local borderStrokePosition

		if state2 or state then
			borderStrokePosition = Enum.BorderStrokePosition.Center
		else
			borderStrokePosition = Enum.BorderStrokePosition.Inner
		end

		stroke.BorderStrokePosition = borderStrokePosition
	end

	v70.stroke = stroke

	v70.cornerRadius = cornerRadius
	local padding2 = {
		left = v65:map(function(p3)
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
		right = v67:map(function(p3)
			return UDim.new(0, standard) + p3
		end)
	end

	padding2.right = right

	padding2.top = UDim.new(0, standard)
	padding2.bottom = UDim.new(0, standard)
	v70.padding = padding2
	local onActivated2

	if not isDisabled then
		onActivated2 = focus
	end

	v70.onActivated = onActivated2
	v70.onStateChanged = onStateChanged
	v70.isDisabled = isDisabled2
	local backgroundStyle

	if container.bgStyle then
		backgroundStyle = getDisabledStyle({
			Color3 = container.bgStyle.Color3,
			Transparency = v2.backgroundGradient and 0 or container.bgStyle.Transparency
		}, isDisabled2)
	end

	v70.backgroundStyle = backgroundStyle

	v70.stateLayer = { affordance = StateLayerAffordance.None }
	v70.layout = v5 ~= nil
		and {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v5),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
		or nil

	v70.tag = tag
	v70.testId = `{v2.testId}--outer-container`
	local v76 = withCommonProps(v2, v70)

	local v77 = {
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

		if isDisabled2 then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		leading = createElement2(
			View,
			{
				GroupTransparency = groupTransparency,
				LayoutOrder = 1,
				tag = "col align-y-bottom self-stretch size-0-full auto-x",
				testId = `{v2.testId}--leading`
			},
			v2.leadingElement
		)
	end

	v77.Leading = leading

	local createElement2 = React.createElement
	local v79 = if isMultiLine then ScrollView else View

	if not isMultiLine then
		onCanvasPositionChanged = nil
	end

	if not isMultiLine then
		scrollingFrameRef = nil
	end

	local createElement3 = React.createElement
	local size

	if v31 then
		size = UDim2.new(1, 0, 0, v56)
	end

	local v82 = {
		Size = size,
		tag = {
			["fill size-full"] = not v31
		},
		padding = 0,
		selection = 0,
		onActivated = 0,
		stateLayer = 0
	}
	local padding3

	if textPaddingOnParent then
		padding3 = v27
	end

	v82.padding = padding3
	v82.selection = { Selectable = false }
	local onActivated3

	if not isDisabled then
		onActivated3 = focus
	end

	v82.onActivated = onActivated3
	v82.stateLayer = { affordance = StateLayerAffordance.None }
	local textBox

	if not state3 then
		local createElement4 = React.createElement
		local v88 = {
			text = text3,
			placeholder = v2.placeholder,
			textInputType = v2.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = isMultiLine,
			isDisabled = isDisabled,
			ref = ref,
			tag = `{v7 or ""} data-testid={v2.testId}--textbox`,
			Size = 0,
			automaticSize = 0,
			padding = 0,
			onFocusGained = 0,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0,
			onInputChanged = 0,
			onInputEnded = 0,
			manualFocusRelease = 0,
			shouldEmitReturnEvents = 0,
			overlayNativeInput = nil
		}

		if not isMultiLine then
			udim = nil
		end

		v88.Size = udim
		local automaticSize

		if not v2.maxLines then
			if v12 then
				if isMultiLine and not state3 and state6 ~= "" then
					automaticSize = Enum.AutomaticSize.Y
				end
			else
				automaticSize = mapBindable(v2.text, function(p3)
					if isMultiLine and not state3 and p3 ~= "" then
						return Enum.AutomaticSize.Y
					end

					return nil
				end)
			end
		end

		v88.automaticSize = automaticSize

		v88.padding = padding
		v88.onFocusGained = onFocusGained
		local onFocusLost2

		if not (isMultiLine and v9) then
			onFocusLost2 = onFocusLost
		end

		v88.onFocusLost = onFocusLost2
		v88.onTextChanged = onTextChanged
		local onCursorPositionChanged2

		if isMultiLine then
			onCursorPositionChanged2 = onCursorPositionChanged
		end

		v88.onCursorPositionChanged = onCursorPositionChanged2
		v88.onInputChanged = onInputChanged
		v88.onInputEnded = onInputEnded
		local manualFocusRelease

		if v9 then
			manualFocusRelease = v2.manualFocusRelease
		end

		v88.manualFocusRelease = manualFocusRelease
		v88.shouldEmitReturnEvents = v9 and v2.manualFocusRelease == true and v2.alwaysMultiLine == true and true or nil
		local boundsChecker

		if isMultiLine then
			local createElement5 = React.createElement
			local v95 = {
				isBoundsChecker = true,
				fontStyle = fontStyle,
				textStyle = disabledStyle,
				Size = 0,
				ref = 0
			}
			local size2

			if textPaddingOnParent then
				size2 = UDim2.fromScale(1, 1)
			else
				size2 = UDim2.new(1, 0, 1, v29)
			end

			v95.Size = size2

			v95.ref = ref3
			boundsChecker = createElement5(memo, v95)
		end

		textBox = createElement4(memo, v88, {
			DragDetector = dragDetector,
			BoundsChecker = boundsChecker
		})
	end

	local mobileTextBox

	if isMultiLine and state3 then
		local createElement4 = React.createElement
		local v89 = {
			text = text3,
			placeholder = v2.placeholder,
			textInputType = v2.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = isMultiLine,
			isDisabled = isDisabled,
			padding = padding,
			ref = ref12,
			tag = `{v7 or ""} data-testid={v2.testId}--mobile-textbox`,
			Size = udim2,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0,
			onInputEnded = 0,
			manualFocusRelease = 0,
			shouldEmitReturnEvents = 0,
			overlayNativeInput = nil
		}

		if not (isMultiLine and v9) then
			onFocusLost = nil
		end

		v89.onFocusLost = onFocusLost
		v89.onTextChanged = onTextChanged

		if not isMultiLine then
			onCursorPositionChanged = nil
		end

		v89.onCursorPositionChanged = onCursorPositionChanged
		v89.onInputEnded = onInputEnded
		local manualFocusRelease

		if v9 then
			manualFocusRelease = v2.manualFocusRelease
		end

		v89.manualFocusRelease = manualFocusRelease
		v89.shouldEmitReturnEvents = v9 and v2.manualFocusRelease == true and v2.alwaysMultiLine == true and true or nil
		mobileTextBox = createElement4(memo, v89)
	end

	v77.TextBoxWrapper = createElement2(v79, {
		LayoutOrder = 2,
		selection = { Selectable = false },
		scroll = scroll,
		layout = layout,
		onCanvasPositionChanged = onCanvasPositionChanged,
		scrollingFrameRef = scrollingFrameRef,
		tag = "fill size-full clip"
	}, {
		TextContent = createElement3(View, v82, { TextBox = textBox, MobileTextBox = mobileTextBox })
	})
	local clear

	if v2.hasClearButton then
		local createElement4 = React.createElement
		local v90 = {
			isDisabled = isDisabled,
			GroupTransparency = 0,
			LayoutOrder = 3,
			Visible = 0,
			tag = 0
		}
		local groupTransparency

		if isDisabled then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		v90.GroupTransparency = groupTransparency

		v90.Visible = mapBindable(v2.text, function(p3): boolean
			return p3 ~= ""
		end)

		v90.tag = v4.clearButton.tag
		clear = createElement4(View, v90, {
			ClearButton = React.createElement(View, {
				onActivated = onActivated,
				padding = UDim.new(0, v4.clearButton.padding),
				Position = position,
				stateLayer = { affordance = StateLayerAffordance.None },
				tag = "anchor-center-left auto-xy",
				testId = `{v2.testId}--clear-button`
			}, {
				Icon = React.createElement(Icon, { name = v4.clearButton.icon })
			})
		})
	end

	v77.Clear = clear
	local trailing

	if v2.trailingElement then
		local createElement4 = React.createElement
		local groupTransparency

		if isDisabled2 then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		trailing = createElement4(View, {
			GroupTransparency = groupTransparency,
			LayoutOrder = 4,
			tag = {
				["col align-y-bottom self-stretch size-0-full auto-x"] = v2.trailingAlignBottom == true,
				["row align-y-center size-0-full auto-x"] = v2.trailingAlignBottom ~= true
			},
			testId = `{v2.testId}--trailing`
		}, v2.trailingElement)
	end

	v77.Trailing = trailing
	return createElement(View, v76, v77)
end

return React.memo(React.forwardRef(InternalTextInput))
