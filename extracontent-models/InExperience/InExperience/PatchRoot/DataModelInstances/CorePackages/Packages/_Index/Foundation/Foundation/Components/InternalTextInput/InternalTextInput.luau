local Foundation = script:FindFirstAncestor("Foundation")
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
local ControlState = require(Foundation.Enums.ControlState)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local t1 = {
	numLines = 1,
	testId = "--foundation-internal-text-input",
	Selectable = true,
	size = InputSize.Large,
	variant = InputVariant.Standard
}
local v33 = React.memo(React.forwardRef(function(t2: {[any]: any}, p1) -- line: 131
	-- upvalues: React (copy), isPluginSecurity (copy), Padding (copy)
	local isBoundsChecker = t2.isBoundsChecker
	local v38 = t2.isMultiLine or isBoundsChecker

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
		MultiLine = v38,
		TextWrapped = v38,
		TextYAlignment = if not v38 then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top,
		TextEditable = not isBoundsChecker and not t2.isDisabled,
		PlaceholderText = t2.placeholder,
		TextInputType = if not isPluginSecurity() then nil else t2.textInputType,
		Size = if t2.Size == nil then UDim2.fromScale(1, 1) else t2.Size,
		AutomaticSize = t2.automaticSize,
		Text = if not isBoundsChecker then t2.text else nil,
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

local function InternalTextInput(p2, p3) -- line: 177
	-- upvalues: Flags (copy), withDefaults (copy), t1 (copy), useTokens (copy), React (copy), getBindableValue (copy), useTextInputVariants (copy), useStyleTags (copy), usePreferredInput (copy), getDisabledStyle (copy), InputFocusBehavior (copy), ControlState (copy), getMultiLineTextHeight (copy), truncateTextToCursor (copy), useBindable (copy), ReactUtils (copy), View (copy), withCommonProps (copy), blendTransparencies (copy), Constants (copy), Radius (copy), StateLayerAffordance (copy), ScrollView (copy), v33 (copy), mapBindable (copy), Icon (copy)
	if Flags.FoundationInputSelectionProps and p2.Selectable == nil then
		p2.Selectable = true
	end

	local v41 = withDefaults(p2, t1)
	local v42 = useTokens()
	local v43 = math.max(1, v41.numLines)
	local v44 = v43 > 1
	local v45 = React.useRef(nil)
	local v46 = React.useRef(nil)
	local v47 = React.useRef(nil)
	local v48 = React.useRef(nil)
	local v49 = React.useRef("")
	local v50 = React.useRef(getBindableValue(v41.text))
	local v51 = React.useRef(nil)
	local v52 = React.useRef(Vector2.zero)
	local v53 = nil
	local u54 = nil

	if not Flags.FoundationTextInputsBetaUpdate then
		local v55

		v53, v55 = React.useState(false)
		u54 = v55
	end

	local v56, v57 = React.useState(false)
	local v58 = useTextInputVariants(v42, v41.size, v41.variant, v41.radius, v56, if not Flags.FoundationTextInputsBetaUpdate then v53 else nil, v41.hasError)
	local container = v58.container
	local v60 = useStyleTags(v58.textBox.tag)
	local v61 = usePreferredInput()
	local v62, v63 = React.useState(false)
	local v64 = v61 == Enum.PreferredInput.Touch
	local Standard = v42.Stroke.Standard
	local v66 = math.ceil(Standard) * 2
	local v67 = math.ceil(v42.Stroke.Thick) * 2
	local v68 = getDisabledStyle(v42.Color.Content.Emphasis, v41.isDisabled)
	local fontStyle = v58.textBox.fontStyle
	local FontSize = fontStyle.FontSize
	local LineHeight = fontStyle.LineHeight
	local v72 = React.useCallback(function(p4) -- line: 230
		-- upvalues: v45 (copy), v46 (copy)
		if v45.current then
			v45.current.SelectionStart = p4
		end

		if v46.current then
			v46.current.SelectionStart = p4
		end
	end, {})
	local v73 = React.useCallback(function(p5) -- line: 239
		-- upvalues: v45 (copy), v46 (copy)
		if v45.current then
			v45.current.CursorPosition = p5
		end

		if v46.current then
			v46.current.CursorPosition = p5
		end
	end, {})
	local v74 = React.useCallback(function() -- line: 248
		-- upvalues: v45 (copy), v46 (copy), v72 (copy), v73 (copy)
		local v111 = v45.current or v46.current

		if v111 == nil or v111.Parent == nil then
			return
		end

		local v112 = utf8.len(v111.Text)

		if v112 then
			v72(0)
			v73(v112 + 1)
		end
	end, {
		v72,
		v73
	})
	local v75 = React.useCallback(function() -- line: 261
		-- upvalues: Flags (copy), v45 (copy), v41 (copy), InputFocusBehavior (copy), v74 (copy)
		if Flags.FoundationTextInputHighlightFix then
			if v45.current == nil then
				return
			end

			v45.current:CaptureFocus()

			if v41.focusBehavior == InputFocusBehavior.Highlight then
				task.spawn(v74)

				return
			end
		elseif v45.current then
			v45.current:CaptureFocus()
		end
	end, {
		if not Flags.FoundationTextInputHighlightFix then nil else v74,
		if not Flags.FoundationTextInputHighlightFix then nil else v41.focusBehavior
	})
	local v76 = React.useCallback(function() -- line: 282
		-- upvalues: v45 (copy)
		if v45.current then
			v45.current:ReleaseFocus()
		end
	end, {})
	local v77 = React.useCallback(function() -- line: 288
		-- upvalues: v45 (copy)
		if v45.current then
			return (v45.current:IsFocused())
		end

		return nil
	end, {})
	local v78 = React.useCallback(function() -- line: 295
		-- upvalues: v45 (copy)
		if v45.current then
			return v45.current.SelectionStart
		end

		return nil
	end, {})
	local v79 = React.useCallback(function() -- line: 302
		-- upvalues: v45 (copy)
		if v45.current then
			return v45.current.CursorPosition
		end

		return nil
	end, {})
	local v80 = React.useCallback(function() -- line: 309
		-- upvalues: v45 (copy)
		if v45.current then
			v45.current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p3, function() -- line: 317
		-- upvalues: v77 (copy), v75 (copy), v76 (copy), Flags (copy), u54 (ref), v78 (copy), v79 (copy), v73 (copy), v72 (copy)
		return {
			getIsFocused = v77,
			focus = v75,
			releaseFocus = v76,
			setHover = if not Flags.FoundationTextInputsBetaUpdate then u54 else nil,
			getSelectionStart = v78,
			getCursorPosition = v79,
			setCursorPosition = v73,
			setSelectionStart = v72
		}
	end, {
		v79,
		v77,
		v78,
		v75,
		v76,
		v73,
		v72
	})

	local v81 = React.useCallback(function(p6) -- line: 340
		-- upvalues: v49 (copy), v50 (copy), v44 (copy), v47 (copy), v41 (copy)
		if p6 == nil or (p6.Parent == nil or v49.current ~= "") then
			return
		end

		local p6Text = p6.Text

		if p6Text == v50.current then
			return
		end

		v50.current = p6Text

		if v44 and v47.current then
			v47.current.Text = p6Text
		end

		v41.onChanged(p6Text)
	end, {
		v41.onChanged,
		v44,
		v62
	})
	local v82 = React.useRef(false)
	local v83 = React.useCallback(function() -- line: 362
		-- upvalues: v41 (copy), v44 (copy), v64 (copy), v45 (copy), v49 (copy), v63 (copy), v57 (copy), InputFocusBehavior (copy), v46 (copy), Flags (copy), v82 (copy), v72 (copy), v73 (copy)
		if v41.isDisabled then
			return
		end

		if v44 and v64 then
			if v45.current and v45.current.Parent then
				v49.current = v45.current.Text
			end

			v63(true)
		end

		v57(true)

		if v41.onFocus then
			v41.onFocus()
		end

		local focusBehavior = v41.focusBehavior

		if focusBehavior == InputFocusBehavior.Clear then
			v49.current = ""

			if v45.current then
				v45.current.Text = ""
			end

			if v46.current then
				v46.current.Text = ""

				return
			end
		elseif focusBehavior == InputFocusBehavior.Highlight then
			if Flags.FoundationTextInputHighlightFix then
				v82.current = true

				return
			end

			task.spawn(function() -- line: 395
				-- upvalues: v45 (copy), v46 (copy), v72 (copy), v73 (copy)
				local v149 = v45.current or v46.current

				if v149 and v149.Parent ~= nil then
					local v150 = utf8.len(v149.Text)

					if v150 then
						v72(0)
						v73(v150 + 1)
					end
				end
			end)
		end
	end, {
		v41.onFocus,
		v41.isDisabled,
		v64,
		v44,
		v41.focusBehavior,
		if Flags.FoundationTextInputHighlightFix then nil else v72,
		if Flags.FoundationTextInputHighlightFix then nil else v73
	})
	local v84 = React.useCallback(function(_, p8) -- line: 419
		-- upvalues: Flags (copy), v82 (copy)
		if not Flags.FoundationTextInputHighlightFix then
			return
		end

		if p8.UserInputType == Enum.UserInputType.MouseMovement then
			v82.current = false
		end
	end, {})
	local v85 = React.useCallback(function(_, p10) -- line: 430
		-- upvalues: Flags (copy), v82 (copy), v74 (copy)
		if not Flags.FoundationTextInputHighlightFix then
			return
		end

		if not v82.current then
			return
		end

		v82.current = false

		if p10.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v74()
	end, {
		if not Flags.FoundationTextInputHighlightFix then nil else v72,
		if not Flags.FoundationTextInputHighlightFix then nil else v73,
		if not Flags.FoundationTextInputHighlightFix then nil else v74
	})
	local v86 = React.useCallback(function(_, b1: boolean, p12) -- line: 454
		-- upvalues: v57 (copy), v82 (copy), v44 (copy), v63 (copy), v41 (copy)
		v57(false)
		v82.current = false

		if v44 then
			v63(false)
		end

		if v41.onFocusLost then
			v41.onFocusLost(p12)
		end

		if b1 and v41.onReturnPressed then
			v41.onReturnPressed()
		end
	end, {
		v41.onReturnPressed,
		v44,
		v41.onFocusLost
	})
	local v87 = if not Flags.FoundationTextInputsBetaUpdate then React.useCallback(function(p13) -- line: 476
		-- upvalues: u54 (ref), ControlState (copy)
		u54(p13 == ControlState.Hover)
	end, {}) else nil
	local v88 = React.useCallback(function(p14, vector2: Vector2) -- line: 480
		-- upvalues: v51 (copy), v41 (copy)
		v51.current = vector2

		if v41.onDragStarted then
			v41.onDragStarted(p14, vector2)
		end
	end, { v41.onDragStarted })
	local v89 = React.useCallback(function(p15, vector2: Vector2) -- line: 487
		-- upvalues: v41 (copy)
		if v41.onDrag then
			v41.onDrag(p15, vector2)
		end
	end, { v41.onDrag })
	local v90 = React.useCallback(function(p16, vector2: Vector2) -- line: 493
		-- upvalues: v51 (copy), v75 (copy), v76 (copy), v57 (copy), v41 (copy)
		if vector2 == v51.current then
			v75()
		else
			v76()
			v57(false)
		end

		v51.current = nil

		if v41.onDragEnded then
			v41.onDragEnded(p16, vector2)
		end
	end, { v41.onDragEnded })
	local v91 = React.useMemo(function() -- line: 506
		-- upvalues: container (copy), v42 (copy)
		return {
			radius = UDim.new(0, container.radius),
			offset = v42.Stroke.Thick,
			borderWidth = v42.Stroke.Thick
		}
	end, {
		v42,
		container.radius
	})
	local v92 = React.useMemo(function() -- line: 514
		-- upvalues: getMultiLineTextHeight (copy), FontSize (copy), v43 (copy), LineHeight (copy)
		return getMultiLineTextHeight(FontSize, v43, LineHeight)
	end, {
		FontSize,
		v43,
		LineHeight
	})
	local v93, v94 = React.useMemo(function() -- line: 519
		-- upvalues: container (copy), v66 (copy), getMultiLineTextHeight (copy), FontSize (copy), LineHeight (copy), v92 (copy)
		local v130 = math.round((container.minHeight - v66 - getMultiLineTextHeight(FontSize, 1, LineHeight)) * 2) / 2
		local uDim = UDim.new(0, (math.floor(v130 / 2)))
		local uDim2 = UDim.new(0, (math.ceil(v130 / 2)))
		local v133 = v92 + math.round(v130) + v66

		return {
			top = uDim,
			bottom = uDim2,
			left = UDim.new(0, 0),
			right = UDim.new(0, 0)
		}, v133
	end, {
		container.minHeight,
		v66,
		v67,
		FontSize,
		v92,
		LineHeight
	})
	local v95 = if not Flags.FoundationSupportPrefixSuffixNumberInput then nil else React.useMemo(function() -- line: 549
		-- upvalues: v41 (copy)
		return {
			left = if not v41.horizontalPadding then nil else v41.horizontalPadding.innerLeft,
			right = if not v41.horizontalPadding then nil else v41.horizontalPadding.innerRight
		}
	end, { v41.horizontalPadding })
	local v96 = v93.bottom.Offset + v93.top.Offset
	local uDim2 = UDim2.new(1, 0, 0, v92 + v96)
	local v98 = React.useMemo(function() -- line: 560
		-- upvalues: v44 (copy)
		if v44 then
			return {
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Center
			}
		end

		return nil
	end, { v44 })
	local v99 = React.useMemo(function() -- line: 569
		-- upvalues: v44 (copy)
		if v44 then
			return {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always
			}
		end

		return nil
	end, { v44 })
	local v100 = React.useCallback(function(p17) -- line: 580
		-- upvalues: v48 (copy), v47 (copy), truncateTextToCursor (copy), v93 (copy)
		local current = v48.current
		local current2 = v47.current

		if current == nil or current2 == nil then
			return
		end

		local v137 = p17.TextSize * p17.LineHeight
		local CanvasPositionY = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p17)

		local TextBoundsY = current2.TextBounds.Y
		local v140 = CanvasPositionY - v93.top.Offset + v93.bottom.Offset
		local v141 = CanvasPositionY + current.AbsoluteSize.Y - v93.top.Offset - v93.bottom.Offset

		if v140 > TextBoundsY - v137 then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v137 - v140)
		end

		if v141 < TextBoundsY then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v141)
		end
	end, { v93 })
	local v101 = React.useCallback(function(p18) -- line: 613
		-- upvalues: v48 (copy), v52 (copy)
		if p18 == nil then
			return
		end

		v48.current = p18
		p18.ClipsDescendants = true
		p18.CanvasPosition = v52.current
	end, {})
	local v102 = React.useCallback(function(p19) -- line: 623
		-- upvalues: v49 (copy), Flags (copy)
		if p19 then
			p19.Text = v49.current
			v49.current = ""

			if Flags.FoundationTextAreaDelayMobileFocus then
				task.delay(0, function() -- line: 628
					-- upvalues: p19 (copy)
					if p19.Parent ~= nil then
						p19:CaptureFocus()
					end
				end)

				return
			end

			p19:CaptureFocus()
		end
	end, {})
	local v103 = React.useCallback(function(p20) -- line: 639
		-- upvalues: v52 (copy)
		v52.current = p20.CanvasPosition
	end, {})
	local v104 = React.useMemo(function() -- line: 643
		-- upvalues: v41 (copy), React (copy), v88 (copy), v89 (copy), v90 (copy), v56 (copy)
		if not v41.onDragStarted and (not v41.onDrag and not v41.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v88,
			[React.Event.DragContinue] = v89,
			[React.Event.DragEnd] = v90,
			Enabled = not v56 and not v41.isDisabled
		})
	end, {
		v88,
		v89,
		v90,
		v56,
		v41.isDisabled
	})
	local v105 = useBindable(if not v41.horizontalPadding then UDim.new(0, 0) else v41.horizontalPadding.left or UDim.new(0, 0))
	local v106 = useBindable(if not v41.horizontalPadding then UDim.new(0, 0) else v41.horizontalPadding.right or UDim.new(0, 0))
	local v107 = React.useMemo(function() -- line: 663
		-- upvalues: v41 (copy), container (copy), v42 (copy)
		if v41.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v42.Stroke.Standard) / 2))
		end

		return nil
	end, {
		v41.hasClearButton,
		container.minHeight,
		v42.Stroke.Standard
	})
	local v108 = ReactUtils.useComposedRef(v46, v102)

	return React.createElement(View, withCommonProps(v41, {
		ref = v41.inputRef,
		Size = UDim2.new(1, 0, 0, v94),
		selection = {
			Selectable = if not Flags.FoundationInputSelectionProps then not v41.isDisabled else v41.Selectable and not v41.isDisabled,
			NextSelectionUp = if not Flags.FoundationInputSelectionProps then nil else v41.NextSelectionUp,
			NextSelectionDown = if not Flags.FoundationInputSelectionProps then nil else v41.NextSelectionDown,
			NextSelectionLeft = if not Flags.FoundationInputSelectionProps then nil else v41.NextSelectionLeft,
			NextSelectionRight = if not Flags.FoundationInputSelectionProps then nil else v41.NextSelectionRight
		},
		cursor = v91,
		stroke = if not container.strokeStyle or not container.strokeThickness then nil else {
			Color = container.strokeStyle.Color3,
			Transparency = if not v41.isDisabled then container.strokeStyle.Transparency else blendTransparencies(container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY),
			Thickness = container.strokeThickness,
			BorderStrokePosition = if not v56 and (not v53 or Flags.FoundationTextInputsBetaUpdate) then Enum.BorderStrokePosition.Inner else Enum.BorderStrokePosition.Center
		},
		cornerRadius = if v41.radius ~= Radius.Circle then nil else UDim.new(0, (math.ceil(container.minHeight / 2))),
		padding = {
			left = v105:map(function(p21) -- line: 708
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p21
			end),
			right = if v41.trailingElement ~= nil or not v41.hasClearButton then v106:map(function(p22) -- line: 714
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p22
			end) else UDim.new(0, Standard),
			top = UDim.new(0, Standard),
			bottom = UDim.new(0, Standard)
		},
		onActivated = if v41.isDisabled then nil else v75,
		onStateChanged = if not Flags.FoundationTextInputsBetaUpdate then v87 else nil,
		isDisabled = v41.isDisabled,
		backgroundStyle = if not container.bgStyle then nil else getDisabledStyle({
			Color3 = container.bgStyle.Color3,
			Transparency = if not v41.backgroundGradient then container.bgStyle.Transparency else 0
		}, v41.isDisabled),
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		tag = container.tag,
		testId = `{ v41.testId }--outer-container`
	}), {
		DragDetector = v104,
		Background = v41.backgroundGradient,
		Leading = if not v41.leadingElement then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "size-0-full auto-x",
			GroupTransparency = if not v41.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			testId = `{ v41.testId }--leading`
		}, v41.leadingElement),
		TextBoxWrapper = React.createElement(if not v44 then View else ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full clip",
			selection = {
				Selectable = false
			},
			scroll = v99,
			layout = v98,
			onCanvasPositionChanged = if not v44 then nil else v103,
			scrollingFrameRef = if not v44 then nil else v101,
			padding = if not Flags.FoundationSupportPrefixSuffixNumberInput then nil else v95,
			testId = `{ v41.testId }--textbox-wrapper`
		}, {
			TextBox = if v62 then nil else React.createElement(v33, {
				text = v41.text,
				placeholder = v41.placeholder,
				textInputType = v41.textInputType,
				fontStyle = fontStyle,
				textStyle = v68,
				isMultiLine = v44,
				isDisabled = v41.isDisabled,
				ref = v45,
				tag = `{ v60 or "" } data-testid={ v41.testId }--textbox`,
				Size = if not v44 then nil else uDim2,
				automaticSize = mapBindable(v41.text, function(p23) -- line: 769
					-- upvalues: v44 (copy), v62 (copy)
					if v44 and (not v62 and p23 ~= "") then
						return Enum.AutomaticSize.Y
					end

					return nil
				end),
				padding = v93,
				onFocusGained = v83,
				onFocusLost = if not v44 or not v64 then v86 else nil,
				onTextChanged = v81,
				onCursorPositionChanged = if not v44 then nil else v100,
				onInputChanged = v84,
				onInputEnded = v85
			}, {
				DragDetector = v104,
				BoundsChecker = if not v44 then nil else React.createElement(v33, {
					isBoundsChecker = true,
					fontStyle = fontStyle,
					textStyle = v68,
					Size = UDim2.new(1, 0, 1, v96),
					ref = v47
				})
			}),
			MobileTextBox = if not v44 or not v62 then nil else React.createElement(v33, {
				text = v41.text,
				placeholder = v41.placeholder,
				textInputType = v41.textInputType,
				fontStyle = fontStyle,
				textStyle = v68,
				isMultiLine = v44,
				isDisabled = v41.isDisabled,
				padding = v93,
				ref = v108,
				tag = `{ v60 or "" } data-testid={ v41.testId }--mobile-textbox`,
				Size = uDim2,
				onFocusLost = if not v44 or not v64 then nil else v86,
				onTextChanged = v81,
				onCursorPositionChanged = if not v44 then nil else v100
			})
		}),
		Clear = if not v41.hasClearButton then nil else React.createElement(View, {
			LayoutOrder = 3,
			isDisabled = v41.isDisabled,
			GroupTransparency = if not v41.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			Visible = mapBindable(v41.text, function(p24) -- line: 824
				return p24 ~= ""
			end),
			tag = v58.clearButton.tag
		}, {
			ClearButton = React.createElement(View, {
				tag = "anchor-center-left auto-xy",
				onActivated = v80,
				padding = UDim.new(0, v58.clearButton.padding),
				Position = v107,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				testId = `{ v41.testId }--clear-button`
			}, {
				Icon = React.createElement(Icon, {
					name = v58.clearButton.icon
				})
			})
		}),
		Trailing = if not v41.trailingElement then nil else React.createElement(View, {
			LayoutOrder = 4,
			tag = "size-0-full auto-x",
			GroupTransparency = if not v41.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			testId = `{ v41.testId }--trailing`
		}, v41.trailingElement)
	})
end

return React.memo(React.forwardRef(InternalTextInput))
