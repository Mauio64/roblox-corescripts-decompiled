local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local parent2 = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local SharedFlags = require(parent2.SharedFlags)
local FFlagComposerFooter = SharedFlags.FFlagComposerFooter
local defineFastFlag = game:DefineFastFlag("ComposerMultiLineCaretFix", false)
local defineFastFlag2 = game:DefineFastFlag("ComposerDraftTextBindingSync", false)
local Foundation = require(parent2.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
local composerDebug = require(script.Parent.composerDebug)
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
	local font

	if not FoundationFontFaceMigration then
		font = props.fontStyle.Font
	end

	v2.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(props.fontStyle.Font)
	end

	v2.FontFace = fontFace
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
	v2[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
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
	local v4 = FFlagComposerFooter and v2.footerElement ~= nil
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

	local v5 = useTextInputVariants(v3, v2.size, v2.variant, v2.radius, state2, v2.hasError)
	local container = v5.container
	local v6

	if v2.leadingElement == nil then
		if v2.trailingElement ~= nil then
			v6 = v3.Gap.XSmall
		end
	else
		v6 = v3.Gap.Small
	end

	local tag

	if v6 == nil and v2.trailingElement and typeof(container.tag) == "string" then
		tag = string.gsub(container.tag, "gap%-large", "gap-xsmall")
	else
		tag = container.tag
	end

	local v7

	if state2 and v2.variant == InputVariant.Standard and not v2.hasError then
		v7 = v3.Color.Stroke.Default
	else
		v7 = container.strokeStyle
	end

	local v8 = useStyleTags(v5.textBox.tag)

	local isDisabled = v2.isDisabled
	local ref11 = React.useRef(isDisabled)
	ref11.current = isDisabled
	local isDisabled2 = v2.isDisabled

	if isDisabled2 then
		if v2.trailingElement == nil then
			isDisabled2 = not v4
		else
			isDisabled2 = false
		end
	end

	local v9 = usePreferredInput()
	local state3, setState3 = React.useState(false)
	local v10 = v9 == Enum.PreferredInput.Touch
	React.useEffect(function()
		if isDisabled then
			setState3(false)
			setState2(false)
		end

		return function() end
	end, { isDisabled })

	local standard = v3.Stroke.Standard
	local v11 = math.ceil(standard) * 2
	local v12 = math.ceil(v3.Stroke.Thick) * 2

	useComposerFocusLock(isDisabled == true, { ref, ref2 })

	local disabledStyle = getDisabledStyle(v3.Color.Content.Emphasis, isDisabled)
	local fontStyle = v5.textBox.fontStyle
	local fontSize = fontStyle.FontSize
	local lineHeight = fontStyle.LineHeight

	local multiLineTextHeight = getMultiLineTextHeight(fontSize, 1, lineHeight)
	local state4, setState4 = React.useState(1)
	local state5, setState5 = React.useState(multiLineTextHeight)
	local v13 = v2.maxLines ~= nil
	local state6, setState6 = React.useState(function()
		return getBindableValue(v2.text)
	end)

	React.useEffect(function()
		composerDebug.setEnabled(v2.composerDebug == true)
		return function() end
	end, { v2.composerDebug })

	local v14 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current and current.AbsoluteSize.X > 0 then
			return current.AbsoluteSize.X
		end

		return 0
	end, {})

	local v15 = React.useCallback(function(text: string)
		local v15 = {
			text = text,
			maxLines = v2.maxLines,
			singleLineHeight = multiLineTextHeight,
			layoutWidth = v14(),
			font = 0,
			fontSize = 0
		}
		local font

		if FoundationFontFaceMigration then
			font = normalizeFontFace(fontStyle.Font)
		else
			font = fontStyle.Font
		end

		v15.font = font

		v15.fontSize = fontSize
		local v16 = measureTextLineCount(v15)

		if defineFastFlag then
			setState5(getMultiLineTextHeight(fontSize, v16.unclampedLineCount, lineHeight))
		else
			local v17

			if v16.boundsY and v16.boundsY > 0 then
				v17 = math.ceil(v16.boundsY)
			else
				v17 = multiLineTextHeight
			end

			setState5((math.max(v17, v16.lineCount * multiLineTextHeight)))
		end

		return v16.lineCount
	end, { fontSize, lineHeight, fontStyle.Font, v2.maxLines, v14, multiLineTextHeight })
	local text3

	if v13 then
		text3 = v2.text
	else
		text3 = getBindableValue(v2.text)
	end

	local v16 = math.max(1, (math.floor(v2.minLines or 1)))

	if v2.maxLines then
		v16 = math.min(v16, v2.maxLines)
	end

	local v17

	if v2.maxLines then
		v17 = math.max(v16, state4)
	else
		v17 = math.max(v16, v2.numLines)
	end

	local isMultiLine = v2.alwaysMultiLine and true or v17 > 1

	React.useEffect(function()
		if not v13 then
			return function() end
		end

		local bindableValue = getBindableValue(v2.text)

		if bindableValue ~= ref6.current then
			composerDebug.log("syncFromParent", `len={utf8.len(bindableValue) or #bindableValue}`)
			ref6.current = bindableValue
			setState6(bindableValue)
			setState4(v15(bindableValue))
			task.defer(function()
				setState4(v15(bindableValue))
			end)
		end

		return function() end
	end, { v2.text, v15, v13 })

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

	local v18 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current == nil or current.Parent == nil then
			return
		end

		local v18 = utf8.len(current.Text)

		if v18 then
			setSelectionStart(0)
			setCursorPosition(v18 + 1)
		end
	end, { setSelectionStart, setCursorPosition })

	local v19 = React.useCallback(function()
		if isMultiLine and v10 and not state3 then
			if ref.current and ref.current.Parent then
				ref5.current = ref.current.Text
			end

			setState3(true)
		else
			local current = ref.current or ref2.current

			if current == nil then
				return
			end

			current:CaptureFocus()

			if v2.focusBehavior == InputFocusBehavior.Highlight then
				task.spawn(v18)
			end
		end
	end, { v18, v2.focusBehavior, isMultiLine, v10, state3 })

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
		local current = ref.current or ref2.current

		if current then
			return (current:IsFocused())
		end

		return nil
	end, {})

	local getSelectionStart = React.useCallback(function()
		local current = ref.current or ref2.current

		return if current then current.SelectionStart else nil
	end, {})

	local getCursorPosition = React.useCallback(function()
		local current = ref.current or ref2.current

		return if current then current.CursorPosition else nil
	end, {})

	local onActivated = React.useCallback(function()
		local current = ref.current or ref2.current

		if current then
			current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p2, function()
		return {
			getIsFocused = getIsFocused,
			focus = v19,
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
		v19,
		releaseFocus,
		setCursorPosition,
		setSelectionStart
	})

	local onTextChanged = React.useCallback(function(instance)
		if instance == nil or instance.Parent == nil or ref5.current ~= "" then
			return
		end

		if ref11.current then
			local text = instance.Text

			if defineFastFlag2 and v13 and text ~= "" and text ~= ref6.current then
				ref6.current = text
				setState6(text)
				setState4(v15(text))
			end
		else
			local text = instance.Text

			if ref9.current and text ~= "" or text == ref6.current then
				return
			end

			ref6.current = text

			if isMultiLine and ref3.current then
				ref3.current.Text = text
			end

			if v13 then
				setState6(text)
			end

			if v2.maxLines then
				setState4(v15(text))
				task.defer(function()
					setState4(v15(text))
				end)
			end

			v2.onChanged(text)
		end
	end, { v2.onChanged, isMultiLine, v2.maxLines, v15, v13 })

	local ref12 = React.useRef(false)

	local onInputChanged = React.useCallback(function(_, p3)
		if p3.UserInputType == Enum.UserInputType.MouseMovement then
			ref12.current = false
		end
	end, {})

	local v20 = React.useCallback(function(_, p3)
		if not ref12.current then
			return
		end

		ref12.current = false

		if p3.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v18()
	end, { setSelectionStart, setCursorPosition, v18 })

	local v21 = React.useCallback(function(current: string)
		ref6.current = current

		if v13 then
			setState6(current)
		end

		if v2.maxLines then
			setState4(v15(current))
		end

		v2.onChanged(current)
	end, { v2.maxLines, v15, v2.onChanged, v13 })
	local v22

	if v2.onReturnPressed == nil then
		v22 = false
	else
		v22 = not v10
	end

	local v23 = React.useCallback(function(_, p3: string)
		if v2.onReturnPressed == nil then
			return
		end

		local now = os.clock()

		if now - ref10.current < 0.15 then
			composerDebug.log("returnSubmit", `source={p3} skipped=debounced`)
			return
		end

		composerDebug.log("returnSubmit", `source={p3}`)
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
			v23(current, "UserInputService.InputBegan")
			return
		end

		local text = current.Text
		task.defer(function()
			if current.Parent == nil then
				return
			end

			local text2 = current.Text

			if text2 ~= text then
				composerDebug.log("returnNewline", "source=UserInputService.InputBegan-shift engineInserted=true")
				v21(text2)
			end
		end)
	end, { v23, v21 })

	local v24 = useComposerKeyboardConnections({
		enabled = v22 == true,
		onReturnPressed = onReturnPressed
	})

	local connect = v24.connect
	local disconnect = v24.disconnect

	local onFocusGained = React.useCallback(function()
		if isDisabled then
			return
		end

		setState2(true)

		if v2.onFocus then
			v2.onFocus()
		end

		if v22 then
			connect()
		end

		local focusBehavior = v2.focusBehavior

		if focusBehavior == InputFocusBehavior.Clear then
			if ref.current then
				ref.current.Text = ""
			end

			if ref2.current then
				ref2.current.Text = ""
			end
		elseif focusBehavior == InputFocusBehavior.Highlight then
			ref12.current = true
		end
	end, { v2.onFocus, isDisabled, v2.focusBehavior, v22, connect })

	local onInputEnded = React.useCallback(function(p3, p4)
		v20(p3, p4)
	end, { v20 })

	local onFocusLost = React.useCallback(function(p3, flag: boolean, p4)
		composerDebug.log("textBox.FocusLost", `enterPressed={flag}`)

		if v22 then
			disconnect()
		end

		setState2(false)
		ref12.current = false

		if isMultiLine then
			setState3(false)
		end

		if v2.onFocusLost then
			v2.onFocusLost(p4)
		end

		if flag and v22 then
			v23(p3, "TextBox.FocusLost")
		end
	end, { isMultiLine, v2.onFocusLost, v22, v23, disconnect })

	local onStateChanged = React.useCallback(function(p3)
		setState(p3 == ControlState.Hover)
	end, {})

	local v25 = React.useCallback(function(p3, current: Vector2)
		ref7.current = current

		if v2.onDragStarted then
			v2.onDragStarted(p3, current)
		end
	end, { v2.onDragStarted })

	local v26 = React.useCallback(function(p3, vector2: Vector2)
		if v2.onDrag then
			v2.onDrag(p3, vector2)
		end
	end, { v2.onDrag })

	local v27 = React.useCallback(function(p3, vector2: Vector2)
		if ref7.current == vector2 then
			v19()
		else
			releaseFocus()
			setState2(false)
		end

		ref7.current = nil

		if v2.onDragEnded then
			v2.onDragEnded(p3, vector2)
		end
	end, { v2.onDragEnded, v19, releaseFocus })
	local v28

	if v2.maxLines then
		v28 = getMultiLineTextHeight(fontSize, v2.maxLines, lineHeight)
	else
		v28 = nil
	end

	local multiLineTextHeight2 = getMultiLineTextHeight(fontSize, v16, lineHeight)
	local v29 = React.useMemo(function()
		if v2.maxLines then
			return (math.clamp(math.max(multiLineTextHeight2, state5), multiLineTextHeight2, v28))
		end

		return getMultiLineTextHeight(fontSize, v17, lineHeight)
	end, { v2.maxLines, multiLineTextHeight2, state5, v28, fontSize, v17, lineHeight })

	local v30 = React.useMemo(function()
		local multiLineTextHeight3 = getMultiLineTextHeight(fontSize, 1, lineHeight)
		local v30 = multiLineTextHeight3 + math.round(math.round((container.minHeight - v11 - multiLineTextHeight3) * 2) / 2) + v11
		return UDim.new(0, (math.ceil(v30 / 2)))
	end, { container.minHeight, v11, fontSize, lineHeight })

	local v31 = React.useMemo(function()
		if v2.maxLines then
			return v30
		end

		if v2.radius == Radius.Circle then
			return UDim.new(0, (math.ceil(container.minHeight / 2)))
		end

		return nil
	end, { v2.maxLines, v30, container.minHeight, v2.radius })

	local cursor = React.useMemo(function()
		local radius

		if v31 then
			radius = v31
		else
			radius = UDim.new(0, container.radius)
		end

		return { radius = radius, offset = v3.Stroke.Thick, borderWidth = v3.Stroke.Thick }
	end, { v3, container.radius, v31 })

	local useMemo = React.useMemo
	local function fn()
		local v32 = math.round((container.minHeight - v11 - getMultiLineTextHeight(fontSize, 1, lineHeight)) * 2) / 2

		local udim = UDim.new(0, (math.floor(v32 / 2)))
		local udim2 = UDim.new(0, (math.ceil(v32 / 2)))

		if FFlagComposerFooter and v4 then
			local v53 = math.min(v3.Size.Size_100, udim2.Offset)
			udim += UDim.new(0, v53)
			udim2 -= UDim.new(0, v53)
		end

		local v53 = v29 + math.round(v32)
		local v54 = v53 + v11

		return { top = udim, bottom = udim2, left = UDim.new(0, 0), right = UDim.new(0, 0) }, v54, v53
	end

	local minHeight = container.minHeight
	local v32

	if FFlagComposerFooter then
		v32 = v4
	end

	local v54

	if FFlagComposerFooter then
		v54 = v3
	end

	local v55, v56, v57 = useMemo(fn, { minHeight, v11, v12, fontSize, v29, lineHeight, v32, v54 })

	local v58 = v55.bottom.Offset + v55.top.Offset
	local v59

	if isMultiLine then
		if v2.maxLines == nil then
			v59 = false
		else
			v59 = not state3
		end
	else
		v59 = isMultiLine
	end

	local textPaddingOnParent = v2.textPaddingOnParent == true
	local v60 = textPaddingOnParent and v59
	local v61 = textPaddingOnParent and not v60
	local padding

	if not textPaddingOnParent then
		padding = v55
	end

	local v63

	if textPaddingOnParent then
		v63 = v29
	else
		v63 = v29 + v58
	end

	local v64

	if textPaddingOnParent then
		v64 = state5
	else
		v64 = state5 + v58
	end

	local v65

	if v59 then
		v65 = math.max(v63, v64)
	else
		v65 = v63
	end

	local v66

	if v61 then
		v66 = v65 + v58
	else
		v66 = v65
	end

	local udim = UDim2.new(1, 0, 0, v65)
	local udim2 = UDim2.new(1, 0, 0, v63)

	React.useEffect(function()
		if v2.maxLines then
			composerDebug.log("layout", `lineCount={v17} borderFrameHeight={v56}`)
		end

		return function() end
	end, { v17, v56, v2.maxLines })

	local layout = React.useMemo(function()
		if not isMultiLine then
			return nil
		end

		local v68 = { FillDirection = Enum.FillDirection.Vertical, ItemLineAlignment = 0 }
		local itemLineAlignment

		if v2.maxLines == nil then
			itemLineAlignment = Enum.ItemLineAlignment.Center
		else
			itemLineAlignment = Enum.ItemLineAlignment.Start
		end

		v68.ItemLineAlignment = itemLineAlignment
		return v68
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

	local v69 = React.useCallback(function(p3)
		local current = ref4.current
		local current2 = ref3.current

		if current == nil or current2 == nil then
			return
		end

		local v70 = p3.TextSize * p3.LineHeight
		local y = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p3)
		local y2 = current2.TextBounds.Y

		local v71 = y - v55.top.Offset + v55.bottom.Offset

		local v72 = y + current.AbsoluteSize.Y - v55.top.Offset - v55.bottom.Offset

		if y2 - v70 < v71 then
			current.CanvasPosition += Vector2.new(0, y2 - v70 - v71)
		end

		if v72 < y2 then
			current.CanvasPosition += Vector2.new(0, y2 - v72)
		end
	end, { v55 })
	local onAbsoluteSizeChanged

	if defineFastFlag then
		onAbsoluteSizeChanged = React.useCallback(function(object)
			if not object:IsFocused() then
				return
			end

			object.CursorPosition = object.CursorPosition
			v69(object)
		end, { v69 })
	end

	local scrollingFrameRef = React.useCallback(function(current)
		if current == nil then
			return
		end

		ref4.current = current
		current.ClipsDescendants = true
		current.CanvasPosition = ref8.current
	end, {})

	local v72 = React.useCallback(function(object)
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
			[React.Event.DragStart] = v25,
			[React.Event.DragContinue] = v26,
			[React.Event.DragEnd] = v27,
			Enabled = not (state2 or isDisabled)
		})
	end, { v25, v26, v27, state2, isDisabled, v2.onDragStarted, v2.onDrag, v2.onDragEnded })
	local v75

	if v2.horizontalPadding then
		v75 = v2.horizontalPadding.left or UDim.new(0, 0)
	else
		v75 = UDim.new(0, 0)
	end

	local left = useBindable(v75)
	local v77

	if v2.horizontalPadding then
		v77 = v2.horizontalPadding.right or UDim.new(0, 0)
	else
		v77 = UDim.new(0, 0)
	end

	local right = useBindable(v77)

	local position = React.useMemo(function()
		if v2.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v3.Stroke.Standard) / 2))
		end

		return nil
	end, { v2.hasClearButton, container.minHeight, v3.Stroke.Standard })

	local ref13 = ReactUtils.useComposedRef(ref2, v72)

	local layout2 = v6 ~= nil
		and {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v6),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
		or nil

	local createElement = React.createElement

	local v82 = {
		Size = UDim2.new(1, 0, 0, v56),
		AutomaticSize = 0,
		selection = 0,
		cursor = 0,
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
	local automaticSize

	if FFlagComposerFooter then
		automaticSize = Enum.AutomaticSize.Y
	end

	v82.AutomaticSize = automaticSize
	v82.selection = {
		Selectable = v2.Selectable and not isDisabled,
		NextSelectionUp = v2.NextSelectionUp,
		NextSelectionDown = v2.NextSelectionDown,
		NextSelectionLeft = v2.NextSelectionLeft,
		NextSelectionRight = v2.NextSelectionRight
	}

	v82.cursor = cursor
	local stroke

	if v7 and container.strokeThickness then
		stroke = { Color = v7.Color3, Transparency = 0, Thickness = 0, BorderStrokePosition = 0 }
		local transparency

		if isDisabled then
			transparency = blendTransparencies(v7.Transparency, Constants.DISABLED_TRANSPARENCY)
		else
			transparency = v7.Transparency
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

	v82.stroke = stroke
	local cornerRadius

	if FFlagComposerFooter and not v31 then
		local v87

		if v2.radius then
			v87 = v3.Radius[v2.radius]
		else
			v87 = container.radius
		end

		cornerRadius = UDim.new(0, v87)
	else
		cornerRadius = v31
	end

	v82.cornerRadius = cornerRadius
	local padding2

	if FFlagComposerFooter then
		padding2 = {
			left = UDim.new(0, standard),
			right = UDim.new(0, standard),
			top = UDim.new(0, standard),
			bottom = UDim.new(0, standard)
		}
	else
		padding2 = {
			left = left:map(function(p3)
				return UDim.new(0, standard) + p3
			end),
			right = 0,
			top = 0,
			bottom = 0
		}
		local right2

		if v2.trailingElement == nil and v2.hasClearButton then
			right2 = UDim.new(0, standard)
		else
			right2 = right:map(function(p3)
				return UDim.new(0, standard) + p3
			end)
		end

		padding2.right = right2

		padding2.top = UDim.new(0, standard)
		padding2.bottom = UDim.new(0, standard)
	end

	v82.padding = padding2
	local onActivated2

	if not isDisabled then
		onActivated2 = v19
	end

	v82.onActivated = onActivated2
	v82.onStateChanged = onStateChanged
	v82.isDisabled = isDisabled2
	local backgroundStyle

	if container.bgStyle then
		backgroundStyle = getDisabledStyle({
			Color3 = container.bgStyle.Color3,
			Transparency = v2.backgroundGradient and 0 or container.bgStyle.Transparency
		}, isDisabled2)
	end

	v82.backgroundStyle = backgroundStyle

	v82.stateLayer = { affordance = StateLayerAffordance.None }
	v82.layout = FFlagComposerFooter
		and { FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder }
		or layout2

	v82.tag = FFlagComposerFooter and "col" or tag
	v82.testId = `{v2.testId}--outer-container`
	local v89 = withCommonProps(v2, v82)

	local v90 = {
		DragDetector = dragDetector,
		Background = v2.backgroundGradient,
		InputRow = 0,
		Footer = 0
	}
	local createElement2 = React.createElement
	local v91 = if FFlagComposerFooter then View else React.Fragment
	local v92

	if FFlagComposerFooter then
		v92 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v57),
			layout = layout2,
			padding = 0,
			tag = 0,
			testId = 0
		}

		if v2.trailingElement == nil and v2.hasClearButton then
			right = UDim.new(0, 0)
		end

		v92.padding = { left = left, right = right }

		v92.tag = tag
		v92.testId = `{v2.testId}--input-row`
	end

	local leading

	if v2.leadingElement then
		local createElement3 = React.createElement
		local groupTransparency

		if isDisabled2 then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		leading = createElement3(
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

	local createElement3 = React.createElement
	local v95 = if isMultiLine then ScrollView else View
	local testId

	if FFlagComposerFooter then
		testId = `{v2.testId}--viewport`
	end

	local padding3

	if v60 then
		padding3 = v55
	end

	if not isMultiLine then
		onCanvasPositionChanged = nil
	end

	if not isMultiLine then
		scrollingFrameRef = nil
	end

	local createElement4 = React.createElement
	local size

	if v59 then
		size = UDim2.new(1, 0, 0, v66)
	end

	local v100 = {
		Size = size,
		tag = {
			["fill size-full"] = not v59
		},
		padding = 0,
		selection = 0,
		onActivated = 0,
		stateLayer = 0
	}
	local padding4

	if v61 then
		padding4 = v55
	end

	v100.padding = padding4
	v100.selection = { Selectable = false }
	local onActivated3

	if not isDisabled then
		onActivated3 = v19
	end

	v100.onActivated = onActivated3
	v100.stateLayer = { affordance = StateLayerAffordance.None }
	local textBox

	if not state3 then
		local createElement5 = React.createElement
		local v106 = {
			text = text3,
			placeholder = v2.placeholder,
			textInputType = v2.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = isMultiLine,
			isDisabled = isDisabled,
			ref = ref,
			tag = `{v8 or ""} data-testid={v2.testId}--textbox`,
			Size = 0,
			automaticSize = 0,
			padding = 0,
			onFocusGained = 0,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0,
			onAbsoluteSizeChanged = 0,
			onInputChanged = 0,
			onInputEnded = 0,
			manualFocusRelease = 0,
			shouldEmitReturnEvents = 0,
			overlayNativeInput = nil
		}

		if not isMultiLine then
			udim = nil
		end

		v106.Size = udim
		local automaticSize2

		if not v2.maxLines then
			if v13 then
				if isMultiLine and not state3 and state6 ~= "" then
					automaticSize2 = Enum.AutomaticSize.Y
				end
			else
				automaticSize2 = mapBindable(v2.text, function(p3)
					if isMultiLine and not state3 and p3 ~= "" then
						return Enum.AutomaticSize.Y
					end

					return nil
				end)
			end
		end

		v106.automaticSize = automaticSize2

		v106.padding = padding
		v106.onFocusGained = onFocusGained
		local onFocusLost2

		if not (isMultiLine and v10) then
			onFocusLost2 = onFocusLost
		end

		v106.onFocusLost = onFocusLost2
		v106.onTextChanged = onTextChanged
		local onCursorPositionChanged

		if isMultiLine then
			onCursorPositionChanged = v69
		end

		v106.onCursorPositionChanged = onCursorPositionChanged

		if not (defineFastFlag and isMultiLine) then
			onAbsoluteSizeChanged = nil
		end

		v106.onAbsoluteSizeChanged = onAbsoluteSizeChanged

		v106.onInputChanged = onInputChanged
		v106.onInputEnded = onInputEnded
		local manualFocusRelease

		if v10 then
			manualFocusRelease = v2.manualFocusRelease
		end

		v106.manualFocusRelease = manualFocusRelease

		v106.shouldEmitReturnEvents = v10 and v2.manualFocusRelease == true and v2.alwaysMultiLine == true and true
			or nil
		local boundsChecker

		if isMultiLine then
			local createElement6 = React.createElement
			local v113 = {
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
				size2 = UDim2.new(1, 0, 1, v58)
			end

			v113.Size = size2

			v113.ref = ref3
			boundsChecker = createElement6(memo, v113)
		end

		textBox = createElement5(memo, v106, {
			DragDetector = dragDetector,
			BoundsChecker = boundsChecker
		})
	end

	local mobileFocusTarget

	if isMultiLine and v10 and not (state3 or isDisabled) then
		mobileFocusTarget = React.createElement(View, {
			onActivated = v19,
			selection = { Selectable = false },
			stateLayer = { affordance = StateLayerAffordance.None },
			tag = "size-full",
			testId = `{v2.testId}--mobile-focus-target`,
			ZIndex = 2
		})
	end

	local mobileTextBox

	if isMultiLine and state3 then
		local createElement5 = React.createElement
		local v108 = {
			text = text3,
			placeholder = v2.placeholder,
			textInputType = v2.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = isMultiLine,
			isDisabled = isDisabled,
			padding = padding,
			ref = ref13,
			tag = `{v8 or ""} data-testid={v2.testId}--mobile-textbox`,
			Size = udim2,
			onFocusGained = onFocusGained,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0,
			onInputEnded = 0,
			manualFocusRelease = 0,
			shouldEmitReturnEvents = 0,
			overlayNativeInput = nil
		}

		if not (isMultiLine and v10) then
			onFocusLost = nil
		end

		v108.onFocusLost = onFocusLost
		v108.onTextChanged = onTextChanged
		local onCursorPositionChanged

		if isMultiLine then
			onCursorPositionChanged = v69
		end

		v108.onCursorPositionChanged = onCursorPositionChanged
		v108.onInputEnded = onInputEnded
		local manualFocusRelease

		if v10 then
			manualFocusRelease = v2.manualFocusRelease
		end

		v108.manualFocusRelease = manualFocusRelease

		v108.shouldEmitReturnEvents = v10 and v2.manualFocusRelease == true and v2.alwaysMultiLine == true and true
			or nil
		mobileTextBox = createElement5(memo, v108)
	end

	local v93 = {
		Leading = leading,
		TextBoxWrapper = createElement3(v95, {
			LayoutOrder = 2,
			testId = testId,
			padding = padding3,
			selection = { Selectable = false },
			scroll = scroll,
			layout = layout,
			onCanvasPositionChanged = onCanvasPositionChanged,
			scrollingFrameRef = scrollingFrameRef,
			tag = "fill size-full clip"
		}, {
			TextContent = createElement4(View, v100, {
				TextBox = textBox,
				MobileFocusTarget = mobileFocusTarget,
				MobileTextBox = mobileTextBox
			})
		}),
		Clear = 0,
		Trailing = 0
	}
	local clear

	if v2.hasClearButton then
		local createElement5 = React.createElement
		local v109 = {
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

		v109.GroupTransparency = groupTransparency

		v109.Visible = mapBindable(v2.text, function(p3): boolean
			return p3 ~= ""
		end)

		v109.tag = v5.clearButton.tag
		clear = createElement5(View, v109, {
			ClearButton = React.createElement(View, {
				onActivated = onActivated,
				padding = UDim.new(0, v5.clearButton.padding),
				Position = position,
				stateLayer = { affordance = StateLayerAffordance.None },
				tag = "anchor-center-left auto-xy",
				testId = `{v2.testId}--clear-button`
			}, {
				Icon = React.createElement(Icon, { name = v5.clearButton.icon })
			})
		})
	end

	v93.Clear = clear
	local trailing

	if v2.trailingElement then
		local createElement5 = React.createElement
		local groupTransparency

		if isDisabled2 then
			groupTransparency = Constants.DISABLED_TRANSPARENCY
		end

		trailing = createElement5(View, {
			GroupTransparency = groupTransparency,
			LayoutOrder = 4,
			tag = {
				["col align-y-bottom self-stretch size-0-full auto-x"] = v2.trailingAlignBottom == true,
				["row align-y-center size-0-full auto-x"] = v2.trailingAlignBottom ~= true
			},
			testId = `{v2.testId}--trailing`
		}, v2.trailingElement)
	end

	v93.Trailing = trailing
	v90.InputRow = createElement2(v91, v92, v93)
	local footer

	if v4 then
		footer = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "size-full-0 auto-y", testId = `{v2.testId}--footer` },
			v2.footerElement
		)
	end

	v90.Footer = footer
	return createElement(View, v89, v90)
end

return React.memo(React.forwardRef(InternalTextInput))
