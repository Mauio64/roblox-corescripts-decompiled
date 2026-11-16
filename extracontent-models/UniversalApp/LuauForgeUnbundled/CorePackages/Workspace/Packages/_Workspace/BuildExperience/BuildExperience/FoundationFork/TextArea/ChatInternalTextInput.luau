local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local foundationFontFaceMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation").Utility.Flags.FoundationFontFaceMigration

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
local chatTextAreaDebug = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/TextArea/chatTextAreaDebug")
local measureTextLineCount = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/TextArea/measureTextLineCount")
local useComposerFocusLock = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/TextArea/useComposerFocusLock")
local useComposerKeyboardConnections = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/TextArea/useComposerKeyboardConnections")

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

	local v10 = if not foundationFontFaceMigration then props.fontStyle.Font else nil
	local v11 = if foundationFontFaceMigration then normalizeFontFace(props.fontStyle.Font) else nil
	local v7 = {}
	v7.ClearTextOnFocus = false
	v7.Selectable = false
	v7.Active = if isBoundsChecker then false else nil
	v7.Visible = if isBoundsChecker then false else nil
	v7.Font = v10
	v7.FontFace = v11
	v7.TextSize = props.fontStyle.FontSize
	v7.LineHeight = props.fontStyle.LineHeight
	local v12 = if props.textStyle then props.textStyle.Color3 else nil
	v7.TextColor3 = v12
	local v13 = if props.textStyle then props.textStyle.Transparency else nil
	v7.TextTransparency = v13
	v7.MultiLine = isMultiLine
	v7.TextWrapped = isMultiLine
	local v14 = if isMultiLine then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
	v7.TextYAlignment = v14
	v7.TextEditable = not isBoundsChecker and not props.isDisabled
	v7.PlaceholderText = props.placeholder
	local v16 = if isPluginSecurity() then props.textInputType else nil
	v7.TextInputType = v16
	v7.ManualFocusRelease = props.manualFocusRelease and true or nil
	v7.ShouldEmitReturnEvents = props.shouldEmitReturnEvents and true or nil
	v7.OverlayNativeInput = props.overlayNativeInput and true or nil
	local v17 = if props.Size == nil then UDim2.fromScale(1, 1) else props.Size
	v7.Size = v17
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

	local v8 = useTextInputVariants(v7, v6.size, v6.variant, v6.radius, state2, v6.hasError)
	local container = v8.container
	local v9

	if v6.leadingElement == nil then
		if v6.trailingElement ~= nil then
			v9 = v7.Gap.XSmall
		end
	else
		v9 = v7.Gap.Small
	end

	local v10

	if v9 == nil and v6.trailingElement and typeof(container.tag) == "string" then
		v10 = string.gsub(container.tag, "gap%-large", "gap-xsmall")
	else
		v10 = container.tag
	end

	local v11

	if state2 and v6.variant == InputVariant.Standard and not v6.hasError then
		v11 = v7.Color.Stroke.Default
	else
		v11 = container.strokeStyle
	end

	local v12 = useStyleTags(v8.textBox.tag)

	local isDisabled = v6.isDisabled
	local v13 = v6.isDisabled and v6.trailingElement == nil

	local v14 = usePreferredInput()
	local state3, setState3 = React.useState(false)
	local v15 = v14 == Enum.PreferredInput.Touch

	local standard = v7.Stroke.Standard
	local v16 = math.ceil(standard) * 2
	local v17 = math.ceil(v7.Stroke.Thick) * 2

	useComposerFocusLock(isDisabled == true, { ref, ref2 })

	local disabledStyle = getDisabledStyle(v7.Color.Content.Emphasis, isDisabled)
	local fontStyle = v8.textBox.fontStyle
	local fontSize = fontStyle.FontSize
	local lineHeight = fontStyle.LineHeight

	local multiLineTextHeight = getMultiLineTextHeight(fontSize, 1, lineHeight)
	local state4, setState4 = React.useState(1)
	local state5, setState5 = React.useState(multiLineTextHeight)
	local v18 = v6.maxLines ~= nil
	local state6, setState6 = React.useState(function()
		return getBindableValue(v6.text)
	end)

	React.useEffect(function()
		chatTextAreaDebug.setEnabled(v6.composerDebug == true)
		return function() end
	end, { v6.composerDebug })

	local v19 = React.useCallback(function()
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

	local v20 = React.useCallback(function(p4)
		local v22 = {
			text = p4,
			maxLines = v6.maxLines,
			singleLineHeight = multiLineTextHeight,
			layoutWidth = v19(),
			font = 0,
			fontSize = 0
		}

		local v23 = if foundationFontFaceMigration then normalizeFontFace(fontStyle.Font) else fontStyle.Font
		v22.font = v23

		v22.fontSize = fontSize
		local v24 = measureTextLineCount(v22)

		local v25 = if v24.boundsY and v24.boundsY > 0 then math.ceil(v24.boundsY) else multiLineTextHeight

		setState5((math.max(v25, v24.lineCount * multiLineTextHeight)))
		return v24.lineCount
	end, { fontSize, lineHeight, fontStyle.Font, v6.maxLines, v19, multiLineTextHeight })

	local v21 = if v18 then v6.text else getBindableValue(v6.text)

	if not v6.maxLines then
		state4 = math.max(1, v6.numLines)
	end

	local v22 = v6.alwaysMultiLine and true or state4 > 1

	React.useEffect(function()
		if not v18 then
			return function() end
		end

		local bindableValue = getBindableValue(v6.text)
		setState6(bindableValue)
		setState4(v20(bindableValue))
		task.defer(function()
			setState4(v20(bindableValue))
		end)

		if typeof(v6.text) == "table" and v6.text.getValue ~= nil then
			return React.__subscribeToBinding(v6.text, function(current)
				if current == ref6.current then
					return
				end

				chatTextAreaDebug.log("syncFromParent", `len={utf8.len(current) or #current}`)
				ref6.current = current
				setState6(current)
				setState4(v20(current))
				task.defer(function()
					setState4(v20(current))
				end)
			end)
		end

		return function() end
	end, { v6.text, v20, v18 })

	local v23 = React.useCallback(function(selectionStart)
		if ref.current then
			ref.current.SelectionStart = selectionStart
		end

		if ref2.current then
			ref2.current.SelectionStart = selectionStart
		end
	end, {})

	local v24 = React.useCallback(function(cursorPosition)
		if ref.current then
			ref.current.CursorPosition = cursorPosition
		end

		if ref2.current then
			ref2.current.CursorPosition = cursorPosition
		end
	end, {})

	local v25 = React.useCallback(function()
		local current = ref.current or ref2.current

		if current == nil or current.Parent == nil then
			return
		end

		local v26 = utf8.len(current.Text)

		if v26 then
			v23(0)
			v24(v26 + 1)
		end
	end, { v23, v24 })

	local v26 = React.useCallback(function()
		if ref.current == nil then
			return
		end

		ref.current:CaptureFocus()

		if v6.focusBehavior == InputFocusBehavior.Highlight then
			task.spawn(v25)
		end
	end, { v25, v6.focusBehavior })

	local v27 = React.useCallback(function()
		if ref.current then
			ref.current:ReleaseFocus()
		end

		if ref2.current then
			ref2.current:ReleaseFocus()
		end

		setState3(false)
		setState2(false)
	end, {})

	local v28 = React.useCallback(function()
		if ref.current then
			return ref.current:IsFocused()
		end

		return nil
	end, {})

	local v29 = React.useCallback(function()
		if ref.current then
			return ref.current.SelectionStart
		end

		return nil
	end, {})

	local v30 = React.useCallback(function()
		if ref.current then
			return ref.current.CursorPosition
		end

		return nil
	end, {})

	local v31 = React.useCallback(function()
		if ref.current then
			ref.current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p3, function()
		return {
			getIsFocused = v28,
			focus = v26,
			releaseFocus = v27,
			setHover = setState,
			getSelectionStart = v29,
			getCursorPosition = v30,
			setCursorPosition = v24,
			setSelectionStart = v23
		}
	end, { v30, v28, v29, v26, v27, v24, v23 })

	local v32 = React.useCallback(function(instance)
		if instance == nil or instance.Parent == nil or ref5.current ~= "" then
			return
		end

		local text = instance.Text

		if ref9.current and text ~= "" or text == ref6.current then
			return
		end

		ref6.current = text

		if v22 and ref3.current then
			ref3.current.Text = text
		end

		if v18 then
			setState6(text)
		end

		if v6.maxLines then
			setState4(v20(text))
			task.defer(function()
				setState4(v20(text))
			end)
		end

		v6.onChanged(text)
	end, { v6.onChanged, v22, state3, v6.maxLines, v20, v18 })

	local ref11 = React.useRef(false)

	local v33 = React.useCallback(function(p4, p5)
		if p5.UserInputType == Enum.UserInputType.MouseMovement then
			ref11.current = false
		end
	end, {})

	local v34 = React.useCallback(function(p4, p5)
		if not ref11.current then
			return
		end

		ref11.current = false

		if p5.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v25()
	end, { v23, v24, v25 })

	local v35 = React.useCallback(function(current)
		ref6.current = current

		if v18 then
			setState6(current)
		end

		if v6.maxLines then
			setState4(v20(current))
		end

		v6.onChanged(current)
	end, { v6.maxLines, v20, v6.onChanged, v18 })

	local v36 = not (v6.onReturnPressed == nil) and not v15

	local v37 = React.useCallback(function(p4, p5)
		if v6.onReturnPressed == nil then
			return
		end

		local now = os.clock()

		if now - ref10.current < 0.15 then
			chatTextAreaDebug.log("returnSubmit", `source={p5} skipped=debounced`)
			return
		end

		chatTextAreaDebug.log("returnSubmit", `source={p5}`)
		ref10.current = now
		ref9.current = true
		v6.onReturnPressed()

		task.delay(0.15, function()
			ref9.current = false
		end)
	end, { v6.onReturnPressed })

	local v38 = React.useCallback(function(p4, p5)
		local current = ref.current

		if current == nil or current:IsFocused() ~= true then
			return
		end

		if not p5 then
			v37(current, "UserInputService.InputBegan")
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

				v35(text2)
			end
		end)
	end, { v37, v35 })

	local v39 = useComposerKeyboardConnections({
		enabled = v36 == true,
		onReturnPressed = v38
	})

	local connect = v39.connect
	local disconnect = v39.disconnect

	local v40 = React.useCallback(function()
		if isDisabled then
			return
		end

		if v22 and v15 then
			if ref.current and ref.current.Parent then
				ref5.current = ref.current.Text
			end

			setState3(true)
		end

		setState2(true)

		if v6.onFocus then
			v6.onFocus()
		end

		if v36 then
			connect()
		end

		local focusBehavior = v6.focusBehavior

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
	end, { v6.onFocus, isDisabled, v15, v22, v6.focusBehavior, v36, connect })

	local v41 = React.useCallback(function(p4, p5)
		v34(p4, p5)
	end, { v34 })

	local v42 = React.useCallback(function(p4, p5, p6)
		chatTextAreaDebug.log("textBox.FocusLost", `enterPressed={p5}`)

		if v36 then
			disconnect()
		end

		setState2(false)
		ref11.current = false

		if v22 then
			setState3(false)
		end

		if v6.onFocusLost then
			v6.onFocusLost(p6)
		end

		if p5 and v36 then
			v37(p4, "TextBox.FocusLost")
		end
	end, { v22, v6.onFocusLost, v36, v37, disconnect })

	local v43 = React.useCallback(function(p4)
		setState(p4 == ControlState.Hover)
	end, {})

	local v44 = React.useCallback(function(p4, current)
		ref7.current = current

		if v6.onDragStarted then
			v6.onDragStarted(p4, current)
		end
	end, { v6.onDragStarted })

	local v45 = React.useCallback(function(p4, p5)
		if v6.onDrag then
			v6.onDrag(p4, p5)
		end
	end, { v6.onDrag })

	local v46 = React.useCallback(function(p4, p5)
		if ref7.current == p5 then
			v26()
		else
			v27()
			setState2(false)
		end

		ref7.current = nil

		if v6.onDragEnded then
			v6.onDragEnded(p4, p5)
		end
	end, { v6.onDragEnded, v26, v27 })

	local v47 = if v6.maxLines then getMultiLineTextHeight(fontSize, v6.maxLines, lineHeight) else nil

	local v48 = React.useMemo(function()
		if v6.maxLines then
			return (math.clamp(math.max(multiLineTextHeight, state5), multiLineTextHeight, v47))
		end

		return getMultiLineTextHeight(fontSize, state4, lineHeight)
	end, { v6.maxLines, multiLineTextHeight, state5, v47, fontSize, state4, lineHeight })

	local v49 = React.useMemo(function()
		local multiLineTextHeight2 = getMultiLineTextHeight(fontSize, 1, lineHeight)
		local v50 = multiLineTextHeight2 + math.round(math.round((container.minHeight - v16 - multiLineTextHeight2) * 2) / 2) + v16
		return UDim.new(0, (math.ceil(v50 / 2)))
	end, { container.minHeight, v16, fontSize, lineHeight })

	local v50 = React.useMemo(function()
		if v6.maxLines then
			return v49
		end

		if v6.radius == Radius.Circle then
			return UDim.new(0, (math.ceil(container.minHeight / 2)))
		end

		return nil
	end, { v6.maxLines, v49, container.minHeight, v6.radius })

	local v51 = React.useMemo(function()
		local v53 = if v50 then v50 else UDim.new(0, container.radius)
		return { radius = v53, offset = v7.Stroke.Thick, borderWidth = v7.Stroke.Thick }
	end, { v7, container.radius, v50 })

	local v52, v53 = React.useMemo(function()
		local v54 = math.round((container.minHeight - v16 - getMultiLineTextHeight(fontSize, 1, lineHeight)) * 2) / 2

		local udim = UDim.new(0, (math.floor(v54 / 2)))
		local udim2 = UDim.new(0, (math.ceil(v54 / 2)))
		local v55 = v48 + math.round(v54) + v16

		return {
			top = udim,
			bottom = udim2,
			left = UDim.new(0, 0),
			right = UDim.new(0, 0)
		}, v55
	end, { container.minHeight, v16, v17, fontSize, v48, lineHeight })

	local v54 = v52.bottom.Offset + v52.top.Offset
	local textPaddingOnParent = v6.textPaddingOnParent == true
	local v55 = if not textPaddingOnParent then v52 else nil
	local v56 = if textPaddingOnParent then v48 else v48 + v54
	local v57 = if v22 then not (v6.maxLines == nil) and not state3 else v22

	local v58 = if textPaddingOnParent then state5 else state5 + v54

	local v59 = if v57 then math.max(v56, v58) else v56

	local v60 = if textPaddingOnParent then v59 + v54 else v59

	local udim = UDim2.new(1, 0, 0, v59)
	local udim2 = UDim2.new(1, 0, 0, v56)

	React.useEffect(function()
		if v6.maxLines then
			chatTextAreaDebug.log("layout", `lineCount={state4} borderFrameHeight={v53}`)
		end

		return function() end
	end, { state4, v53, v6.maxLines })

	local v61 = React.useMemo(function()
		if not v22 then
			return nil
		end

		local v62 = {
			FillDirection = Enum.FillDirection.Vertical,
			ItemLineAlignment = 0
		}
		local v63 = if v6.maxLines == nil then Enum.ItemLineAlignment.Center else Enum.ItemLineAlignment.Start
		v62.ItemLineAlignment = v63
		return v62
	end, { v22, v6.maxLines })

	local v62 = React.useMemo(function()
		if v22 then
			return {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always
			}
		end

		return nil
	end, { v22 })

	local v63 = React.useCallback(function(p4)
		local current = ref4.current
		local current2 = ref3.current

		if current == nil or current2 == nil then
			return
		end

		local v64 = p4.TextSize * p4.LineHeight
		local y = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p4)
		local y2 = current2.TextBounds.Y

		local v65 = y - v52.top.Offset + v52.bottom.Offset

		local v66 = y + current.AbsoluteSize.Y - v52.top.Offset - v52.bottom.Offset

		if y2 - v64 < v65 then
			current.CanvasPosition += Vector2.new(0, y2 - v64 - v65)
		end

		if v66 < y2 then
			current.CanvasPosition += Vector2.new(0, y2 - v66)
		end
	end, { v52 })

	local v64 = React.useCallback(function(current)
		if current == nil then
			return
		end

		ref4.current = current
		current.ClipsDescendants = true
		current.CanvasPosition = ref8.current
	end, {})

	local v65 = React.useCallback(function(object)
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

	local v66 = React.useCallback(function(p4)
		ref8.current = p4.CanvasPosition
	end, {})

	local v67 = React.useMemo(function()
		if not (v6.onDragStarted or v6.onDrag or v6.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v44,
			[React.Event.DragContinue] = v45,
			[React.Event.DragEnd] = v46,
			Enabled = not (state2 or isDisabled)
		})
	end, {
		v44,
		v45,
		v46,
		state2,
		isDisabled,
		v6.onDragStarted,
		v6.onDrag,
		v6.onDragEnded
	})
	local v69

	if v6.horizontalPadding then
		v69 = v6.horizontalPadding.left or UDim.new(0, 0)
	else
		v69 = UDim.new(0, 0)
	end

	local v70 = useBindable(v69)
	local v72

	if v6.horizontalPadding then
		v72 = v6.horizontalPadding.right or UDim.new(0, 0)
	else
		v72 = UDim.new(0, 0)
	end

	local v73 = useBindable(v72)

	local v74 = React.useMemo(function()
		if v6.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v7.Stroke.Standard) / 2))
		end

		return nil
	end, { v6.hasClearButton, container.minHeight, v7.Stroke.Standard })

	local v75 = ReactUtils.useComposedRef(ref2, v65)

	local createElement = React.createElement

	local v78 = {
		Size = UDim2.new(1, 0, 0, v53),
		selection = {
			Selectable = v6.Selectable and not isDisabled,
			NextSelectionUp = v6.NextSelectionUp,
			NextSelectionDown = v6.NextSelectionDown,
			NextSelectionLeft = v6.NextSelectionLeft,
			NextSelectionRight = v6.NextSelectionRight
		},
		cursor = v51,
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
	local v79

	if v11 and container.strokeThickness then
		v79 = {
			Color = v11.Color3,
			Transparency = 0,
			Thickness = 0,
			BorderStrokePosition = 0
		}

		local v80 = if isDisabled then blendTransparencies(
			v11.Transparency,
			Constants.DISABLED_TRANSPARENCY
		) else v11.Transparency
		v79.Transparency = v80

		v79.Thickness = container.strokeThickness

		local v81 = if state2 or state then Enum.BorderStrokePosition.Center else Enum.BorderStrokePosition.Inner
		v79.BorderStrokePosition = v81
	end

	v78.stroke = v79

	v78.cornerRadius = v50
	local v80 = {
		left = v70:map(function(p4)
			return UDim.new(0, standard) + p4
		end),
		right = 0,
		top = 0,
		bottom = 0
	}
	local v81

	if v6.trailingElement == nil and v6.hasClearButton then
		v81 = UDim.new(0, standard)
	else
		v81 = v73:map(function(p4)
			return UDim.new(0, standard) + p4
		end)
	end

	v80.right = v81

	v80.top = UDim.new(0, standard)
	v80.bottom = UDim.new(0, standard)
	v78.padding = v80

	v78.onActivated = if not isDisabled then v26 else nil
	v78.onStateChanged = v43
	v78.isDisabled = v13
	local v83 = if container.bgStyle then getDisabledStyle({
		Color3 = container.bgStyle.Color3,
		Transparency = v6.backgroundGradient and 0 or container.bgStyle.Transparency
	}, v13) else nil
	v78.backgroundStyle = v83

	v78.stateLayer = { affordance = StateLayerAffordance.None }
	v78.layout = v9 ~= nil
		and {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v9),
			SortOrder = Enum.SortOrder.LayoutOrder
		}
		or nil

	v78.tag = v10
	v78.testId = `{v6.testId}--outer-container`
	local v84 = withCommonProps(v6, v78)

	local v85 = {
		DragDetector = v67,
		Background = v6.backgroundGradient,
		Leading = 0,
		TextBoxWrapper = 0,
		Clear = 0,
		Trailing = 0
	}
	local v86

	if v6.leadingElement then
		local createElement2 = React.createElement
		local v89 = if v13 then Constants.DISABLED_TRANSPARENCY else nil
		v86 = createElement2(
			View,
			{
				GroupTransparency = v89,
				LayoutOrder = 1,
				tag = "col align-y-bottom self-stretch size-0-full auto-x",
				testId = `{v6.testId}--leading`
			},
			v6.leadingElement
		)
	end

	v85.Leading = v86

	local createElement2 = React.createElement
	local v87 = if v22 then ScrollView else View

	if not v22 then
		v66 = nil
	end

	if not v22 then
		v64 = nil
	end

	local createElement3 = React.createElement
	local v92 = if v57 then UDim2.new(1, 0, 0, v60) else nil
	local v91 = {
		Size = v92,
		tag = {
			["fill size-full"] = not v57
		},
		padding = if textPaddingOnParent then v52 else nil,
		selection = { Selectable = false },
		onActivated = if not isDisabled then v26 else nil,
		stateLayer = { affordance = StateLayerAffordance.None }
	}
	local v96

	if not state3 then
		local createElement4 = React.createElement
		local v98 = {
			text = v21,
			placeholder = v6.placeholder,
			textInputType = v6.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = v22,
			isDisabled = isDisabled,
			ref = ref,
			tag = `{v12 or ""} data-testid={v6.testId}--textbox`,
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

		if not v22 then
			udim = nil
		end

		v98.Size = udim
		local v99

		if not v6.maxLines then
			if v18 then
				if v22 and not state3 and state6 ~= "" then
					v99 = Enum.AutomaticSize.Y
				end
			else
				v99 = mapBindable(v6.text, function(p4)
					if v22 and not state3 and p4 ~= "" then
						return Enum.AutomaticSize.Y
					end

					return nil
				end)
			end
		end

		v98.automaticSize = v99

		v98.padding = v55
		v98.onFocusGained = v40
		local v100 = if not (v22 and v15) then v42 else nil
		v98.onFocusLost = v100
		v98.onTextChanged = v32
		v98.onCursorPositionChanged = if v22 then v63 else nil
		v98.onInputChanged = v33
		v98.onInputEnded = v41
		local v102 = if v15 then v6.manualFocusRelease else nil
		v98.manualFocusRelease = v102
		v98.shouldEmitReturnEvents = v15
			and v6.manualFocusRelease == true
			and v6.alwaysMultiLine == true
			and true
			or nil
		local v104

		if v22 then
			local createElement5 = React.createElement
			local v106 = {
				isBoundsChecker = true,
				fontStyle = fontStyle,
				textStyle = disabledStyle,
				Size = 0,
				ref = 0
			}

			local v107 = if textPaddingOnParent then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 1, v54)
			v106.Size = v107

			v106.ref = ref3
			v104 = createElement5(memo, v106)
		end

		v96 = createElement4(memo, v98, { DragDetector = v67, BoundsChecker = v104 })
	end

	local v97

	if v22 and state3 then
		local createElement4 = React.createElement
		local v99 = {
			text = v21,
			placeholder = v6.placeholder,
			textInputType = v6.textInputType,
			fontStyle = fontStyle,
			textStyle = disabledStyle,
			isMultiLine = v22,
			isDisabled = isDisabled,
			padding = v55,
			ref = v75,
			tag = `{v12 or ""} data-testid={v6.testId}--mobile-textbox`,
			Size = udim2,
			onFocusLost = 0,
			onTextChanged = 0,
			onCursorPositionChanged = 0,
			onInputEnded = 0,
			manualFocusRelease = 0,
			shouldEmitReturnEvents = 0,
			overlayNativeInput = nil
		}

		if not (v22 and v15) then
			v42 = nil
		end

		v99.onFocusLost = v42
		v99.onTextChanged = v32

		if not v22 then
			v63 = nil
		end

		v99.onCursorPositionChanged = v63
		v99.onInputEnded = v41
		local v100 = if v15 then v6.manualFocusRelease else nil
		v99.manualFocusRelease = v100
		v99.shouldEmitReturnEvents = v15
			and v6.manualFocusRelease == true
			and v6.alwaysMultiLine == true
			and true
			or nil
		v97 = createElement4(memo, v99)
	end

	v85.TextBoxWrapper = createElement2(v87, {
		LayoutOrder = 2,
		selection = { Selectable = false },
		scroll = v62,
		layout = v61,
		onCanvasPositionChanged = v66,
		scrollingFrameRef = v64,
		tag = "fill size-full clip"
	}, {
		TextContent = createElement3(View, v91, { TextBox = v96, MobileTextBox = v97 })
	})
	local v98

	if v6.hasClearButton then
		local createElement4 = React.createElement
		local v100 = {
			isDisabled = isDisabled,
			GroupTransparency = 0,
			LayoutOrder = 3,
			Visible = 0,
			tag = 0
		}

		local v101 = if isDisabled then Constants.DISABLED_TRANSPARENCY else nil
		v100.GroupTransparency = v101

		v100.Visible = mapBindable(v6.text, function(p4): boolean
			return p4 ~= ""
		end)

		v100.tag = v8.clearButton.tag
		v98 = createElement4(View, v100, {
			ClearButton = React.createElement(View, {
				onActivated = v31,
				padding = UDim.new(0, v8.clearButton.padding),
				Position = v74,
				stateLayer = { affordance = StateLayerAffordance.None },
				tag = "anchor-center-left auto-xy",
				testId = `{v6.testId}--clear-button`
			}, {
				Icon = React.createElement(Icon, { name = v8.clearButton.icon })
			})
		})
	end

	v85.Clear = v98
	local v99

	if v6.trailingElement then
		local createElement4 = React.createElement
		local v102 = if v13 then Constants.DISABLED_TRANSPARENCY else nil
		v99 = createElement4(View, {
			GroupTransparency = v102,
			LayoutOrder = 4,
			tag = {
				["col align-y-bottom self-stretch size-0-full auto-x"] = v6.trailingAlignBottom == true,
				["row align-y-center size-0-full auto-x"] = v6.trailingAlignBottom ~= true
			},
			testId = `{v6.testId}--trailing`
		}, v6.trailingElement)
	end

	v85.Trailing = v99
	return createElement(View, v84, v85)
end

return React.memo(React.forwardRef(InternalTextInput))
