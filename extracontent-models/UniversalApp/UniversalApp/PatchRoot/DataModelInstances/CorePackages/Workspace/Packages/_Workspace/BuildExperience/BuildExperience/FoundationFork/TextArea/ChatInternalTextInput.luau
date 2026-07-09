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
local Flags = require(Foundation.Utility.Flags)
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
local v37 = React.memo(React.forwardRef(function(t2: {[any]: any}, p1) -- line: 143
	-- upvalues: React (copy), isPluginSecurity (copy), Padding (copy)
	local isBoundsChecker = t2.isBoundsChecker
	local v42 = t2.isMultiLine or isBoundsChecker

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
		MultiLine = v42,
		TextWrapped = v42,
		TextYAlignment = if not v42 then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top,
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

local function InternalTextInput(p2, p3) -- line: 192
	-- upvalues: Flags (copy), withDefaults (copy), t1 (copy), useTokens (copy), React (copy), getBindableValue (copy), useTextInputVariants (copy), useStyleTags (copy), usePreferredInput (copy), useComposerFocusLock (copy), getDisabledStyle (copy), getMultiLineTextHeight (copy), chatTextAreaDebug (copy), measureTextLineCount (copy), InputFocusBehavior (copy), useComposerKeyboardConnections (copy), ControlState (copy), Radius (copy), truncateTextToCursor (copy), useBindable (copy), ReactUtils (copy), View (copy), withCommonProps (copy), blendTransparencies (copy), Constants (copy), StateLayerAffordance (copy), ScrollView (copy), v37 (copy), mapBindable (copy), Icon (copy)
	if Flags.FoundationInputSelectionProps and p2.Selectable == nil then
		p2 = table.clone(p2)
		p2.Selectable = true
	end

	local v45 = withDefaults(p2, t1)
	local v46 = useTokens()
	local v47 = React.useRef(nil)
	local v48 = React.useRef(nil)
	local v49 = React.useRef(nil)
	local v50 = React.useRef(nil)
	local v51 = React.useRef("")
	local v52 = React.useRef(getBindableValue(v45.text))
	local v53 = React.useRef(nil)
	local v54 = React.useRef(Vector2.zero)
	local v55 = React.useRef(false)
	local v56 = React.useRef(0)
	local v57, v58 = React.useState(false)
	local v59, v60 = React.useState(false)
	local v61 = useTextInputVariants(v46, v45.size, v45.variant, v45.radius, v59, v57, v45.hasError)
	local container = v61.container
	local v63 = if not v45.trailingElement or typeof(container.tag) ~= "string" then container.tag else string.gsub(container.tag, "gap%-large", "gap-xsmall")
	local v64 = useStyleTags(v61.textBox.tag)
	local isDisabled = v45.isDisabled
	local v66 = v45.isDisabled and v45.trailingElement == nil
	local v67 = usePreferredInput()
	local v68, v69 = React.useState(false)
	local v70 = v67 == Enum.PreferredInput.Touch
	local Standard = v46.Stroke.Standard
	local v72 = math.ceil(Standard) * 2
	local v73 = math.ceil(v46.Stroke.Thick) * 2

	useComposerFocusLock(isDisabled == true, {
		v47,
		v48
	})

	local v74 = getDisabledStyle(v46.Color.Content.Emphasis, isDisabled)
	local fontStyle = v61.textBox.fontStyle
	local FontSize = fontStyle.FontSize
	local LineHeight = fontStyle.LineHeight
	local v78 = getMultiLineTextHeight(FontSize, 1, LineHeight)
	local v79, v80 = React.useState(1)
	local v81, v82 = React.useState(v78)
	local v83 = v45.maxLines ~= nil
	local v84, v85 = React.useState(function() -- line: 249
		-- upvalues: getBindableValue (copy), v45 (copy)
		return getBindableValue(v45.text)
	end)

	React.useEffect(function() -- line: 253
		-- upvalues: chatTextAreaDebug (copy), v45 (copy)
		chatTextAreaDebug.setEnabled(v45.composerDebug == true)

		return function() -- line: 255
		end
	end, { v45.composerDebug })

	local v86 = React.useCallback(function() -- line: 258
		-- upvalues: v47 (copy), v48 (copy)
		local v146 = v47.current or v48.current

		if v146 and v146.AbsoluteSize.X > 0 then
			return v146.AbsoluteSize.X
		end

		return 0
	end, {})
	local v87 = React.useCallback(function(s1: string) -- line: 267
		-- upvalues: measureTextLineCount (copy), v45 (copy), v78 (copy), v86 (copy), fontStyle (copy), FontSize (copy), v82 (copy)
		local v148 = measureTextLineCount({
			text = s1,
			maxLines = v45.maxLines,
			singleLineHeight = v78,
			layoutWidth = v86(),
			font = fontStyle.Font,
			fontSize = FontSize
		})
		local v149 = if not v148.boundsY or not (v148.boundsY > 0) then v78 else math.ceil(v148.boundsY)

		v82((math.max(v149, v148.lineCount * v78)))

		return v148.lineCount
	end, {
		FontSize,
		LineHeight,
		fontStyle.Font,
		v45.maxLines,
		v86,
		v78
	})
	local v88 = if not v83 then getBindableValue(v45.text) else v45.text
	local v89 = if not v45.maxLines then math.max(1, v45.numLines) else v79
	local v90 = not not v45.alwaysMultiLine or v89 > 1

	React.useEffect(function() -- line: 298
		-- upvalues: v83 (copy), getBindableValue (copy), v45 (copy), v52 (copy), chatTextAreaDebug (copy), v85 (copy), v80 (copy), v87 (copy)
		if not v83 then
			return function() -- line: 300
			end
		end

		local v150 = getBindableValue(v45.text)

		if v150 ~= v52.current then
			chatTextAreaDebug.log("syncFromParent", `len={ utf8.len(v150) or #v150 }`)
			v52.current = v150
			v85(v150)
			v80(v87(v150))
			task.defer(function() -- line: 308
				-- upvalues: v80 (copy), v87 (copy), v150 (copy)
				v80(v87(v150))
			end)
		end

		return function() -- line: 312
		end
	end, {
		v45.text,
		v87,
		v83
	})

	local v91 = React.useCallback(function(p4) -- line: 315
		-- upvalues: v47 (copy), v48 (copy)
		if v47.current then
			v47.current.SelectionStart = p4
		end

		if v48.current then
			v48.current.SelectionStart = p4
		end
	end, {})
	local v92 = React.useCallback(function(p5) -- line: 324
		-- upvalues: v47 (copy), v48 (copy)
		if v47.current then
			v47.current.CursorPosition = p5
		end

		if v48.current then
			v48.current.CursorPosition = p5
		end
	end, {})
	local v93 = React.useCallback(function() -- line: 333
		-- upvalues: v47 (copy), v48 (copy), v91 (copy), v92 (copy)
		local v153 = v47.current or v48.current

		if v153 == nil or v153.Parent == nil then
			return
		end

		local v154 = utf8.len(v153.Text)

		if v154 then
			v91(0)
			v92(v154 + 1)
		end
	end, {
		v91,
		v92
	})
	local v94 = React.useCallback(function() -- line: 346
		-- upvalues: Flags (copy), v47 (copy), v45 (copy), InputFocusBehavior (copy), v93 (copy)
		if Flags.FoundationTextInputHighlightFix then
			if v47.current == nil then
				return
			end

			v47.current:CaptureFocus()

			if v45.focusBehavior == InputFocusBehavior.Highlight then
				task.spawn(v93)

				return
			end
		elseif v47.current then
			v47.current:CaptureFocus()
		end
	end, {
		if not Flags.FoundationTextInputHighlightFix then nil else v93,
		if not Flags.FoundationTextInputHighlightFix then nil else v45.focusBehavior
	})
	local v95 = React.useCallback(function() -- line: 367
		-- upvalues: v47 (copy), v48 (copy), v69 (copy), v60 (copy)
		if v47.current then
			v47.current:ReleaseFocus()
		end

		if v48.current then
			v48.current:ReleaseFocus()
		end

		v69(false)
		v60(false)
	end, {})
	local v96 = React.useCallback(function() -- line: 378
		-- upvalues: v47 (copy)
		if v47.current then
			return (v47.current:IsFocused())
		end

		return nil
	end, {})
	local v97 = React.useCallback(function() -- line: 385
		-- upvalues: v47 (copy)
		if v47.current then
			return v47.current.SelectionStart
		end

		return nil
	end, {})
	local v98 = React.useCallback(function() -- line: 392
		-- upvalues: v47 (copy)
		if v47.current then
			return v47.current.CursorPosition
		end

		return nil
	end, {})
	local v99 = React.useCallback(function() -- line: 399
		-- upvalues: v47 (copy)
		if v47.current then
			v47.current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p3, function() -- line: 407
		-- upvalues: v96 (copy), v94 (copy), v95 (copy), v58 (copy), v97 (copy), v98 (copy), v92 (copy), v91 (copy)
		return {
			getIsFocused = v96,
			focus = v94,
			releaseFocus = v95,
			setHover = v58,
			getSelectionStart = v97,
			getCursorPosition = v98,
			setCursorPosition = v92,
			setSelectionStart = v91
		}
	end, {
		v98,
		v96,
		v97,
		v94,
		v95,
		v92,
		v91
	})

	local v100 = React.useCallback(function(p6) -- line: 431
		-- upvalues: v51 (copy), v55 (copy), v52 (copy), v90 (copy), v49 (copy), v83 (copy), v85 (copy), v45 (copy), v80 (copy), v87 (copy)
		if p6 == nil or (p6.Parent == nil or v51.current ~= "") then
			return
		end

		local p6Text = p6.Text

		if v55.current and p6Text ~= "" then
			return
		end

		if p6Text == v52.current then
			return
		end

		v52.current = p6Text

		if v90 and v49.current then
			v49.current.Text = p6Text
		end

		if v83 then
			v85(p6Text)
		end

		if v45.maxLines then
			v80(v87(p6Text))
			task.defer(function() -- line: 457
				-- upvalues: v80 (copy), v87 (copy), p6Text (copy)
				v80(v87(p6Text))
			end)
		end

		v45.onChanged(p6Text)
	end, {
		v45.onChanged,
		v90,
		v68,
		v45.maxLines,
		v87,
		v83
	})
	local v101 = React.useRef(false)
	local v102 = React.useCallback(function(_, p8) -- line: 469
		-- upvalues: Flags (copy), v101 (copy)
		if not Flags.FoundationTextInputHighlightFix then
			return
		end

		if p8.UserInputType == Enum.UserInputType.MouseMovement then
			v101.current = false
		end
	end, {})
	local v103 = React.useCallback(function(_, p10) -- line: 480
		-- upvalues: Flags (copy), v101 (copy), v93 (copy)
		if not Flags.FoundationTextInputHighlightFix then
			return
		end

		if not v101.current then
			return
		end

		v101.current = false

		if p10.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v93()
	end, {
		if not Flags.FoundationTextInputHighlightFix then nil else v91,
		if not Flags.FoundationTextInputHighlightFix then nil else v92,
		if not Flags.FoundationTextInputHighlightFix then nil else v93
	})
	local v104 = React.useCallback(function(s2: string) -- line: 503
		-- upvalues: v52 (copy), v83 (copy), v85 (copy), v45 (copy), v80 (copy), v87 (copy)
		v52.current = s2

		if v83 then
			v85(s2)
		end

		if v45.maxLines then
			v80(v87(s2))
		end

		v45.onChanged(s2)
	end, {
		v45.maxLines,
		v87,
		v45.onChanged,
		v83
	})
	local v105 = v45.onReturnPressed ~= nil and not v70
	local v106 = React.useCallback(function(_, s3: string) -- line: 516
		-- upvalues: v45 (copy), v56 (copy), chatTextAreaDebug (copy), v55 (copy)
		if v45.onReturnPressed == nil then
			return
		end

		local elapsed = os.clock()

		if elapsed - v56.current < 0.15 then
			chatTextAreaDebug.log("returnSubmit", `source={ s3 } skipped=debounced`)

			return
		end

		chatTextAreaDebug.log("returnSubmit", `source={ s3 }`)
		v56.current = elapsed
		v55.current = true
		v45.onReturnPressed()
		task.delay(0.15, function() -- line: 532
			-- upvalues: v55 (copy)
			v55.current = false
		end)
	end, { v45.onReturnPressed })
	local v107 = React.useCallback(function(_: boolean, b2: boolean) -- line: 537
		-- upvalues: v47 (copy), chatTextAreaDebug (copy), v104 (copy), v106 (copy)
		local current = v47.current

		if current == nil or current:IsFocused() ~= true then
			return
		end

		if b2 then
			local currentText = current.Text

			task.defer(function() -- line: 545
				-- upvalues: current (copy), currentText (copy), chatTextAreaDebug (copy), v104 (copy)
				if current.Parent == nil then
					return
				end

				local currentText2 = current.Text

				if currentText2 ~= currentText then
					chatTextAreaDebug.log("returnNewline", "source=UserInputService.InputBegan-shift engineInserted=true")
					v104(currentText2)
				end
			end)

			return
		end

		v106(current, "UserInputService.InputBegan")
	end, {
		v106,
		v104
	})
	local v108 = useComposerKeyboardConnections({
		enabled = v105 == true,
		onReturnPressed = v107
	})
	local connect = v108.connect
	local disconnect = v108.disconnect
	local v111 = React.useCallback(function() -- line: 574
		-- upvalues: isDisabled (copy), v90 (copy), v70 (copy), v47 (copy), v51 (copy), v69 (copy), v60 (copy), v45 (copy), v105 (copy), connect (copy), InputFocusBehavior (copy), v48 (copy), Flags (copy), v101 (copy), v91 (copy), v92 (copy)
		if isDisabled then
			return
		end

		if v90 and v70 then
			if v47.current and v47.current.Parent then
				v51.current = v47.current.Text
			end

			v69(true)
		end

		v60(true)

		if v45.onFocus then
			v45.onFocus()
		end

		if v105 then
			connect()
		end

		local focusBehavior = v45.focusBehavior

		if focusBehavior == InputFocusBehavior.Clear then
			v51.current = ""

			if v47.current then
				v47.current.Text = ""
			end

			if v48.current then
				v48.current.Text = ""

				return
			end
		elseif focusBehavior == InputFocusBehavior.Highlight then
			if Flags.FoundationTextInputHighlightFix then
				v101.current = true

				return
			end

			task.spawn(function() -- line: 612
				-- upvalues: v47 (copy), v48 (copy), v91 (copy), v92 (copy)
				local v204 = v47.current or v48.current

				if v204 and v204.Parent ~= nil then
					local v205 = utf8.len(v204.Text)

					if v205 then
						v91(0)
						v92(v205 + 1)
					end
				end
			end)
		end
	end, {
		v45.onFocus,
		isDisabled,
		v70,
		v90,
		v45.focusBehavior,
		v105,
		connect,
		if Flags.FoundationTextInputHighlightFix then nil else v91,
		if Flags.FoundationTextInputHighlightFix then nil else v92
	})
	local v112 = React.useCallback(function(p12, p13) -- line: 638
		-- upvalues: v103 (copy)
		v103(p12, p13)
	end, { v103 })
	local v113 = React.useCallback(function(p14, b3: boolean, p15) -- line: 643
		-- upvalues: chatTextAreaDebug (copy), v105 (copy), disconnect (copy), v60 (copy), v101 (copy), v90 (copy), v69 (copy), v45 (copy), v106 (copy)
		chatTextAreaDebug.log("textBox.FocusLost", `enterPressed={ b3 }`)

		if v105 then
			disconnect()
		end

		v60(false)
		v101.current = false

		if v90 then
			v69(false)
		end

		if v45.onFocusLost then
			v45.onFocusLost(p15)
		end

		if b3 and v105 then
			v106(p14, "TextBox.FocusLost")
		end
	end, {
		v90,
		v45.onFocusLost,
		v105,
		v106,
		disconnect
	})
	local v114 = React.useCallback(function(p16) -- line: 674
		-- upvalues: v58 (copy), ControlState (copy)
		v58(p16 == ControlState.Hover)
	end, {})
	local v115 = React.useCallback(function(p17, vector2: Vector2) -- line: 678
		-- upvalues: v53 (copy), v45 (copy)
		v53.current = vector2

		if v45.onDragStarted then
			v45.onDragStarted(p17, vector2)
		end
	end, { v45.onDragStarted })
	local v116 = React.useCallback(function(p18, vector2: Vector2) -- line: 685
		-- upvalues: v45 (copy)
		if v45.onDrag then
			v45.onDrag(p18, vector2)
		end
	end, { v45.onDrag })
	local v117 = React.useCallback(function(p19, vector2: Vector2) -- line: 691
		-- upvalues: v53 (copy), v94 (copy), v95 (copy), v60 (copy), v45 (copy)
		if vector2 == v53.current then
			v94()
		else
			v95()
			v60(false)
		end

		v53.current = nil

		if v45.onDragEnded then
			v45.onDragEnded(p19, vector2)
		end
	end, {
		v45.onDragEnded,
		v94,
		v95
	})
	local v118 = if not v45.maxLines then nil else getMultiLineTextHeight(FontSize, v45.maxLines, LineHeight)
	local v119 = React.useMemo(function() -- line: 708
		-- upvalues: v45 (copy), v78 (copy), v81 (copy), v118 (copy), getMultiLineTextHeight (copy), FontSize (copy), v89 (copy), LineHeight (copy)
		if v45.maxLines then
			return (math.clamp(math.max(v78, v81), v78, v118))
		end

		return getMultiLineTextHeight(FontSize, v89, LineHeight)
	end, {
		v45.maxLines,
		v78,
		v81,
		v118,
		FontSize,
		v89,
		LineHeight
	})
	local v120 = React.useMemo(function() -- line: 730
		-- upvalues: getMultiLineTextHeight (copy), FontSize (copy), LineHeight (copy), container (copy), v72 (copy)
		local v182 = getMultiLineTextHeight(FontSize, 1, LineHeight)
		local v183 = v182 + math.round(math.round((container.minHeight - v72 - v182) * 2) / 2) + v72

		return UDim.new(0, (math.ceil(v183 / 2)))
	end, {
		container.minHeight,
		v72,
		FontSize,
		LineHeight
	})
	local v121 = React.useMemo(function() -- line: 739
		-- upvalues: v45 (copy), v120 (copy), Radius (copy), container (copy)
		if v45.maxLines then
			return v120
		end

		if v45.radius == Radius.Circle then
			return UDim.new(0, (math.ceil(container.minHeight / 2)))
		end

		return nil
	end, {
		v45.maxLines,
		v120,
		container.minHeight,
		v45.radius
	})
	local v122 = React.useMemo(function() -- line: 749
		-- upvalues: v121 (copy), container (copy), v46 (copy)
		return {
			radius = if not v121 then UDim.new(0, container.radius) else v121,
			offset = v46.Stroke.Thick,
			borderWidth = v46.Stroke.Thick
		}
	end, {
		v46,
		container.radius,
		v121
	})
	local v123, v124 = React.useMemo(function() -- line: 758
		-- upvalues: container (copy), v72 (copy), getMultiLineTextHeight (copy), FontSize (copy), LineHeight (copy), v119 (copy)
		local v184 = math.round((container.minHeight - v72 - getMultiLineTextHeight(FontSize, 1, LineHeight)) * 2) / 2
		local uDim = UDim.new(0, (math.floor(v184 / 2)))
		local uDim2 = UDim.new(0, (math.ceil(v184 / 2)))
		local v187 = v119 + math.round(v184) + v72

		return {
			top = uDim,
			bottom = uDim2,
			left = UDim.new(0, 0),
			right = UDim.new(0, 0)
		}, v187
	end, {
		container.minHeight,
		v72,
		v73,
		FontSize,
		v119,
		LineHeight
	})
	local v125 = v123.bottom.Offset + v123.top.Offset
	local v126 = v45.textPaddingOnParent == true
	local v127 = if not v126 then v123 else nil
	local v128 = if not v126 then v119 + v125 else v119
	local v129 = v90 and (v45.maxLines ~= nil and not v68)
	local v130 = if not v126 then v81 + v125 else v81
	local v131 = if not v129 then v128 else math.max(v128, v130)
	local v132 = if not v126 then v131 else v131 + v125
	local uDim2 = UDim2.new(1, 0, 0, v131)
	local uDim2_2 = UDim2.new(1, 0, 0, v128)

	React.useEffect(function() -- line: 806
		-- upvalues: v45 (copy), chatTextAreaDebug (copy), v89 (copy), v124 (copy)
		if v45.maxLines then
			chatTextAreaDebug.log("layout", `lineCount={ v89 } borderFrameHeight={ v124 }`)
		end

		return function() -- line: 810
		end
	end, {
		v89,
		v124,
		v45.maxLines
	})

	local v135 = React.useMemo(function() -- line: 813
		-- upvalues: v90 (copy), v45 (copy)
		if v90 then
			return {
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = if v45.maxLines == nil then Enum.ItemLineAlignment.Center else Enum.ItemLineAlignment.Start
			}
		end

		return nil
	end, {
		v90,
		v45.maxLines
	})
	local v136 = React.useMemo(function() -- line: 824
		-- upvalues: v90 (copy)
		if v90 then
			return {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always
			}
		end

		return nil
	end, { v90 })
	local v137 = React.useCallback(function(p20) -- line: 835
		-- upvalues: v50 (copy), v49 (copy), truncateTextToCursor (copy), v123 (copy)
		local current = v50.current
		local current2 = v49.current

		if current == nil or current2 == nil then
			return
		end

		local v191 = p20.TextSize * p20.LineHeight
		local CanvasPositionY = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p20)

		local TextBoundsY = current2.TextBounds.Y
		local v194 = CanvasPositionY - v123.top.Offset + v123.bottom.Offset
		local v195 = CanvasPositionY + current.AbsoluteSize.Y - v123.top.Offset - v123.bottom.Offset

		if v194 > TextBoundsY - v191 then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v191 - v194)
		end

		if v195 < TextBoundsY then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v195)
		end
	end, { v123 })
	local v138 = React.useCallback(function(p21) -- line: 868
		-- upvalues: v50 (copy), v54 (copy)
		if p21 == nil then
			return
		end

		v50.current = p21
		p21.ClipsDescendants = true
		p21.CanvasPosition = v54.current
	end, {})
	local v139 = React.useCallback(function(p22) -- line: 878
		-- upvalues: v51 (copy), Flags (copy)
		if p22 then
			p22.Text = v51.current
			v51.current = ""

			if Flags.FoundationTextAreaDelayMobileFocus then
				task.delay(0, function() -- line: 883
					-- upvalues: p22 (copy)
					if p22.Parent ~= nil then
						p22:CaptureFocus()
					end
				end)

				return
			end

			p22:CaptureFocus()
		end
	end, {})
	local v140 = React.useCallback(function(p23) -- line: 894
		-- upvalues: v54 (copy)
		v54.current = p23.CanvasPosition
	end, {})
	local v141 = React.useMemo(function() -- line: 899
		-- upvalues: v45 (copy), React (copy), v115 (copy), v116 (copy), v117 (copy), v59 (copy), isDisabled (copy)
		if not v45.onDragStarted and (not v45.onDrag and not v45.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v115,
			[React.Event.DragContinue] = v116,
			[React.Event.DragEnd] = v117,
			Enabled = not v59 and not isDisabled
		})
	end, {
		v115,
		v116,
		v117,
		v59,
		isDisabled,
		v45.onDragStarted,
		v45.onDrag,
		v45.onDragEnded
	})
	local v142 = useBindable(if not v45.horizontalPadding then UDim.new(0, 0) else v45.horizontalPadding.left or UDim.new(0, 0))
	local v143 = useBindable(if not v45.horizontalPadding then UDim.new(0, 0) else v45.horizontalPadding.right or UDim.new(0, 0))
	local v144 = React.useMemo(function() -- line: 930
		-- upvalues: v45 (copy), container (copy), v46 (copy)
		if v45.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v46.Stroke.Standard) / 2))
		end

		return nil
	end, {
		v45.hasClearButton,
		container.minHeight,
		v46.Stroke.Standard
	})
	local v145 = ReactUtils.useComposedRef(v48, v139)

	return React.createElement(View, withCommonProps(v45, {
		Size = UDim2.new(1, 0, 0, v124),
		selection = {
			Selectable = if not Flags.FoundationInputSelectionProps then not isDisabled else v45.Selectable and not isDisabled,
			NextSelectionUp = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionUp,
			NextSelectionDown = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionDown,
			NextSelectionLeft = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionLeft,
			NextSelectionRight = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionRight
		},
		cursor = v122,
		stroke = if not container.strokeStyle or not container.strokeThickness then nil else {
			Color = container.strokeStyle.Color3,
			Transparency = if not isDisabled then container.strokeStyle.Transparency else blendTransparencies(container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY),
			Thickness = container.strokeThickness,
			BorderStrokePosition = if not v59 and not v57 then Enum.BorderStrokePosition.Inner else Enum.BorderStrokePosition.Center
		},
		cornerRadius = v121,
		padding = {
			left = v142:map(function(p24) -- line: 972
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p24
			end),
			right = if v45.trailingElement ~= nil or not v45.hasClearButton then v143:map(function(p25) -- line: 978
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p25
			end) else UDim.new(0, Standard),
			top = UDim.new(0, Standard),
			bottom = UDim.new(0, Standard)
		},
		onActivated = if isDisabled then nil else v94,
		onStateChanged = v114,
		isDisabled = v66,
		backgroundStyle = if not container.bgStyle then nil else getDisabledStyle({
			Color3 = container.bgStyle.Color3,
			Transparency = if not v45.backgroundGradient then container.bgStyle.Transparency else 0
		}, v66),
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		tag = v63,
		testId = `{ v45.testId }--outer-container`
	}), {
		DragDetector = v141,
		Background = v45.backgroundGradient,
		Leading = if not v45.leadingElement then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "size-0-full auto-x",
			GroupTransparency = if not v66 then nil else Constants.DISABLED_TRANSPARENCY,
			testId = `{ v45.testId }--leading`
		}, v45.leadingElement),
		TextBoxWrapper = React.createElement(if not v90 then View else ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full clip",
			selection = {
				Selectable = false
			},
			scroll = v136,
			layout = v135,
			onCanvasPositionChanged = if not v90 then nil else v140,
			scrollingFrameRef = if not v90 then nil else v138
		}, {
			TextContent = React.createElement(View, {
				Size = if not v129 then nil else UDim2.new(1, 0, 0, v132),
				tag = {
					["fill size-full"] = not v129
				},
				padding = if not v126 then nil else v123,
				selection = {
					Selectable = false
				},
				onActivated = if isDisabled then nil else v94,
				stateLayer = {
					affordance = StateLayerAffordance.None
				}
			}, {
				TextBox = if v68 then nil else React.createElement(v37, {
					overlayNativeInput = nil,
					text = v88,
					placeholder = v45.placeholder,
					textInputType = v45.textInputType,
					fontStyle = fontStyle,
					textStyle = v74,
					isMultiLine = v90,
					isDisabled = isDisabled,
					ref = v47,
					tag = `{ v64 or "" } data-testid={ v45.testId }--textbox`,
					Size = if not v90 then nil else uDim2,
					automaticSize = if not v45.maxLines then if not v83 then mapBindable(v45.text, function(p26) -- line: 1048
						-- upvalues: v90 (copy), v68 (copy)
						if v90 and (not v68 and p26 ~= "") then
							return Enum.AutomaticSize.Y
						end

						return nil
					end) else if not v90 or (v68 or v84 == "") then nil else Enum.AutomaticSize.Y else nil,
					padding = v127,
					onFocusGained = v111,
					onFocusLost = if not v90 or not v70 then v113 else nil,
					onTextChanged = v100,
					onCursorPositionChanged = if not v90 then nil else v137,
					onInputChanged = v102,
					onInputEnded = v112,
					manualFocusRelease = if not v70 then nil else v45.manualFocusRelease,
					shouldEmitReturnEvents = v70 and (v45.manualFocusRelease == true and v45.alwaysMultiLine == true) or nil
				}, {
					DragDetector = v141,
					BoundsChecker = if not v90 then nil else React.createElement(v37, {
						isBoundsChecker = true,
						fontStyle = fontStyle,
						textStyle = v74,
						Size = if not v126 then UDim2.new(1, 0, 1, v125) else UDim2.fromScale(1, 1),
						ref = v49
					})
				}),
				MobileTextBox = if not v90 or not v68 then nil else React.createElement(v37, {
					overlayNativeInput = nil,
					text = v88,
					placeholder = v45.placeholder,
					textInputType = v45.textInputType,
					fontStyle = fontStyle,
					textStyle = v74,
					isMultiLine = v90,
					isDisabled = isDisabled,
					padding = v127,
					ref = v145,
					tag = `{ v64 or "" } data-testid={ v45.testId }--mobile-textbox`,
					Size = uDim2_2,
					onFocusLost = if not v90 or not v70 then nil else v113,
					onTextChanged = v100,
					onCursorPositionChanged = if not v90 then nil else v137,
					onInputEnded = v112,
					manualFocusRelease = if not v70 then nil else v45.manualFocusRelease,
					shouldEmitReturnEvents = v70 and (v45.manualFocusRelease == true and v45.alwaysMultiLine == true) or nil
				})
			})
		}),
		Clear = if not v45.hasClearButton then nil else React.createElement(View, {
			LayoutOrder = 3,
			isDisabled = isDisabled,
			GroupTransparency = if not isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			Visible = mapBindable(v45.text, function(p27) -- line: 1121
				return p27 ~= ""
			end),
			tag = v61.clearButton.tag
		}, {
			ClearButton = React.createElement(View, {
				tag = "anchor-center-left auto-xy",
				onActivated = v99,
				padding = UDim.new(0, v61.clearButton.padding),
				Position = v144,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				testId = `{ v45.testId }--clear-button`
			}, {
				Icon = React.createElement(Icon, {
					name = v61.clearButton.icon
				})
			})
		}),
		Trailing = if not v45.trailingElement then nil else React.createElement(View, {
			LayoutOrder = 4,
			GroupTransparency = if not v66 then nil else Constants.DISABLED_TRANSPARENCY,
			tag = {
				["col align-y-bottom self-stretch size-0-full auto-x"] = v45.trailingAlignBottom == true,
				["row align-y-center size-0-full auto-x"] = v45.trailingAlignBottom ~= true
			},
			testId = `{ v45.testId }--trailing`
		}, v45.trailingElement)
	})
end

return React.memo(React.forwardRef(InternalTextInput))
