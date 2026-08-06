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

require(Foundation.Enums.ControlState)

local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local t1 = {
	numLines = 1,
	testId = "--foundation-internal-text-input",
	Selectable = true,
	size = InputSize.Large,
	variant = InputVariant.Standard
}
local v32 = React.memo(React.forwardRef(function(t2: {[any]: any}, p1) -- line: 132
	-- upvalues: React (copy), isPluginSecurity (copy), Padding (copy)
	local isBoundsChecker = t2.isBoundsChecker
	local v37 = t2.isMultiLine or isBoundsChecker

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
		MultiLine = v37,
		TextWrapped = v37,
		TextYAlignment = if not v37 then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top,
		TextEditable = not isBoundsChecker and not t2.isDisabled,
		Interactable = t2.Interactable,
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

local function InternalTextInput(p2, p3) -- line: 179
	-- upvalues: Flags (copy), withDefaults (copy), t1 (copy), useTokens (copy), React (copy), getBindableValue (copy), useTextInputVariants (copy), useStyleTags (copy), usePreferredInput (copy), getDisabledStyle (copy), InputFocusBehavior (copy), getMultiLineTextHeight (copy), truncateTextToCursor (copy), useBindable (copy), ReactUtils (copy), View (copy), withCommonProps (copy), blendTransparencies (copy), Constants (copy), Radius (copy), StateLayerAffordance (copy), ScrollView (copy), v32 (copy), mapBindable (copy), Icon (copy)
	if Flags.FoundationInputSelectionProps and p2.Selectable == nil then
		p2.Selectable = true
	end

	local v40 = withDefaults(p2, t1)
	local v41 = useTokens()
	local v42 = math.max(1, v40.numLines)
	local v43 = v42 > 1
	local v44 = React.useRef(nil)
	local v45 = React.useRef(nil)
	local v46 = React.useRef(nil)
	local v47 = React.useRef(nil)
	local v48 = React.useRef("")
	local v49 = React.useRef(getBindableValue(v40.text))
	local v50 = React.useRef(nil)
	local v51 = React.useRef(Vector2.zero)
	local u52 = nil
	local v53 = nil
	local u54 = nil
	local u57, u59

	if Flags.FoundationRemoveSecondUIDDFromScrubbableTextboxes then
		local v55, v56 = React.useState(false)

		u57 = v55
		u52 = v56

		local v58

		v53, v58 = React.useBinding(false)
		u54 = v58
		u59 = React.useCallback(function(b1: boolean) -- line: 207
			-- upvalues: u54 (ref), u52 (ref)
			u54(b1)
			u52(b1)
		end, {})
	else
		local v60, v61 = React.useState(false)

		u57 = v60
		u59 = v61
	end

	local v62 = useTextInputVariants(v41, v40.size, v40.variant, v40.radius, u57, v40.hasError)
	local container = v62.container
	local v64 = useStyleTags(v62.textBox.tag)
	local v65 = usePreferredInput()
	local v66, v67 = React.useState(false)
	local v68 = v65 == Enum.PreferredInput.Touch
	local Standard = v41.Stroke.Standard
	local v70 = math.ceil(Standard) * 2
	local v71 = math.ceil(v41.Stroke.Thick) * 2
	local v72 = getDisabledStyle(v41.Color.Content.Emphasis, v40.isDisabled)
	local fontStyle = v62.textBox.fontStyle
	local FontSize = fontStyle.FontSize
	local LineHeight = fontStyle.LineHeight
	local v76 = React.useCallback(function(p4) -- line: 234
		-- upvalues: v44 (copy), v45 (copy)
		if v44.current then
			v44.current.SelectionStart = p4
		end

		if v45.current then
			v45.current.SelectionStart = p4
		end
	end, {})
	local v77 = React.useCallback(function(p5) -- line: 243
		-- upvalues: v44 (copy), v45 (copy)
		if v44.current then
			v44.current.CursorPosition = p5
		end

		if v45.current then
			v45.current.CursorPosition = p5
		end
	end, {})
	local v78 = React.useCallback(function() -- line: 252
		-- upvalues: v44 (copy), v45 (copy), v76 (copy), v77 (copy)
		local v115 = v44.current or v45.current

		if v115 == nil or v115.Parent == nil then
			return
		end

		local v116 = utf8.len(v115.Text)

		if v116 then
			v76(0)
			v77(v116 + 1)
		end
	end, {
		v76,
		v77
	})
	local v79 = React.useCallback(function() -- line: 266
		-- upvalues: v44 (copy), v40 (copy), InputFocusBehavior (copy), v78 (copy)
		if v44.current == nil then
			return
		end

		v44.current:CaptureFocus()

		if v40.focusBehavior == InputFocusBehavior.Highlight then
			task.spawn(v78)
		end
	end, {
		v78,
		v40.focusBehavior
	})
	local v80 = React.useCallback(function() -- line: 283
		-- upvalues: v44 (copy)
		if v44.current then
			v44.current:ReleaseFocus()
		end
	end, {})
	local v81 = React.useCallback(function() -- line: 289
		-- upvalues: v44 (copy)
		if v44.current then
			return (v44.current:IsFocused())
		end

		return nil
	end, {})
	local v82 = React.useCallback(function() -- line: 296
		-- upvalues: v44 (copy)
		if v44.current then
			return v44.current.SelectionStart
		end

		return nil
	end, {})
	local v83 = React.useCallback(function() -- line: 303
		-- upvalues: v44 (copy)
		if v44.current then
			return v44.current.CursorPosition
		end

		return nil
	end, {})
	local v84 = React.useCallback(function() -- line: 310
		-- upvalues: v44 (copy)
		if v44.current then
			v44.current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p3, function() -- line: 318
		-- upvalues: v81 (copy), v79 (copy), v80 (copy), v82 (copy), v83 (copy), v77 (copy), v76 (copy)
		return {
			getIsFocused = v81,
			focus = v79,
			releaseFocus = v80,
			getSelectionStart = v82,
			getCursorPosition = v83,
			setCursorPosition = v77,
			setSelectionStart = v76
		}
	end, {
		v83,
		v81,
		v82,
		v79,
		v80,
		v77,
		v76
	})

	local v85 = React.useCallback(function(p6) -- line: 340
		-- upvalues: v48 (copy), v49 (copy), v43 (copy), v46 (copy), v40 (copy)
		if p6 == nil or (p6.Parent == nil or v48.current ~= "") then
			return
		end

		local p6Text = p6.Text

		if p6Text == v49.current then
			return
		end

		v49.current = p6Text

		if v43 and v46.current then
			v46.current.Text = p6Text
		end

		v40.onChanged(p6Text)
	end, {
		v40.onChanged,
		v43,
		v66
	})
	local v86 = React.useRef(false)
	local v87 = React.useCallback(function() -- line: 362
		-- upvalues: v40 (copy), v43 (copy), v68 (copy), v44 (copy), v48 (copy), v67 (copy), u59 (ref), InputFocusBehavior (copy), v45 (copy), v86 (copy)
		if v40.isDisabled then
			return
		end

		if v43 and v68 then
			if v44.current and v44.current.Parent then
				v48.current = v44.current.Text
			end

			v67(true)
		end

		u59(true)

		if v40.onFocus then
			v40.onFocus()
		end

		local focusBehavior = v40.focusBehavior

		if focusBehavior == InputFocusBehavior.Clear then
			v48.current = ""

			if v44.current then
				v44.current.Text = ""
			end

			if v45.current then
				v45.current.Text = ""

				return
			end
		elseif focusBehavior == InputFocusBehavior.Highlight then
			v86.current = true
		end
	end, {
		v40.onFocus,
		v40.isDisabled,
		v68,
		v43,
		v40.focusBehavior
	})
	local v88 = React.useCallback(function(_, p8) -- line: 403
		-- upvalues: v86 (copy)
		if p8.UserInputType == Enum.UserInputType.MouseMovement then
			v86.current = false
		end
	end, {})
	local v89 = React.useCallback(function(_, p10) -- line: 410
		-- upvalues: v86 (copy), v78 (copy)
		if not v86.current then
			return
		end

		v86.current = false

		if p10.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v78()
	end, {
		v76,
		v77,
		v78
	})
	local v90 = React.useCallback(function(_, b2: boolean, p12) -- line: 430
		-- upvalues: u59 (ref), v86 (copy), v43 (copy), v67 (copy), v40 (copy)
		u59(false)
		v86.current = false

		if v43 then
			v67(false)
		end

		if v40.onFocusLost then
			v40.onFocusLost(p12)
		end

		if b2 and v40.onReturnPressed then
			v40.onReturnPressed()
		end
	end, {
		v40.onReturnPressed,
		v43,
		v40.onFocusLost
	})
	local v91 = React.useCallback(function(p13, vector2: Vector2) -- line: 449
		-- upvalues: v50 (copy), v40 (copy)
		v50.current = vector2

		if v40.onDragStarted then
			v40.onDragStarted(p13, vector2)
		end
	end, { v40.onDragStarted })
	local v92 = React.useCallback(function(p14, vector2: Vector2) -- line: 456
		-- upvalues: v40 (copy)
		if v40.onDrag then
			v40.onDrag(p14, vector2)
		end
	end, { v40.onDrag })
	local v93 = React.useCallback(function(p15, vector2: Vector2) -- line: 462
		-- upvalues: v50 (copy), v79 (copy), v80 (copy), u59 (ref), v40 (copy)
		if vector2 == v50.current then
			v79()
		else
			v80()
			u59(false)
		end

		v50.current = nil

		if v40.onDragEnded then
			v40.onDragEnded(p15, vector2)
		end
	end, { v40.onDragEnded })
	local v94 = React.useMemo(function() -- line: 475
		-- upvalues: container (copy), v41 (copy)
		return {
			radius = UDim.new(0, container.radius),
			offset = v41.Stroke.Thick,
			borderWidth = v41.Stroke.Thick
		}
	end, {
		v41,
		container.radius
	})
	local v95 = React.useMemo(function() -- line: 483
		-- upvalues: getMultiLineTextHeight (copy), FontSize (copy), v42 (copy), LineHeight (copy)
		return getMultiLineTextHeight(FontSize, v42, LineHeight)
	end, {
		FontSize,
		v42,
		LineHeight
	})
	local v96, v97 = React.useMemo(function() -- line: 488
		-- upvalues: container (copy), v70 (copy), getMultiLineTextHeight (copy), FontSize (copy), LineHeight (copy), v95 (copy)
		local v133 = math.round((container.minHeight - v70 - getMultiLineTextHeight(FontSize, 1, LineHeight)) * 2) / 2
		local uDim = UDim.new(0, (math.floor(v133 / 2)))
		local uDim2 = UDim.new(0, (math.ceil(v133 / 2)))
		local v136 = v95 + math.round(v133) + v70

		return {
			top = uDim,
			bottom = uDim2,
			left = UDim.new(0, 0),
			right = UDim.new(0, 0)
		}, v136
	end, {
		container.minHeight,
		v70,
		v71,
		FontSize,
		v95,
		LineHeight
	})
	local v98 = if not Flags.FoundationNumberInputBeta then nil else React.useMemo(function() -- line: 518
		-- upvalues: v40 (copy)
		return {
			left = if not v40.horizontalPadding then nil else v40.horizontalPadding.innerLeft,
			right = if not v40.horizontalPadding then nil else v40.horizontalPadding.innerRight
		}
	end, { v40.horizontalPadding })
	local v99 = v96.bottom.Offset + v96.top.Offset
	local uDim2 = UDim2.new(1, 0, 0, v95 + v99)
	local v101 = React.useMemo(function() -- line: 529
		-- upvalues: v43 (copy)
		if v43 then
			return {
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Center
			}
		end

		return nil
	end, { v43 })
	local v102 = React.useMemo(function() -- line: 538
		-- upvalues: v43 (copy)
		if v43 then
			return {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always
			}
		end

		return nil
	end, { v43 })
	local v103 = React.useCallback(function(p16) -- line: 549
		-- upvalues: v47 (copy), v46 (copy), truncateTextToCursor (copy), v96 (copy)
		local current = v47.current
		local current2 = v46.current

		if current == nil or current2 == nil then
			return
		end

		local v140 = p16.TextSize * p16.LineHeight
		local CanvasPositionY = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p16)

		local TextBoundsY = current2.TextBounds.Y
		local v143 = CanvasPositionY - v96.top.Offset + v96.bottom.Offset
		local v144 = CanvasPositionY + current.AbsoluteSize.Y - v96.top.Offset - v96.bottom.Offset

		if v143 > TextBoundsY - v140 then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v140 - v143)
		end

		if v144 < TextBoundsY then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v144)
		end
	end, { v96 })
	local v104 = React.useCallback(function(p17) -- line: 582
		-- upvalues: v47 (copy), v51 (copy)
		if p17 == nil then
			return
		end

		v47.current = p17
		p17.ClipsDescendants = true
		p17.CanvasPosition = v51.current
	end, {})
	local v105 = React.useCallback(function(p18) -- line: 592
		-- upvalues: v48 (copy), Flags (copy)
		if p18 then
			p18.Text = v48.current
			v48.current = ""

			if Flags.FoundationTextAreaDelayMobileFocus then
				task.delay(0, function() -- line: 597
					-- upvalues: p18 (copy)
					if p18.Parent ~= nil then
						p18:CaptureFocus()
					end
				end)

				return
			end

			p18:CaptureFocus()
		end
	end, {})
	local v106 = React.useCallback(function(p19) -- line: 608
		-- upvalues: v51 (copy)
		v51.current = p19.CanvasPosition
	end, {})
	local v107 = React.useMemo(function() -- line: 612
		-- upvalues: v40 (copy), React (copy), v91 (copy), v92 (copy), v93 (copy), u57 (ref)
		if not v40.onDragStarted and (not v40.onDrag and not v40.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v91,
			[React.Event.DragContinue] = v92,
			[React.Event.DragEnd] = v93,
			Enabled = not u57 and not v40.isDisabled
		})
	end, {
		v91,
		v92,
		v93,
		u57,
		v40.isDisabled
	})
	local v108 = useBindable(if not v40.horizontalPadding then UDim.new(0, 0) else v40.horizontalPadding.left or UDim.new(0, 0))
	local v109 = useBindable(if not v40.horizontalPadding then UDim.new(0, 0) else v40.horizontalPadding.right or UDim.new(0, 0))
	local v110 = React.useMemo(function() -- line: 632
		-- upvalues: v40 (copy), container (copy), v41 (copy)
		if v40.hasClearButton then
			return (UDim2.fromOffset(0, (container.minHeight - v41.Stroke.Standard) / 2))
		end

		return nil
	end, {
		v40.hasClearButton,
		container.minHeight,
		v41.Stroke.Standard
	})
	local v111 = ReactUtils.useComposedRef(v45, v105)

	return React.createElement(View, withCommonProps(v40, {
		ref = v40.inputRef,
		Size = UDim2.new(1, 0, 0, v97),
		selection = {
			Selectable = if not Flags.FoundationInputSelectionProps then not v40.isDisabled else v40.Selectable and not v40.isDisabled,
			NextSelectionUp = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionUp,
			NextSelectionDown = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionDown,
			NextSelectionLeft = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionLeft,
			NextSelectionRight = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionRight
		},
		cursor = v94,
		stroke = if not container.strokeStyle or not container.strokeThickness then nil else {
			Color = container.strokeStyle.Color3,
			Transparency = if not v40.isDisabled then container.strokeStyle.Transparency else blendTransparencies(container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY),
			Thickness = container.strokeThickness,
			BorderStrokePosition = if not u57 then Enum.BorderStrokePosition.Inner else Enum.BorderStrokePosition.Center
		},
		cornerRadius = if v40.radius ~= Radius.Circle then nil else UDim.new(0, (math.ceil(container.minHeight / 2))),
		padding = {
			left = v108:map(function(p20) -- line: 677
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p20
			end),
			right = if v40.trailingElement ~= nil or not v40.hasClearButton then v109:map(function(p21) -- line: 683
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p21
			end) else UDim.new(0, Standard),
			top = UDim.new(0, Standard),
			bottom = UDim.new(0, Standard)
		},
		onActivated = if v40.isDisabled then nil else v79,
		isDisabled = v40.isDisabled,
		backgroundStyle = if not container.bgStyle then nil else getDisabledStyle({
			Color3 = container.bgStyle.Color3,
			Transparency = if not v40.backgroundGradient then container.bgStyle.Transparency else 0
		}, v40.isDisabled),
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		tag = container.tag,
		testId = `{ v40.testId }--outer-container`
	}), {
		DragDetector = v107,
		Background = v40.backgroundGradient,
		Leading = if not v40.leadingElement then nil else React.createElement(View, {
			LayoutOrder = 1,
			tag = "size-0-full auto-x",
			GroupTransparency = if not v40.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			testId = `{ v40.testId }--leading`
		}, v40.leadingElement),
		TextBoxWrapper = React.createElement(if not v43 then View else ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full clip",
			selection = {
				Selectable = false
			},
			scroll = v102,
			layout = v101,
			onCanvasPositionChanged = if not v43 then nil else v106,
			scrollingFrameRef = if not v43 then nil else v104,
			padding = if not Flags.FoundationNumberInputBeta then nil else v98,
			testId = `{ v40.testId }--textbox-wrapper`
		}, {
			TextBox = if v66 then nil else React.createElement(v32, {
				text = v40.text,
				placeholder = v40.placeholder,
				textInputType = v40.textInputType,
				fontStyle = fontStyle,
				textStyle = v72,
				isMultiLine = v43,
				isDisabled = v40.isDisabled,
				ref = v44,
				tag = `{ v64 or "" } data-testid={ v40.testId }--textbox`,
				Interactable = if not Flags.FoundationRemoveSecondUIDDFromScrubbableTextboxes or v107 == nil then nil else v53,
				Size = if not v43 then nil else uDim2,
				automaticSize = mapBindable(v40.text, function(p22) -- line: 741
					-- upvalues: v43 (copy), v66 (copy)
					if v43 and (not v66 and p22 ~= "") then
						return Enum.AutomaticSize.Y
					end

					return nil
				end),
				padding = v96,
				onFocusGained = v87,
				onFocusLost = if not v43 or not v68 then v90 else nil,
				onTextChanged = v85,
				onCursorPositionChanged = if not v43 then nil else v103,
				onInputChanged = v88,
				onInputEnded = v89
			}, {
				DragDetector = if Flags.FoundationRemoveSecondUIDDFromScrubbableTextboxes then nil else v107,
				BoundsChecker = if not v43 then nil else React.createElement(v32, {
					isBoundsChecker = true,
					fontStyle = fontStyle,
					textStyle = v72,
					Size = UDim2.new(1, 0, 1, v99),
					ref = v46
				})
			}),
			MobileTextBox = if not v43 or not v66 then nil else React.createElement(v32, {
				text = v40.text,
				placeholder = v40.placeholder,
				textInputType = v40.textInputType,
				fontStyle = fontStyle,
				textStyle = v72,
				isMultiLine = v43,
				isDisabled = v40.isDisabled,
				padding = v96,
				ref = v111,
				tag = `{ v64 or "" } data-testid={ v40.testId }--mobile-textbox`,
				Interactable = if not Flags.FoundationRemoveSecondUIDDFromScrubbableTextboxes or v107 == nil then nil else v53,
				Size = uDim2,
				onFocusLost = if not v43 or not v68 then nil else v90,
				onTextChanged = v85,
				onCursorPositionChanged = if not v43 then nil else v103
			})
		}),
		Clear = if not v40.hasClearButton then nil else React.createElement(View, {
			LayoutOrder = 3,
			isDisabled = v40.isDisabled,
			GroupTransparency = if not v40.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			Visible = mapBindable(v40.text, function(p23) -- line: 802
				return p23 ~= ""
			end),
			tag = v62.clearButton.tag
		}, {
			ClearButton = React.createElement(View, {
				tag = "anchor-center-left auto-xy",
				onActivated = v84,
				padding = UDim.new(0, v62.clearButton.padding),
				Position = v110,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				testId = `{ v40.testId }--clear-button`
			}, {
				Icon = React.createElement(Icon, {
					name = v62.clearButton.icon
				})
			})
		}),
		Trailing = if not v40.trailingElement then nil else React.createElement(View, {
			LayoutOrder = 4,
			tag = "size-0-full auto-x",
			GroupTransparency = if not v40.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			testId = `{ v40.testId }--trailing`
		}, v40.trailingElement)
	})
end

return React.memo(React.forwardRef(InternalTextInput))
