local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactUtils = require(FoundationParent.ReactUtils)
local Components = Foundation.Components
local Icon = require(Components.Icon)
local Padding = require(Components.Padding)
local ScrollView = require(Components.ScrollView)

require(Components.Types)

local View = require(Components.View)
local Constants = require(Foundation.Constants)
local blendTransparencies = require(Foundation.Utility.blendTransparencies)
local getBindableValue = require(Foundation.Utility.getBindableValue)
local getDisabledStyle = require(Foundation.Utility.getDisabledStyle)
local getMultiLineTextHeight = require(Foundation.Utility.getMultiLineTextHeight)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local mapBindable = require(Foundation.Utility.mapBindable)
local truncateTextToCursor = require(Foundation.Components.InternalTextInput.truncateTextToCursor)
local chatTextAreaDebug = require(script.Parent.chatTextAreaDebug)
local measureTextLineCount = require(script.Parent.measureTextLineCount)
local useComposerFocusLock = require(script.Parent.useComposerFocusLock)
local useComposerKeyboardConnections = require(script.Parent.useComposerKeyboardConnections)
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
local ControlState = require(Foundation.Enums.ControlState)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local t1 = {
	numLines = 1,
	testId = "--foundation-internal-text-input",
	Selectable = true,
	size = InputSize.Large,
	variant = InputVariant.Standard
}
local v36 = React.memo(React.forwardRef(function(t2: {[any]: any}, p1) -- line: 142
	-- upvalues: React (copy), isPluginSecurity (copy), Padding (copy)
	local isBoundsChecker = t2.isBoundsChecker
	local v41 = t2.isMultiLine or isBoundsChecker

	return React.createElement("TextBox", {
		ClearTextOnFocus = false,
		Selectable = false,
		Active = not isBoundsChecker and nil,
		Visible = not isBoundsChecker and nil,
		Font = t2.fontStyle.Font,
		TextSize = t2.fontStyle.FontSize,
		LineHeight = t2.fontStyle.LineHeight,
		TextColor3 = if not t2.textStyle then nil else t2.textStyle.Color3,
		TextTransparency = if not t2.textStyle then nil else t2.textStyle.Transparency,
		MultiLine = v41,
		TextWrapped = v41,
		TextYAlignment = if not v41 then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top,
		TextEditable = not isBoundsChecker and not t2.isDisabled,
		PlaceholderText = t2.placeholder,
		TextInputType = if not isPluginSecurity() then nil else t2.textInputType,
		ManualFocusRelease = not not t2.manualFocusRelease or nil,
		ShouldEmitReturnEvents = not not t2.shouldEmitReturnEvents or nil,
		OverlayNativeInput = not not t2.overlayNativeInput or nil,
		Size = if t2.Size == nil then UDim2.fromScale(1, 1) else t2.Size,
		AutomaticSize = t2.automaticSize,
		Text = if not isBoundsChecker then if typeof(t2.text) ~= "string" then t2.text else t2.text else nil,
		ref = p1,
		[React.Tag] = t2.tag,
		[React.Change.Text] = t2.onTextChanged,
		[React.Change.CursorPosition] = t2.onCursorPositionChanged,
		[React.Event.Focused] = t2.onFocusGained,
		[React.Event.FocusLost] = t2.onFocusLost,
		[React.Event.InputChanged] = t2.onInputChanged,
		[React.Event.InputEnded] = t2.onInputEnded
	}, if not t2.padding then nil else {
		Padding = React.createElement(Padding, {
			value = t2.padding
		})
	}, t2.children)
end))

