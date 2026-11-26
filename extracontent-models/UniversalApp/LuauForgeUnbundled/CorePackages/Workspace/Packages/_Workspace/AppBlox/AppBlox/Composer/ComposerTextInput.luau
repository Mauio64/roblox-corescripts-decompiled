local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local fFlagComposerFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagComposerFooter
local defineFastFlag = game:DefineFastFlag("ComposerMultiLineCaretFix", false)
local defineFastFlag2 = game:DefineFastFlag("ComposerDraftTextBindingSync", false)

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
local composerDebug = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer/composerDebug")
local measureTextLineCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer/measureTextLineCount")
local useComposerFocusLock = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer/useComposerFocusLock")
local useComposerKeyboardConnections = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/Composer/useComposerKeyboardConnections")

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

local v5 = {
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

	local v7 = {}
	v7.ClearTextOnFocus = false
	v7.Selectable = false
	v7.Active = if isBoundsChecker then false else nil
	v7.Visible = if isBoundsChecker then false else nil
	v7.FontFace = normalizeFontFace(props.fontStyle.Font)
	v7.TextSize = props.fontStyle.FontSize
	v7.LineHeight = props.fontStyle.LineHeight
	local v10 = if props.textStyle then props.textStyle.Color3 else nil
	v7.TextColor3 = v10
	local v11 = if props.textStyle then props.textStyle.Transparency else nil
	v7.TextTransparency = v11
	v7.MultiLine = isMultiLine
	v7.TextWrapped = isMultiLine
	local v12 = if isMultiLine then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
	v7.TextYAlignment = v12
	v7.TextEditable = not isBoundsChecker and not props.isDisabled
	v7.PlaceholderText = props.placeholder
	local v14 = if isPluginSecurity() then props.textInputType else nil
	v7.TextInputType = v14
	v7.ManualFocusRelease = props.manualFocusRelease and true or nil
	v7.ShouldEmitReturnEvents = props.shouldEmitReturnEvents and true or nil
	v7.OverlayNativeInput = props.overlayNativeInput and true or nil
	local v15 = if props.Size == nil then UDim2.fromScale(1, 1) else props.Size
	v7.Size = v15
	v7.AutomaticSize = props.automaticSize
	local text

	if not isBoundsChecker then
		if typeof(props.text) == "string" then
		end

		text = props.text
	end

	v7.Text = text
	v7.ref = ref
	v7[React.Tag] = props.tag
	v7[React.Change.Text] = props.onTextChanged
	v7[React.Change.CursorPosition] = props.onCursorPositionChanged
	v7[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
	v7[React.Event.Focused] = props.onFocusGained
	v7[React.Event.FocusLost] = props.onFocusLost
	v7[React.Event.InputChanged] = props.onInputChanged
	v7[React.Event.InputEnded] = props.onInputEnded
	return createElement("TextBox", v7, props.padding and {
		Padding = React.createElement(Padding, { value = props.padding })
	} or nil, props.children)
end))