local function InternalTextInput(p2, p3) -- line: 191
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), getBindableValue (copy), useTextInputVariants (copy), useStyleTags (copy), usePreferredInput (copy), useComposerFocusLock (copy), getDisabledStyle (copy), getMultiLineTextHeight (copy), chatTextAreaDebug (copy), measureTextLineCount (copy), InputFocusBehavior (copy), useComposerKeyboardConnections (copy), ControlState (copy), Radius (copy), truncateTextToCursor (copy), useBindable (copy), ReactUtils (copy), View (copy), withCommonProps (copy), blendTransparencies (copy), Constants (copy), StateLayerAffordance (copy), ScrollView (copy), v36 (copy), mapBindable (copy), Icon (copy)
	if p2.Selectable == nil then
		p2 = table.clone(p2)
		p2.Selectable = true
	end

	local v44 = withDefaults(p2, t1)
	local v45 = useTokens()
	local v46 = React.useRef(nil)
	local v47 = React.useRef(nil)
	local v48 = React.useRef(nil)
	local v49 = React.useRef(nil)
	local v50 = React.useRef("")
	local v51 = React.useRef(getBindableValue(v44.text))
	local v52 = React.useRef(nil)
	local v53 = React.useRef(Vector2.zero)
	local v54 = React.useRef(false)
	local v55 = React.useRef(0)
	local v56, v57 = React.useState(false)
	local v58, v59 = React.useState(false)
	local v60 = useTextInputVariants(v45, v44.size, v44.variant, v44.radius, v58, v44.hasError)
	local container = v60.container
	local v62 = if not v44.trailingElement or typeof(container.tag) ~= "string" then container.tag else string.gsub(container.tag, "gap%-large", "gap-xsmall")
	local v63 = useStyleTags(v60.textBox.tag)
	local isDisabled = v44.isDisabled
	local v65 = v44.isDisabled and v44.trailingElement == nil
	local v66 = usePreferredInput()
	local v67, v68 = React.useState(false)
	local v69 = v66 == Enum.PreferredInput.Touch
	local Standard = v45.Stroke.Standard
	local v71 = math.ceil(Standard) * 2
	local v72 = math.ceil(v45.Stroke.Thick) * 2

	useComposerFocusLock(isDisabled == true, {
		v46,
		v47
	})

	local v73 = getDisabledStyle(v45.Color.Content.Emphasis, isDisabled)
	local fontStyle = v60.textBox.fontStyle
	local FontSize = fontStyle.FontSize
	local LineHeight = fontStyle.LineHeight
	local v77 = getMultiLineTextHeight(FontSize, 1, LineHeight)
	local v78, v79 = React.useState(1)
	local v80, v81 = React.useState(v77)
	local v82 = v44.maxLines ~= nil
	local v83, v84 = React.useState(function() -- line: 246
		-- upvalues: getBindableValue (copy), v44 (copy)
		return getBindableValue(v44.text)
	end)

	React.useEffect(function() -- line: 250
		-- upvalues: chatTextAreaDebug (copy), v44 (copy)
		chatTextAreaDebug.setEnabled(v44.composerDebug == true)

		return function() -- line: 252
		end
	end, { v44.composerDebug })

	local v85 = React.useCallback(function() -- line: 255
		-- upvalues: v46 (copy), v47 (copy)
		local v145 = v46.current or v47.current

		if v145 and v145.AbsoluteSize.X > 0 then
			return v145.AbsoluteSize.X
		end

		return 0
	end, {})
	local v86 = React.useCallback(function(s1: string) -- line: 264
		-- upvalues: measureTextLineCount (copy), v44 (copy), v77 (copy), v85 (copy), fontStyle (copy), FontSize (copy), v81 (copy)
		local v147 = measureTextLineCount({
			text = s1,
			maxLines = v44.maxLines,
			singleLineHeight = v77,
			layoutWidth = v85(),
			font = fontStyle.Font,
			fontSize = FontSize
		})
		local v148 = if not v147.boundsY or not (v147.boundsY > 0) then v77 else math.ceil(v147.boundsY)

		v81((math.max(v148, v147.lineCount * v77)))

		return v147.lineCount
	end, {
		FontSize,
		LineHeight,
		fontStyle.Font,
		v44.maxLines,
		v85,
		v77
	})
	local v87 = if not v82 then getBindableValue(v44.text) else v44.text
	local v88 = if not v44.maxLines then math.max(1, v44.numLines) else v78
	local v89 = not not v44.alwaysMultiLine or v88 > 1

	React.useEffect(function() -- line: 295
		-- upvalues: v82 (copy), getBindableValue (copy), v44 (copy), v51 (copy), chatTextAreaDebug (copy), v84 (copy), v79 (copy), v86 (copy)
		if not v82 then
			return function() -- line: 297
			end
		end

		local v149 = getBindableValue(v44.text)

		if v149 ~= v51.current then
			chatTextAreaDebug.log("syncFromParent", `len={ utf8.len(v149) or #v149 }`)
			v51.current = v149
			v84(v149)
			v79(v86(v149))
			task.defer(function() -- line: 305
				-- upvalues: v79 (copy), v86 (copy), v149 (copy)
				v79(v86(v149))
			end)
		end

		return function() -- line: 309
		end
	end, {
		v44.text,
		v86,
		v82
	})

	local v90 = React.useCallback(function(p4) -- line: 312
		-- upvalues: v46 (copy), v47 (copy)
		if v46.current then
			v46.current.SelectionStart = p4
		end

		if v47.current then
			v47.current.SelectionStart = p4
		end
	end, {})
	local v91 = React.useCallback(function(p5) -- line: 321
		-- upvalues: v46 (copy), v47 (copy)
		if v46.current then
			v46.current.CursorPosition = p5
		end

		if v47.current then
			v47.current.CursorPosition = p5
		end
	end, {})
	local v92 = React.useCallback(function() -- line: 330
		-- upvalues: v46 (copy), v47 (copy), v90 (copy), v91 (copy)
		local v152 = v46.current or v47.current

		if v152 == nil or v152.Parent == nil then
			return
		end

		local v153 = utf8.len(v152.Text)

		if v153 then
			v90(0)
			v91(v153 + 1)
		end
	end, {
		v90,
		v91
	})
	local v93 = React.useCallback(function() -- line: 344
		-- upvalues: v46 (copy), v44 (copy), InputFocusBehavior (copy), v92 (copy)
		if v46.current == nil then
			return
		end

		v46.current:CaptureFocus()

		if v44.focusBehavior == InputFocusBehavior.Highlight then
			task.spawn(v92)
		end
	end, {
		v92,
		v44.focusBehavior
	})
	local v94 = React.useCallback(function() -- line: 361
		-- upvalues: v46 (copy), v47 (copy), v68 (copy), v59 (copy)
		if v46.current then
			v46.current:ReleaseFocus()
		end

		if v47.current then
			v47.current:ReleaseFocus()
		end

		v68(false)
		v59(false)
	end, {})
	local v95 = React.useCallback(function() -- line: 372
		-- upvalues: v46 (copy)
		if v46.current then
			return (v46.current:IsFocused())
		end

		return nil
	end, {})
	local v96 = React.useCallback(function() -- line: 379
		-- upvalues: v46 (copy)
		if v46.current then
			return v46.current.SelectionStart
		end

		return nil
	end, {})
	local v97 = React.useCallback(function() -- line: 386
		-- upvalues: v46 (copy)
		if v46.current then
			return v46.current.CursorPosition
		end

		return nil
	end, {})
	local v98 = React.useCallback(function() -- line: 393
		-- upvalues: v46 (copy)
		if v46.current then
			v46.current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p3, function() -- line: 401
		-- upvalues: v95 (copy), v93 (copy), v94 (copy), v57 (copy), v96 (copy), v97 (copy), v91 (copy), v90 (copy)
		return {
			getIsFocused = v95,
			focus = v93,
			releaseFocus = v94,
			setHover = v57,
			getSelectionStart = v96,
			getCursorPosition = v97,
			setCursorPosition = v91,
			setSelectionStart = v90
		}
	end, {
		v97,
		v95,
		v96,
		v93,
		v94,
		v91,
		v90
	})

	local v99 = React.useCallback(function(p6) -- line: 425
		-- upvalues: v50 (copy), v54 (copy), v51 (copy), v89 (copy), v48 (copy), v82 (copy), v84 (copy), v44 (copy), v79 (copy), v86 (copy)
		if p6 == nil or (p6.Parent == nil or v50.current ~= "") then
			return
		end

		local p6Text = p6.Text

		if v54.current and p6Text ~= "" then
			return
		end

		if p6Text == v51.current then
			return
		end

		v51.current = p6Text

		if v89 and v48.current then
			v48.current.Text = p6Text
		end

		if v82 then
			v84(p6Text)
		end

		if v44.maxLines then
			v79(v86(p6Text))
			task.defer(function() -- line: 451
				-- upvalues: v79 (copy), v86 (copy), p6Text (copy)
				v79(v86(p6Text))
			end)
		end

		v44.onChanged(p6Text)
	end, {
		v44.onChanged,
		v89,
		v67,
		v44.maxLines,
		v86,
		v82
	})
	local v100 = React.useRef(false)
	local v101 = React.useCallback(function(_, p8) -- line: 463
		-- upvalues: v100 (copy)
		if p8.UserInputType == Enum.UserInputType.MouseMovement then
			v100.current = false
		end
	end, {})
	local v102 = React.useCallback(function(_, p10) -- line: 470
		-- upvalues: v100 (copy), v92 (copy)
		if not v100.current then
			return
		end

		v100.current = false

		if p10.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v92()
	end, {
		v90,
		v91,
		v92
	})
	local v103 = React.useCallback(function(s2: string) -- line: 489
		-- upvalues: v51 (copy), v82 (copy), v84 (copy), v44 (copy), v79 (copy), v86 (copy)
		v51.current = s2

		if v82 then
			v84(s2)
		end

		if v44.maxLines then
			v79(v86(s2))
		end

		v44.onChanged(s2)
	end, {
		v44.maxLines,
		v86,
		v44.onChanged,
		v82
	})
	local v104 = v44.onReturnPressed ~= nil and not v69
	local v105 = React.useCallback(function(_, s3: string) -- line: 502
		-- upvalues: v44 (copy), v55 (copy), chatTextAreaDebug (copy), v54 (copy)
		if v44.onReturnPressed == nil then
			return
		end

		local elapsed = os.clock()

		if elapsed - v55.current < 0.15 then
			chatTextAreaDebug.log("returnSubmit", `source={ s3 } skipped=debounced`)

			return
		end

		chatTextAreaDebug.log("returnSubmit", `source={ s3 }`)
		v55.current = elapsed
		v54.current = true
		v44.onReturnPressed()
		task.delay(0.15, function() -- line: 518
			-- upvalues: v54 (copy)
			v54.current = false
		end)
	end, { v44.onReturnPressed })
	local v106 = React.useCallback(function(_: boolean, b2: boolean) -- line: 523
		-- upvalues: v46 (copy), chatTextAreaDebug (copy), v103 (copy), v105 (copy)
		local current = v46.current

		if current == nil or current:IsFocused() ~= true then
			return
		end

		if b2 then
			local currentText = current.Text

			task.defer(function() -- line: 531
				-- upvalues: current (copy), currentText (copy), chatTextAreaDebug (copy), v103 (copy)
				if current.Parent == nil then
					return
				end

				local currentText2 = current.Text

				if currentText2 ~= currentText then
					chatTextAreaDebug.log("returnNewline", "source=UserInputService.InputBegan-shift engineInserted=true")
					v103(currentText2)
				end
			end)

			return
		end

		v105(current, "UserInputService.InputBegan")
	end, {
		v105,
		v103
	})
	local v107 = useComposerKeyboardConnections({
		enabled = v104 == true,
		onReturnPressed = v106
	})
	local connect = v107.connect
	local disconnect = v107.disconnect
	local v110 = React.useCallback(function() -- line: 560
		-- upvalues: isDisabled (copy), v89 (copy), v69 (copy), v46 (copy), v50 (copy), v68 (copy), v59 (copy), v44 (copy), v104 (copy), connect (copy), InputFocusBehavior (copy), v47 (copy), v100 (copy)
		if isDisabled then
			return
		end

		if v89 and v69 then
			if v46.current and v46.current.Parent then
				v50.current = v46.current.Text
			end

			v68(true)
		end

		v59(true)

		if v44.onFocus then
			v44.onFocus()
		end

		if v104 then
			connect()
		end

		local focusBehavior = v44.focusBehavior

		if focusBehavior == InputFocusBehavior.Clear then
			v50.current = ""

			if v46.current then
				v46.current.Text = ""
			end

			if v47.current then
				v47.current.Text = ""

				return
			end
		elseif focusBehavior == InputFocusBehavior.Highlight then
			v100.current = true
		end
	end, {
		v44.onFocus,
		isDisabled,
		v69,
		v89,
		v44.focusBehavior,
		v104,
		connect
	})
	local v111 = React.useCallback(function(p12, p13) -- line: 608
		-- upvalues: v102 (copy)
		v102(p12, p13)
	end, { v102 })
	local v112 = React.useCallback(function(p14, b3: boolean, p15) -- line: 613
		-- upvalues: chatTextAreaDebug (copy), v104 (copy), disconnect (copy), v59 (copy), v100 (copy), v89 (copy), v68 (copy), v44 (copy), v105 (copy)
		chatTextAreaDebug.log("textBox.FocusLost", `enterPressed={ b3 }`)

		if v104 then
			disconnect()
		end

		v59(false)
		v100.current = false

		if v89 then
			v68(false)
		end

		if v44.onFocusLost then
			v44.onFocusLost(p15)
		end

		if b3 and v104 then
			v105(p14, "TextBox.FocusLost")
		end
	end, {
		v89,
		v44.onFocusLost,
		v104,
		v105,
		disconnect
	})
	local v113 = React.useCallback(function(p16) -- line: 644
		-- upvalues: v57 (copy), ControlState (copy)
		v57(p16 == ControlState.Hover)
	end, {})
	local v114 = React.useCallback(function(p17, vector2: Vector2) -- line: 648
		-- upvalues: v52 (copy), v44 (copy)
		v52.current = vector2

		if v44.onDragStarted then
			v44.onDragStarted(p17, vector2)
		end
	end, { v44.onDragStarted })
	local v115 = React.useCallback(function(p18, vector2: Vector2) -- line: 655
		-- upvalues: v44 (copy)
		if v44.onDrag then
			v44.onDrag(p18, vector2)
		end
	end, { v44.onDrag })
	local v116 = React.useCallback(function(p19, vector2: Vector2) -- line: 661
		-- upvalues: v52 (copy), v93 (copy), v94 (copy), v59 (copy), v44 (copy)
		if vector2 == v52.current then
			v93()
		else
			v94()
			v59(false)
		end

		v52.current = nil

		if v44.onDragEnded then
			v44.onDragEnded(p19, vector2)
		end
	end, {
		v44.onDragEnded,
		v93,
		v94
	})
	local v117 = if not v44.maxLines then nil else getMultiLineTextHeight(FontSize, v44.maxLines, LineHeight)
	local v118 = React.useMemo(function() -- line: 678
		-- upvalues: v44 (copy), v77 (copy), v80 (copy), v117 (copy), getMultiLineTextHeight (copy), FontSize (copy), v88 (copy), LineHeight (copy)
		if v44.maxLines then
			return (math.clamp(math.max(v77, v80), v77, v117))
		end

		return getMultiLineTextHeight(FontSize, v88, LineHeight)
	end, {
		v44.maxLines,
		v77,
		v80,
		v117,
		FontSize,
		v88,
		LineHeight
	})
	local v119 = React.useMemo(function() -- line: 700
		-- upvalues: getMultiLineTextHeight (copy), FontSize (copy), LineHeight (copy), container (copy), v71 (copy)
		local v181 = getMultiLineTextHeight(FontSize, 1, LineHeight)
		local v182 = v181 + math.round(math.round((container.minHeight - v71 - v181) * 2) / 2) + v71

		return UDim.new(0, (math.ceil(v182 / 2)))
	end, {
		container.minHeight,
		v71,
		FontSize,
		LineHeight
	})
	local v120 = React.useMemo(function() -- line: 709
		-- upvalues: v44 (copy), v119 (copy), Radius (copy), container (copy)
		if v44.maxLines then
			return v119
		end

		if v44.radius == Radius.Circle then
			return UDim.new(0, (math.ceil(container.minHeight / 2)))
		end

		return nil
	end, {
		v44.maxLines,
		v119,
		container.minHeight,
		v44.radius
	})
	local v121 = React.useMemo(function() -- line: 719
		-- upvalues: v120 (copy), container (copy), v45 (copy)
		return {
			radius = if not v120 then UDim.new(0, container.radius) else v120,
			offset = v45.Stroke.Thick,
			borderWidth = v45.Stroke.Thick
		}
	end, {
		v45,
		container.radius,
		v120
	})
	local v122, v123 = React.useMemo(function() -- line: 728
		-- upvalues: container (copy), v71 (copy), getMultiLineTextHeight (copy), FontSize (copy), LineHeight (copy), v118 (copy)
		local v183 = math.round((container.minHeight - v71 - getMultiLineTextHeight(FontSize, 1, LineHeight)) * 2) / 2
		local uDim = UDim.new(0, (math.floor(v183 / 2)))
		local uDim2 = UDim.new(0, (math.ceil(v183 / 2)))
		local v186 = v118 + math.round(v183) + v71

		return {
			top = uDim,
			bottom = uDim2,
			left = UDim.new(0, 0),
			right = UDim.new(0, 0)
		}, v186
	end, {
		container.minHeight,
		v71,
		v72,
		FontSize,
		v118,
		LineHeight
	})
	local v124 = v122.bottom.Offset + v122.top.Offset
	local v125 = v44.textPaddingOnParent == true
	local v126 = if not v125 then v122 else nil
	local v127 = if not v125 then v118 + v124 else v118
	local v128 = v89 and (v44.maxLines ~= nil and not v67)
	local v129 = if not v125 then v80 + v124 else v80
	local v130 = if not v128 then v127 else math.max(v127, v129)
	local v131 = if not v125 then v130 else v130 + v124
	local uDim2 = UDim2.new(1, 0, 0, v130)
	local uDim2_2 = UDim2.new(1, 0, 0, v127)

	React.useEffect(function() -- line: 776
		-- upvalues: v44 (copy), chatTextAreaDebug (copy), v88 (copy), v123 (copy)
		if v44.maxLines then
			chatTextAreaDebug.log("layout", `lineCount={ v88 } borderFrameHeight={ v123 }`)
		end

		return function() -- line: 780
		end
	end, {
		v88,
		v123,
		v44.maxLines
	})

	local v134 = React.useMemo(function() -- line: 783
		-- upvalues: v89 (copy), v44 (copy)
		if v89 then
			return {
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = if v44.maxLines == nil then Enum.ItemLineAlignment.Center else Enum.ItemLineAlignment.Start
			}
		end

		return nil
	end, {
		v89,
		v44.maxLines
	})
	local v135 = React.useMemo(function() -- line: 794
		-- upvalues: v89 (copy)
		if v89 then
			return {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always
			}
		end

		return nil
	end, { v89 })
	local v136 = React.useCallback(function(p20) -- line: 805
		-- upvalues: v49 (copy), v48 (copy), truncateTextToCursor (copy), v122 (copy)
		local current = v49.current
		local current2 = v48.current

		if current == nil or current2 == nil then
			return
		end

		local v190 = p20.TextSize * p20.LineHeight
		local CanvasPositionY = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p20)

		local TextBoundsY = current2.TextBounds.Y
		local v193 = CanvasPositionY - v122.top.Offset + v122.bottom.Offset
		local v194 = CanvasPositionY + current.AbsoluteSize.Y - v122.top.Offset - v122.bottom.Offset

		if v193 > TextBoundsY - v190 then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v190 - v193)
		end

		if v194 < TextBoundsY then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v194)
		end
	end, { v122 })
	local v137 = React.useCallback(function(p21) -- line: 838
		-- upvalues: v49 (copy), v53 (copy)
		if p21 == nil then
			return
		end

		v49.current = p21
		p21.ClipsDescendants = true
		p21.CanvasPosition = v53.current
	end, {})
	local v138 = React.useCallback(function(p22) -- line: 848
		-- upvalues: v50 (copy)
		if p22 then
			p22.Text = v50.current
			v50.current = ""
			task.delay(0, function() -- line: 852
				-- upvalues: p22 (copy)
				if p22.Parent ~= nil then
					p22:CaptureFocus()
				end
			end)
		end
	end, {})
	local v139 = React.useCallback(function(p23) -- line: 860
		-- upvalues: v53 (copy)
		v53.current = p23.CanvasPosition
	end, {})
	local v140 = React.useMemo(function() -- line: 865
		-- upvalues: v44 (copy), React (copy), v114 (copy), v115 (copy), v116 (copy), v58 (copy), isDisabled (copy)
		if not v44.onDragStarted and (not v44.onDrag and not v44.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v114,
			[React.Event.DragContinue] = v115,
			[React.Event.DragEnd] = v116,
			Enabled = not v58 and not isDisabled
		})
	end, {
		v114,
		v115,
		v116,
		v58,
		isDisabled,
		v44.onDragStarted,
		v44.onDrag,
		v44.onDragEnded
	})
	local v141 = useBindable(if not v44.horizontalPadding then UDim.new(0, 0) else v44.horizontalPadding.left or UDim.new(0, 0))
	local v142 = useBindable(if not v44.horizontalPadding then UDim.new(0, 0) else v44.horizontalPadding.right or UDim.new(0, 0))
	local v143 = React.useMemo(function() -- line: 896
		-- upvalues: v44 (copy), container (copy), v45 (copy)
		if v44.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v45.Stroke.Standard) / 2))
		end

		return nil
	end, {
		v44.hasClearButton,
		container.minHeight,
		v45.Stroke.Standard
	})
	local v144 = ReactUtils.useComposedRef(v47, v138)

	return React.createElement(View, withCommonProps(v44, {
		Size = UDim2.new(1, 0, 0, v123),
		selection = {
			Selectable = v44.Selectable and not isDisabled,
			NextSelectionUp = v44.NextSelectionUp,
			NextSelectionDown = v44.NextSelectionDown,
			NextSelectionLeft = v44.NextSelectionLeft,
			NextSelectionRight = v44.NextSelectionRight
		},
		cursor = v121,
		stroke = if not container.strokeStyle or not container.strokeThickness then nil else {
			Color = container.strokeStyle.Color3,
			Transparency = if not isDisabled then container.strokeStyle.Transparency else blendTransparencies(container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY),
			Thickness = container.strokeThickness,
			BorderStrokePosition = if not v58 and not v56 then Enum.BorderStrokePosition.Inner else Enum.BorderStrokePosition.Center
		},
		cornerRadius = v120,
		padding = {
			left = v141:map(function(p24) -- line: 936
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p24
			end),
			right = if v44.trailingElement ~= nil or not v44.hasClearButton then v142:map(function(p25) -- line: 942
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p25
			end) else UDim.new(0, Standard),
			top = UDim.new(0, Standard),
			bottom = UDim.new(0, Standard)
		},
		onActivated = if isDisabled then nil else v93,
		onStateChanged = v113,
		isDisabled = v65,
		backgroundStyle = if not container.bgStyle then nil else getDisabledStyle({
			Color3 = container.bgStyle.Color3,
			Transparency = if not v44.backgroundGradient then container.bgStyle.Transparency else 0
		}, v65),
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		tag = v62,
		testId = `{ v44.testId }--outer-container`
	}), {
		DragDetector = v140,
		Background = v44.backgroundGradient,
		Leading = if not v44.leadingElement then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "size-0-full auto-x",
			GroupTransparency = if not v65 then nil else Constants.DISABLED_TRANSPARENCY,
			testId = `{ v44.testId }--leading`
		}, v44.leadingElement),
		TextBoxWrapper = React.createElement(if not v89 then View else ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full clip",
			selection = {
				Selectable = false
			},
			scroll = v135,
			layout = v134,
			onCanvasPositionChanged = if not v89 then nil else v139,
			scrollingFrameRef = if not v89 then nil else v137
		}, {
			TextContent = React.createElement(View, {
				Size = if not v128 then nil else UDim2.new(1, 0, 0, v131),
				tag = {
					["fill size-full"] = not v128
				},
				padding = if not v125 then nil else v122,
				selection = {
					Selectable = false
				},
				onActivated = if isDisabled then nil else v93,
				stateLayer = {
					affordance = StateLayerAffordance.None
				}
			}, {
				TextBox = if v67 then nil else React.createElement(v36, {
					overlayNativeInput = nil,
					text = v87,
					placeholder = v44.placeholder,
					textInputType = v44.textInputType,
					fontStyle = fontStyle,
					textStyle = v73,
					isMultiLine = v89,
					isDisabled = isDisabled,
					ref = v46,
					tag = `{ v63 or "" } data-testid={ v44.testId }--textbox`,
					Size = if not v89 then nil else uDim2,
					automaticSize = if not v44.maxLines then if not v82 then mapBindable(v44.text, function(p26) -- line: 1012
						-- upvalues: v89 (copy), v67 (copy)
						if v89 and (not v67 and p26 ~= "") then
							return Enum.AutomaticSize.Y
						end

						return nil
					end) else if not v89 or (v67 or v83 == "") then nil else Enum.AutomaticSize.Y else nil,
					padding = v126,
					onFocusGained = v110,
					onFocusLost = if not v89 or not v69 then v112 else nil,
					onTextChanged = v99,
					onCursorPositionChanged = if not v89 then nil else v136,
					onInputChanged = v101,
					onInputEnded = v111,
					manualFocusRelease = if not v69 then nil else v44.manualFocusRelease,
					shouldEmitReturnEvents = v69 and (v44.manualFocusRelease == true and v44.alwaysMultiLine == true) or nil
				}, {
					DragDetector = v140,
					BoundsChecker = if not v89 then nil else React.createElement(v36, {
						isBoundsChecker = true,
						fontStyle = fontStyle,
						textStyle = v73,
						Size = if not v125 then UDim2.new(1, 0, 1, v124) else UDim2.fromScale(1, 1),
						ref = v48
					})
				}),
				MobileTextBox = if not v89 or not v67 then nil else React.createElement(v36, {
					overlayNativeInput = nil,
					text = v87,
					placeholder = v44.placeholder,
					textInputType = v44.textInputType,
					fontStyle = fontStyle,
					textStyle = v73,
					isMultiLine = v89,
					isDisabled = isDisabled,
					padding = v126,
					ref = v144,
					tag = `{ v63 or "" } data-testid={ v44.testId }--mobile-textbox`,
					Size = uDim2_2,
					onFocusLost = if not v89 or not v69 then nil else v112,
					onTextChanged = v99,
					onCursorPositionChanged = if not v89 then nil else v136,
					onInputEnded = v111,
					manualFocusRelease = if not v69 then nil else v44.manualFocusRelease,
					shouldEmitReturnEvents = v69 and (v44.manualFocusRelease == true and v44.alwaysMultiLine == true) or nil
				})
			})
		}),
		Clear = if not v44.hasClearButton then nil else React.createElement(View, {
			LayoutOrder = 3,
			isDisabled = isDisabled,
			GroupTransparency = if not isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			Visible = mapBindable(v44.text, function(p27) -- line: 1085
				return p27 ~= ""
			end),
			tag = v60.clearButton.tag
		}, {
			ClearButton = React.createElement(View, {
				tag = "anchor-center-left auto-xy",
				onActivated = v98,
				padding = UDim.new(0, v60.clearButton.padding),
				Position = v143,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				testId = `{ v44.testId }--clear-button`
			}, {
				Icon = React.createElement(Icon, {
					name = v60.clearButton.icon
				})
			})
		}),
		Trailing = if not v44.trailingElement then nil else React.createElement(View, {
			LayoutOrder = 4,
			GroupTransparency = if not v65 then nil else Constants.DISABLED_TRANSPARENCY,
			tag = {
				["col align-y-bottom self-stretch size-0-full auto-x"] = v44.trailingAlignBottom == true,
				["row align-y-center size-0-full auto-x"] = v44.trailingAlignBottom ~= true
			},
			testId = `{ v44.testId }--trailing`
		}, v44.trailingElement)
	})
end

return React.memo(React.forwardRef(InternalTextInput))