local function InternalTextInput(p2, p3)
	if p2.Selectable == nil then
		p2 = table.clone(p2)
		p2.Selectable = true
	end

	local v6 = withDefaults(p2, v5)
	local v7 = useTokens()
	local v8 = fFlagComposerFooter and v6.footerElement ~= nil
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef("")
	local ref6 = React.useRef(getBindableValue(v6.text))

	local ref7 = React.useRef(nil)
	local ref8 = React.useRef(Vector2.zero)
	local ref9 = React.useRef(false)
	local ref10 = React.useRef(0)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v9 = useTextInputVariants(v7, v6.size, v6.variant, v6.radius, state2, v6.hasError)
	local container = v9.container
	local v10

	if v6.leadingElement == nil then
		if v6.trailingElement ~= nil then
			v10 = v7.Gap.XSmall
		end
	else
		v10 = v7.Gap.Small
	end

	local v11

	if v10 == nil and v6.trailingElement and typeof(container.tag) == "string" then
		v11 = string.gsub(container.tag, "gap%-large", "gap-xsmall")
	else
		v11 = container.tag
	end

	local v12

	if state2 and v6.variant == InputVariant.Standard and not v6.hasError then
		v12 = v7.Color.Stroke.Default
	else
		v12 = container.strokeStyle
	end

	local v13 = useStyleTags(v9.textBox.tag)

	local isDisabled = v6.isDisabled
	local ref11 = React.useRef(isDisabled)
	ref11.current = isDisabled
	local v14 = v6.isDisabled

	if v14 then
		v14 = v6.trailingElement == nil and not v8
	end

	local v15 = usePreferredInput()
	local state3, setState3 = React.useState(false)
	local v16 = v15 == Enum.PreferredInput.Touch
	React.useEffect(function()
		if isDisabled then
			setState3(false)
			setState2(false)
		end

		return function() end
	end, { isDisabled })

	local standard = v7.Stroke.Standard
	local v17 = math.ceil(standard) * 2
	local v18 = math.ceil(v7.Stroke.Thick) * 2

	useComposerFocusLock(isDisabled == true, { ref, ref2 })

	local disabledStyle = getDisabledStyle(v7.Color.Content.Emphasis, isDisabled)
	local fontStyle = v9.textBox.fontStyle
	local fontSize = fontStyle.FontSize
	local lineHeight = fontStyle.LineHeight

	local multiLineTextHeight = getMultiLineTextHeight(fontSize, 1, lineHeight)
	local state4, setState4 = React.useState(1)
	local state5, setState5 = React.useState(multiLineTextHeight)
	local v19 = v6.maxLines ~= nil
	local state6, setState6 = React.useState(function()
		return getBindableValue(v6.text)
	end)

	React.useEffect(function()
		composerDebug.setEnabled(v6.composerDebug == true)
		return function() end
	end, { v6.composerDebug })

	local v20 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current and current.AbsoluteSize.X > 0 then
			return current.AbsoluteSize.X
		end

		return 0
	end, {})

	local v21 = React.useCallback(function(p4)
		local v22 = measureTextLineCount({
			text = p4,
			maxLines = v6.maxLines,
			singleLineHeight = multiLineTextHeight,
			layoutWidth = v20(),
			font = normalizeFontFace(fontStyle.Font),
			fontSize = fontSize
		})

		if defineFastFlag then
			setState5(getMultiLineTextHeight(fontSize, v22.unclampedLineCount, lineHeight))
		else
			local v23 = if v22.boundsY and v22.boundsY > 0 then math.ceil(v22.boundsY) else multiLineTextHeight

			setState5((math.max(v23, v22.lineCount * multiLineTextHeight)))
		end

		return v22.lineCount
	end, { fontSize, lineHeight, fontStyle.Font, v6.maxLines, v20, multiLineTextHeight })

	local v22 = if v19 then v6.text else getBindableValue(v6.text)

	local v23 = math.max(1, (math.floor(v6.minLines or 1)))

	if v6.maxLines then
		v23 = math.min(v23, v6.maxLines)
	end

	local v24 = if v6.maxLines then math.max(v23, state4) else math.max(v23, v6.numLines)
	local v25 = v6.alwaysMultiLine and true or v24 > 1

	React.useEffect(function()
		if not v19 then
			return function() end
		end

		local bindableValue = getBindableValue(v6.text)

		if bindableValue ~= ref6.current then
			composerDebug.log("syncFromParent", `len={utf8.len(bindableValue) or #bindableValue}`)
			ref6.current = bindableValue
			setState6(bindableValue)
			setState4(v21(bindableValue))
			task.defer(function()
				setState4(v21(bindableValue))
			end)
		end

		return function() end
	end, { v6.text, v21, v19 })

	local v27 = React.useCallback(function(selectionStart)
		if ref.current then
			ref.current.SelectionStart = selectionStart
		end

		if ref2.current then
			ref2.current.SelectionStart = selectionStart
		end
	end, {})

	local v28 = React.useCallback(function(cursorPosition)
		if ref.current then
			ref.current.CursorPosition = cursorPosition
		end

		if ref2.current then
			ref2.current.CursorPosition = cursorPosition
		end
	end, {})

	local v29 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current == nil or current.Parent == nil then
			return
		end

		local v30 = utf8.len(current.Text)

		if v30 then
			v27(0)
			v28(v30 + 1)
		end
	end, { v27, v28 })

	local v30 = React.useCallback(function()
		if v25 and v16 and not state3 then
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

			if v6.focusBehavior == InputFocusBehavior.Highlight then
				task.spawn(v29)
			end
		end
	end, { v29, v6.focusBehavior, v25, v16, state3 })

	local v31 = React.useCallback(function()
		if ref.current then
			ref.current:ReleaseFocus()
		end

		if ref2.current then
			ref2.current:ReleaseFocus()
		end

		setState3(false)
		setState2(false)
	end, {})

	local v32 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current then
			return current:IsFocused()
		end

		return nil
	end, {})

	local v33 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current then
			return current.SelectionStart
		end

		return nil
	end, {})

	local v34 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current then
			return current.CursorPosition
		end

		return nil
	end, {})

	local v35 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current then
			current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p3, function()
		return {
			getIsFocused = v32,
			focus = v30,
			releaseFocus = v31,
			setHover = setState,
			getSelectionStart = v33,
			getCursorPosition = v34,
			setCursorPosition = v28,
			setSelectionStart = v27
		}
	end, { v34, v32, v33, v30, v31, v28, v27 })

	local v36 = React.useCallback(function(instance)
		if instance == nil or instance.Parent == nil or ref5.current ~= "" then
			return
		end

		if ref11.current then
			local text = instance.Text

			if defineFastFlag2 and v19 and text ~= "" and text ~= ref6.current then
				ref6.current = text
				setState6(text)
				setState4(v21(text))
			end
		else
			local text = instance.Text

			if ref9.current and text ~= "" or text == ref6.current then
				return
			end

			ref6.current = text

			if v25 and ref3.current then
				ref3.current.Text = text
			end

			if v19 then
				setState6(text)
			end

			if v6.maxLines then
				setState4(v21(text))
				task.defer(function()
					setState4(v21(text))
				end)
			end

			v6.onChanged(text)
		end
	end, { v6.onChanged, v25, v6.maxLines, v21, v19 })

	local ref12 = React.useRef(false)

	local v37 = React.useCallback(function(p4, p5)
		if p5.UserInputType == Enum.UserInputType.MouseMovement then
			ref12.current = false
		end
	end, {})

	local v38 = React.useCallback(function(p4, p5)
		if not ref12.current then
			return
		end

		ref12.current = false

		if p5.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v29()
	end, { v27, v28, v29 })

	local v39 = React.useCallback(function(current)
		ref6.current = current

		if v19 then
			setState6(current)
		end

		if v6.maxLines then
			setState4(v21(current))
		end

		v6.onChanged(current)
	end, { v6.maxLines, v21, v6.onChanged, v19 })

	local v40 = not (v6.onReturnPressed == nil) and not v16

	local v41 = React.useCallback(function(p4, p5)
		if v6.onReturnPressed == nil then
			return
		end

		local now = os.clock()

		if now - ref10.current < 0.15 then
			composerDebug.log("returnSubmit", `source={p5} skipped=debounced`)
			return
		end

		composerDebug.log("returnSubmit", `source={p5}`)
		ref10.current = now
		ref9.current = true
		v6.onReturnPressed()

		task.delay(0.15, function()
			ref9.current = false
		end)
	end, { v6.onReturnPressed })

	local v42 = React.useCallback(function(p4, p5)
		local current = ref.current

		if current == nil or current:IsFocused() ~= true then
			return
		end

		if not p5 then
			v41(current, "UserInputService.InputBegan")
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
				v39(text2)
			end
		end)
	end, { v41, v39 })

	local v43 = useComposerKeyboardConnections({
		enabled = v40 == true,
		onReturnPressed = v42
	})

	local connect = v43.connect
	local disconnect = v43.disconnect

	local v44 = React.useCallback(function()
		if isDisabled then
			return
		end

		setState2(true)

		if v6.onFocus then
			v6.onFocus()
		end

		if v40 then
			connect()
		end

		local focusBehavior = v6.focusBehavior

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
	end, { v6.onFocus, isDisabled, v6.focusBehavior, v40, connect })

	local v45 = React.useCallback(function(p4, p5)
		v38(p4, p5)
	end, { v38 })

	local v46 = React.useCallback(function(p4, p5, p6)
		composerDebug.log("textBox.FocusLost", `enterPressed={p5}`)

		if v40 then
			disconnect()
		end

		setState2(false)
		ref12.current = false

		if v25 then
			setState3(false)
		end

		if v6.onFocusLost then
			v6.onFocusLost(p6)
		end

		if p5 and v40 then
			v41(p4, "TextBox.FocusLost")
		end
	end, { v25, v6.onFocusLost, v40, v41, disconnect })

	local v47 = React.useCallback(function(p4)
		setState(p4 == ControlState.Hover)
	end, {})

	local v48 = React.useCallback(function(p4, current)
		ref7.current = current

		if v6.onDragStarted then
			v6.onDragStarted(p4, current)
		end
	end, { v6.onDragStarted })

	local v49 = React.useCallback(function(p4, p5)
		if v6.onDrag then
			v6.onDrag(p4, p5)
		end
	end, { v6.onDrag })

	local v50 = React.useCallback(function(p4, p5)
		if ref7.current == p5 then
			v30()
		else
			v31()
			setState2(false)
		end

		ref7.current = nil

		if v6.onDragEnded then
			v6.onDragEnded(p4, p5)
		end
	end, { v6.onDragEnded, v30, v31 })

	local v51 = if v6.maxLines then getMultiLineTextHeight(fontSize, v6.maxLines, lineHeight) else nil

	local multiLineTextHeight2 = getMultiLineTextHeight(fontSize, v23, lineHeight)
	local v52 = React.useMemo(function()
		if v6.maxLines then
			return (math.clamp(math.max(multiLineTextHeight2, state5), multiLineTextHeight2, v51))
		end

		return getMultiLineTextHeight(fontSize, v24, lineHeight)
	end, { v6.maxLines, multiLineTextHeight2, state5, v51, fontSize, v24, lineHeight })

	local v53 = React.useMemo(function()
		local multiLineTextHeight3 = getMultiLineTextHeight(fontSize, 1, lineHeight)
		local v54 = multiLineTextHeight3 + math.round(math.round((container.minHeight - v17 - multiLineTextHeight3) * 2) / 2) + v17
		return UDim.new(0, (math.ceil(v54 / 2)))
	end, { container.minHeight, v17, fontSize, lineHeight })

	local v54 = React.useMemo(function()
		if v6.maxLines then
			return v53
		end

		if v6.radius == Radius.Circle then
			return UDim.new(0, (math.ceil(container.minHeight / 2)))
		end

		return nil
	end, { v6.maxLines, v53, container.minHeight, v6.radius })

	local v55 = React.useMemo(function()
		local v57 = if v54 then v54 else UDim.new(0, container.radius)
		return { radius = v57, offset = v7.Stroke.Thick, borderWidth = v7.Stroke.Thick }
	end, { v7, container.radius, v54 })

	local useMemo = React.useMemo
	local function fn()
		local v56 = math.round((container.minHeight - v17 - getMultiLineTextHeight(fontSize, 1, lineHeight)) * 2) / 2

		local udim = UDim.new(0, (math.floor(v56 / 2)))
		local udim2 = UDim.new(0, (math.ceil(v56 / 2)))

		if fFlagComposerFooter and v8 then
			local v57 = math.min(v7.Size.Size_100, udim2.Offset)
			udim += UDim.new(0, v57)
			udim2 -= UDim.new(0, v57)
		end

		local v57 = v52 + math.round(v56)
		local v58 = v57 + v17

		return {
			top = udim,
			bottom = udim2,
			left = UDim.new(0, 0),
			right = UDim.new(0, 0)
		}, v58, v57
	end

	local minHeight = container.minHeight
	local v57 = if fFlagComposerFooter then v8 else nil
	local v59, v60, v61 = useMemo(fn, {
		minHeight,
		v17,
		v18,
		fontSize,
		v52,
		lineHeight,
		v57,
		if fFlagComposerFooter then v7 else nil
	})

	local v62 = v59.bottom.Offset + v59.top.Offset
	local v63 = if v25 then not (v6.maxLines == nil) and not state3 else v25
	local textPaddingOnParent = v6.textPaddingOnParent == true
	local v64 = textPaddingOnParent and v63
	local v65 = textPaddingOnParent and not v64
	local v66 = if not textPaddingOnParent then v59 else nil
	local v67 = if textPaddingOnParent then v52 else v52 + v62

	local v68 = if textPaddingOnParent then state5 else state5 + v62

	local v69 = if v63 then math.max(v67, v68) else v67

	local v70 = if v65 then v69 + v62 else v69

	local udim = UDim2.new(1, 0, 0, v69)
	local udim2 = UDim2.new(1, 0, 0, v67)

	React.useEffect(function()
		if v6.maxLines then
			composerDebug.log("layout", `lineCount={v24} borderFrameHeight={v60}`)
		end

		return function() end
	end, { v24, v60, v6.maxLines })

	local v71 = React.useMemo(function()
		if not v25 then
			return nil
		end

		local v72 = {
			FillDirection = Enum.FillDirection.Vertical,
			ItemLineAlignment = 0
		}
		local v73 = if v6.maxLines == nil then Enum.ItemLineAlignment.Center else Enum.ItemLineAlignment.Start
		v72.ItemLineAlignment = v73
		return v72
	end, { v25, v6.maxLines })

	local v72 = React.useMemo(function()
		if v25 then
			return {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always
			}
		end

		return nil
	end, { v25 })

	local v73 = React.useCallback(function(p4)
		local current = ref4.current
		local current2 = ref3.current

		if current == nil or current2 == nil then
			return
		end

		local v74 = p4.TextSize * p4.LineHeight
		local y = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p4)
		local y2 = current2.TextBounds.Y

		local v75 = y - v59.top.Offset + v59.bottom.Offset

		local v76 = y + current.AbsoluteSize.Y - v59.top.Offset - v59.bottom.Offset

		if y2 - v74 < v75 then
			current.CanvasPosition += Vector2.new(0, y2 - v74 - v75)
		end

		if v76 < y2 then
			current.CanvasPosition += Vector2.new(0, y2 - v76)
		end
	end, { v59 })
	local v74

	if defineFastFlag then
		v74 = React.useCallback(function(object)
			if not object:IsFocused() then
				return
			end

			object.CursorPosition = object.CursorPosition
			v73(object)
		end, { v73 })
	end

	local v75 = React.useCallback(function(current)
		if current == nil then
			return
		end

		ref4.current = current
		current.ClipsDescendants = true
		current.CanvasPosition = ref8.current
	end, {})

	local v76 = React.useCallback(function(object)
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

	local v77 = React.useCallback(function(p4)
		ref8.current = p4.CanvasPosition
	end, {})

	local v78 = React.useMemo(function()
		if not (v6.onDragStarted or v6.onDrag or v6.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v48,
			[React.Event.DragContinue] = v49,
			[React.Event.DragEnd] = v50,
			Enabled = not (state2 or isDisabled)
		})
	end, {
		v48,
		v49,
		v50,
		state2,
		isDisabled,
		v6.onDragStarted,
		v6.onDrag,
		v6.onDragEnded
	})
	local v80

	if v6.horizontalPadding then
		v80 = v6.horizontalPadding.left or UDim.new(0, 0)
	else
		v80 = UDim.new(0, 0)
	end

	local v81 = useBindable(v80)
	local v83

	if v6.horizontalPadding then
		v83 = v6.horizontalPadding.right or UDim.new(0, 0)
	else
		v83 = UDim.new(0, 0)
	end

	local v84 = useBindable(v83)

	local v85 = React.useMemo(function()
		if v6.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v7.Stroke.Standard) / 2))
		end

		return nil
	end, { v6.hasClearButton, container.minHeight, v7.Stroke.Standard })

	local v86 = ReactUtils.useComposedRef(ref2, v76)

	local v87 = v10 ~= nil
		and {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v10),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
		or nil

	local createElement = React.createElement

	local v90 = {
		Size = UDim2.new(1, 0, 0, v60),
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
	local v91 = if fFlagComposerFooter then Enum.AutomaticSize.Y else nil
	v90.AutomaticSize = v91
	v90.selection = {
		Selectable = v6.Selectable and not isDisabled,
		NextSelectionUp = v6.NextSelectionUp,
		NextSelectionDown = v6.NextSelectionDown,
		NextSelectionLeft = v6.NextSelectionLeft,
		NextSelectionRight = v6.NextSelectionRight
	}

	v90.cursor = v55
	local v92

	if v12 and container.strokeThickness then
		v92 = {
			Color = v12.Color3,
			Transparency = 0,
			Thickness = 0,
			BorderStrokePosition = 0
		}

		local v93 = if isDisabled then blendTransparencies(
			v12.Transparency,
			Constants.DISABLED_TRANSPARENCY
		) else v12.Transparency
		v92.Transparency = v93

		v92.Thickness = container.strokeThickness

		local v94 = if state2 or state then Enum.BorderStrokePosition.Center else Enum.BorderStrokePosition.Inner
		v92.BorderStrokePosition = v94
	end

	v90.stroke = v92
	local v93

	if fFlagComposerFooter and not v54 then
		local newUDim = UDim.new

		local v95 = if v6.radius then v7.Radius[v6.radius] else container.radius
		v93 = newUDim(0, v95)
	else
		v93 = v54
	end

	v90.cornerRadius = v93
	local v94

	if fFlagComposerFooter then
		v94 = {
			left = UDim.new(0, standard),
			right = UDim.new(0, standard),
			top = UDim.new(0, standard),
			bottom = UDim.new(0, standard)
		}
	else
		v94 = {
			left = v81:map(function(p4)
				return UDim.new(0, standard) + p4
			end),
			right = 0,
			top = 0,
			bottom = 0
		}
		local v95

		if v6.trailingElement == nil and v6.hasClearButton then
			v95 = UDim.new(0, standard)
		else
			v95 = v84:map(function(p4)
				return UDim.new(0, standard) + p4
			end)
		end

		v94.right = v95

		v94.top = UDim.new(0, standard)
		v94.bottom = UDim.new(0, standard)
	end

	v90.padding = v94

	v90.onActivated = if not isDisabled then v30 else nil
	v90.onStateChanged = v47
	v90.isDisabled = v14
	local v96 = if container.bgStyle then getDisabledStyle({
		Color3 = container.bgStyle.Color3,
		Transparency = v6.backgroundGradient and 0 or container.bgStyle.Transparency
	}, v14) else nil
	v90.backgroundStyle = v96

	v90.stateLayer = { affordance = StateLayerAffordance.None }
	v90.layout = fFlagComposerFooter
		and {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}
		or v87

	v90.tag = fFlagComposerFooter and "col" or v11
	v90.testId = `{v6.testId}--outer-container`
	local v97 = withCommonProps(v6, v90)

	local v98 = {
		DragDetector = v78,
		Background = v6.backgroundGradient,
		InputRow = 0,
		Footer = 0
	}
	local createElement2 = React.createElement
	local v99 = if fFlagComposerFooter then View else React.Fragment
	local v100

	if fFlagComposerFooter then
		v100 = {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v61),
			layout = v87,
			padding = 0,
			tag = 0,
			testId = 0
		}

		if v6.trailingElement == nil and v6.hasClearButton then
			v84 = UDim.new(0, 0)
		end

		v100.padding = { left = v81, right = v84 }

		v100.tag = v11
		v100.testId = `{v6.testId}--input-row`
	end

	local v102

	if v6.leadingElement then
		local createElement3 = React.createElement
		local v105 = if v14 then Constants.DISABLED_TRANSPARENCY else nil
		v102 = createElement3(
			View,
			{
				GroupTransparency = v105,
				LayoutOrder = 1,
				tag = "col align-y-bottom self-stretch size-0-full auto-x",
				testId = `{v6.testId}--leading`
			},
			v6.leadingElement
		)
	end

	local createElement3 = React.createElement
	local v103 = if v25 then ScrollView else View
	local v105 = if fFlagComposerFooter then `{v6.testId}--viewport` else nil
	local v104 = {
		LayoutOrder = 2,
		testId = v105,
		padding = if v64 then v59 else nil,
		selection = { Selectable = false },
		scroll = v72,
		layout = v71,
		onCanvasPositionChanged = 0,
		scrollingFrameRef = 0,
		tag = "fill size-full clip"
	}

	if not v25 then
		v77 = nil
	end

	v104.onCanvasPositionChanged = v77

	if not v25 then
		v75 = nil
	end

	v104.scrollingFrameRef = v75

	local createElement4 = React.createElement

	local v110 = if v63 then UDim2.new(1, 0, 0, v70) else nil
	local v109 = {
		Size = v110,
		tag = {
			["fill size-full"] = not v63
		},
		padding = if v65 then v59 else nil,
		selection = { Selectable = false },
		onActivated = if not isDisabled then v30 else nil,
		stateLayer = { affordance = StateLayerAffordance.None }
	}
	local v114

	if not state3 then
		local createElement5 = React.createElement
		local v116 = {
			text = v22,
			placeholder = v6.placeholder,
			textInputType = v6.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = v25,
			isDisabled = isDisabled,
			ref = ref,
			tag = `{v13 or ""} data-testid={v6.testId}--textbox`,
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

		if not v25 then
			udim = nil
		end

		v116.Size = udim
		local v117

		if not v6.maxLines then
			if v19 then
				if v25 and not state3 and state6 ~= "" then
					v117 = Enum.AutomaticSize.Y
				end
			else
				v117 = mapBindable(v6.text, function(p4)
					if v25 and not state3 and p4 ~= "" then
						return Enum.AutomaticSize.Y
					end

					return nil
				end)
			end
		end

		v116.automaticSize = v117

		v116.padding = v66
		v116.onFocusGained = v44
		local v118 = if not (v25 and v16) then v46 else nil
		v116.onFocusLost = v118
		v116.onTextChanged = v36
		v116.onCursorPositionChanged = if v25 then v73 else nil

		if not (defineFastFlag and v25) then
			v74 = nil
		end

		v116.onAbsoluteSizeChanged = v74

		v116.onInputChanged = v37
		v116.onInputEnded = v45

		local v120 = if v16 then v6.manualFocusRelease else nil
		v116.manualFocusRelease = v120

		v116.shouldEmitReturnEvents = v16
			and v6.manualFocusRelease == true
			and v6.alwaysMultiLine == true
			and true
			or nil
		local v122

		if v25 then
			local createElement6 = React.createElement
			local v124 = {
				isBoundsChecker = true,
				fontStyle = fontStyle,
				textStyle = disabledStyle,
				Size = 0,
				ref = 0
			}

			local v125 = if textPaddingOnParent then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 1, v62)
			v124.Size = v125

			v124.ref = ref3
			v122 = createElement6(memo, v124)
		end

		v114 = createElement5(memo, v116, { DragDetector = v78, BoundsChecker = v122 })
	end

	local v115 = if v25 and v16 and not (state3 or isDisabled) then React.createElement(View, {
		onActivated = v30,
		selection = { Selectable = false },
		stateLayer = { affordance = StateLayerAffordance.None },
		tag = "size-full",
		testId = `{v6.testId}--mobile-focus-target`,
		ZIndex = 2
	}) else nil
	local v116

	if v25 and state3 then
		local createElement5 = React.createElement
		local v118 = {
			text = v22,
			placeholder = v6.placeholder,
			textInputType = v6.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = v25,
			isDisabled = isDisabled,
			padding = v66,
			ref = v86,
			tag = `{v13 or ""} data-testid={v6.testId}--mobile-textbox`,
			Size = udim2,
			onFocusGained = v44,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0,
			onInputEnded = 0,
			manualFocusRelease = 0,
			shouldEmitReturnEvents = 0,
			overlayNativeInput = nil
		}

		if not (v25 and v16) then
			v46 = nil
		end

		v118.onFocusLost = v46
		v118.onTextChanged = v36
		v118.onCursorPositionChanged = if v25 then v73 else nil
		v118.onInputEnded = v45

		local v120 = if v16 then v6.manualFocusRelease else nil
		v118.manualFocusRelease = v120

		v118.shouldEmitReturnEvents = v16
			and v6.manualFocusRelease == true
			and v6.alwaysMultiLine == true
			and true
			or nil
		v116 = createElement5(memo, v118)
	end

	local v101 = {
		Leading = v102,
		TextBoxWrapper = createElement3(v103, v104, {
			TextContent = createElement4(View, v109, {
				TextBox = v114,
				MobileFocusTarget = v115,
				MobileTextBox = v116
			})
		}),
		Clear = 0,
		Trailing = 0
	}
	local v117

	if v6.hasClearButton then
		local createElement5 = React.createElement
		local v119 = {
			isDisabled = isDisabled,
			GroupTransparency = 0,
			LayoutOrder = 3,
			Visible = 0,
			tag = 0
		}

		local v120 = if isDisabled then Constants.DISABLED_TRANSPARENCY else nil
		v119.GroupTransparency = v120

		v119.Visible = mapBindable(v6.text, function(p4): boolean
			return p4 ~= ""
		end)

		v119.tag = v9.clearButton.tag
		v117 = createElement5(View, v119, {
			ClearButton = React.createElement(View, {
				onActivated = v35,
				padding = UDim.new(0, v9.clearButton.padding),
				Position = v85,
				stateLayer = { affordance = StateLayerAffordance.None },
				tag = "anchor-center-left auto-xy",
				testId = `{v6.testId}--clear-button`
			}, {
				Icon = React.createElement(Icon, { name = v9.clearButton.icon })
			})
		})
	end

	v101.Clear = v117
	local v118

	if v6.trailingElement then
		local createElement5 = React.createElement
		local v121 = if v14 then Constants.DISABLED_TRANSPARENCY else nil
		v118 = createElement5(View, {
			GroupTransparency = v121,
			LayoutOrder = 4,
			tag = {
				["col align-y-bottom self-stretch size-0-full auto-x"] = v6.trailingAlignBottom == true,
				["row align-y-center size-0-full auto-x"] = v6.trailingAlignBottom ~= true
			},
			testId = `{v6.testId}--trailing`
		}, v6.trailingElement)
	end

	v101.Trailing = v118
	v98.InputRow = createElement2(v99, v100, v101)

	local v119 = if v8 then React.createElement(
		View,
		{ LayoutOrder = 2, tag = "size-full-0 auto-y", testId = `{v6.testId}--footer` },
		v6.footerElement
	) else nil
	v98.Footer = v119
	return createElement(View, v97, v98)
end

return React.memo(React.forwardRef(InternalTextInput))
