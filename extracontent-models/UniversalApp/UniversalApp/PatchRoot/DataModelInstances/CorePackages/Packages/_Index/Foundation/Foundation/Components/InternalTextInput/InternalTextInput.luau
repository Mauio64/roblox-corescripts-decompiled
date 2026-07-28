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
local v32 = React.memo(React.forwardRef(function(t2: {[any]: any}, p1) -- line: 131
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
	local v52, v53 = React.useState(false)
	local v54 = useTextInputVariants(v41, v40.size, v40.variant, v40.radius, v52, v40.hasError)
	local container = v54.container
	local v56 = useStyleTags(v54.textBox.tag)
	local v57 = usePreferredInput()
	local v58, v59 = React.useState(false)
	local v60 = v57 == Enum.PreferredInput.Touch
	local Standard = v41.Stroke.Standard
	local v62 = math.ceil(Standard) * 2
	local v63 = math.ceil(v41.Stroke.Thick) * 2
	local v64 = getDisabledStyle(v41.Color.Content.Emphasis, v40.isDisabled)
	local fontStyle = v54.textBox.fontStyle
	local FontSize = fontStyle.FontSize
	local LineHeight = fontStyle.LineHeight
	local v68 = React.useCallback(function(p4) -- line: 218
		-- upvalues: v44 (copy), v45 (copy)
		if v44.current then
			v44.current.SelectionStart = p4
		end

		if v45.current then
			v45.current.SelectionStart = p4
		end
	end, {})
	local v69 = React.useCallback(function(p5) -- line: 227
		-- upvalues: v44 (copy), v45 (copy)
		if v44.current then
			v44.current.CursorPosition = p5
		end

		if v45.current then
			v45.current.CursorPosition = p5
		end
	end, {})
	local v70 = React.useCallback(function() -- line: 236
		-- upvalues: v44 (copy), v45 (copy), v68 (copy), v69 (copy)
		local v106 = v44.current or v45.current

		if v106 == nil or v106.Parent == nil then
			return
		end

		local v107 = utf8.len(v106.Text)

		if v107 then
			v68(0)
			v69(v107 + 1)
		end
	end, {
		v68,
		v69
	})
	local v71 = React.useCallback(function() -- line: 249
		-- upvalues: Flags (copy), v44 (copy), v40 (copy), InputFocusBehavior (copy), v70 (copy)
		if Flags.FoundationTextInputHighlightFix then
			if v44.current == nil then
				return
			end

			v44.current:CaptureFocus()

			if v40.focusBehavior == InputFocusBehavior.Highlight then
				task.spawn(v70)

				return
			end
		elseif v44.current then
			v44.current:CaptureFocus()
		end
	end, {
		if not Flags.FoundationTextInputHighlightFix then nil else v70,
		if not Flags.FoundationTextInputHighlightFix then nil else v40.focusBehavior
	})
	local v72 = React.useCallback(function() -- line: 270
		-- upvalues: v44 (copy)
		if v44.current then
			v44.current:ReleaseFocus()
		end
	end, {})
	local v73 = React.useCallback(function() -- line: 276
		-- upvalues: v44 (copy)
		if v44.current then
			return (v44.current:IsFocused())
		end

		return nil
	end, {})
	local v74 = React.useCallback(function() -- line: 283
		-- upvalues: v44 (copy)
		if v44.current then
			return v44.current.SelectionStart
		end

		return nil
	end, {})
	local v75 = React.useCallback(function() -- line: 290
		-- upvalues: v44 (copy)
		if v44.current then
			return v44.current.CursorPosition
		end

		return nil
	end, {})
	local v76 = React.useCallback(function() -- line: 297
		-- upvalues: v44 (copy)
		if v44.current then
			v44.current.Text = ""
		end
	end, {})

	React.useImperativeHandle(p3, function() -- line: 305
		-- upvalues: v73 (copy), v71 (copy), v72 (copy), v74 (copy), v75 (copy), v69 (copy), v68 (copy)
		return {
			getIsFocused = v73,
			focus = v71,
			releaseFocus = v72,
			getSelectionStart = v74,
			getCursorPosition = v75,
			setCursorPosition = v69,
			setSelectionStart = v68
		}
	end, {
		v75,
		v73,
		v74,
		v71,
		v72,
		v69,
		v68
	})

	local v77 = React.useCallback(function(p6) -- line: 327
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
		v58
	})
	local v78 = React.useRef(false)
	local v79 = React.useCallback(function() -- line: 349
		-- upvalues: v40 (copy), v43 (copy), v60 (copy), v44 (copy), v48 (copy), v59 (copy), v53 (copy), InputFocusBehavior (copy), v45 (copy), Flags (copy), v78 (copy), v68 (copy), v69 (copy)
		if v40.isDisabled then
			return
		end

		if v43 and v60 then
			if v44.current and v44.current.Parent then
				v48.current = v44.current.Text
			end

			v59(true)
		end

		v53(true)

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
			if Flags.FoundationTextInputHighlightFix then
				v78.current = true

				return
			end

			task.spawn(function() -- line: 382
				-- upvalues: v44 (copy), v45 (copy), v68 (copy), v69 (copy)
				local v143 = v44.current or v45.current

				if v143 and v143.Parent ~= nil then
					local v144 = utf8.len(v143.Text)

					if v144 then
						v68(0)
						v69(v144 + 1)
					end
				end
			end)
		end
	end, {
		v40.onFocus,
		v40.isDisabled,
		v60,
		v43,
		v40.focusBehavior,
		if Flags.FoundationTextInputHighlightFix then nil else v68,
		if Flags.FoundationTextInputHighlightFix then nil else v69
	})
	local v80 = React.useCallback(function(_, p8) -- line: 406
		-- upvalues: Flags (copy), v78 (copy)
		if not Flags.FoundationTextInputHighlightFix then
			return
		end

		if p8.UserInputType == Enum.UserInputType.MouseMovement then
			v78.current = false
		end
	end, {})
	local v81 = React.useCallback(function(_, p10) -- line: 417
		-- upvalues: Flags (copy), v78 (copy), v70 (copy)
		if not Flags.FoundationTextInputHighlightFix then
			return
		end

		if not v78.current then
			return
		end

		v78.current = false

		if p10.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v70()
	end, {
		if not Flags.FoundationTextInputHighlightFix then nil else v68,
		if not Flags.FoundationTextInputHighlightFix then nil else v69,
		if not Flags.FoundationTextInputHighlightFix then nil else v70
	})
	local v82 = React.useCallback(function(_, b1: boolean, p12) -- line: 441
		-- upvalues: v53 (copy), v78 (copy), v43 (copy), v59 (copy), v40 (copy)
		v53(false)
		v78.current = false

		if v43 then
			v59(false)
		end

		if v40.onFocusLost then
			v40.onFocusLost(p12)
		end

		if b1 and v40.onReturnPressed then
			v40.onReturnPressed()
		end
	end, {
		v40.onReturnPressed,
		v43,
		v40.onFocusLost
	})
	local v83 = React.useCallback(function(p13, vector2: Vector2) -- line: 460
		-- upvalues: v50 (copy), v40 (copy)
		v50.current = vector2

		if v40.onDragStarted then
			v40.onDragStarted(p13, vector2)
		end
	end, { v40.onDragStarted })
	local v84 = React.useCallback(function(p14, vector2: Vector2) -- line: 467
		-- upvalues: v40 (copy)
		if v40.onDrag then
			v40.onDrag(p14, vector2)
		end
	end, { v40.onDrag })
	local v85 = React.useCallback(function(p15, vector2: Vector2) -- line: 473
		-- upvalues: v50 (copy), v71 (copy), v72 (copy), v53 (copy), v40 (copy)
		if vector2 == v50.current then
			v71()
		else
			v72()
			v53(false)
		end

		v50.current = nil

		if v40.onDragEnded then
			v40.onDragEnded(p15, vector2)
		end
	end, { v40.onDragEnded })
	local v86 = React.useMemo(function() -- line: 486
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
	local v87 = React.useMemo(function() -- line: 494
		-- upvalues: getMultiLineTextHeight (copy), FontSize (copy), v42 (copy), LineHeight (copy)
		return getMultiLineTextHeight(FontSize, v42, LineHeight)
	end, {
		FontSize,
		v42,
		LineHeight
	})
	local v88, v89 = React.useMemo(function() -- line: 499
		-- upvalues: container (copy), v62 (copy), getMultiLineTextHeight (copy), FontSize (copy), LineHeight (copy), v87 (copy)
		local v124 = math.round((container.minHeight - v62 - getMultiLineTextHeight(FontSize, 1, LineHeight)) * 2) / 2
		local uDim = UDim.new(0, (math.floor(v124 / 2)))
		local uDim2 = UDim.new(0, (math.ceil(v124 / 2)))
		local v127 = v87 + math.round(v124) + v62

		return {
			top = uDim,
			bottom = uDim2,
			left = UDim.new(0, 0),
			right = UDim.new(0, 0)
		}, v127
	end, {
		container.minHeight,
		v62,
		v63,
		FontSize,
		v87,
		LineHeight
	})
	local v90 = if not Flags.FoundationNumberInputBeta then nil else React.useMemo(function() -- line: 529
		-- upvalues: v40 (copy)
		return {
			left = if not v40.horizontalPadding then nil else v40.horizontalPadding.innerLeft,
			right = if not v40.horizontalPadding then nil else v40.horizontalPadding.innerRight
		}
	end, { v40.horizontalPadding })
	local v91 = v88.bottom.Offset + v88.top.Offset
	local uDim2 = UDim2.new(1, 0, 0, v87 + v91)
	local v93 = React.useMemo(function() -- line: 540
		-- upvalues: v43 (copy)
		if v43 then
			return {
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Center
			}
		end

		return nil
	end, { v43 })
	local v94 = React.useMemo(function() -- line: 549
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
	local v95 = React.useCallback(function(p16) -- line: 560
		-- upvalues: v47 (copy), v46 (copy), truncateTextToCursor (copy), v88 (copy)
		local current = v47.current
		local current2 = v46.current

		if current == nil or current2 == nil then
			return
		end

		local v131 = p16.TextSize * p16.LineHeight
		local CanvasPositionY = current.CanvasPosition.Y

		current2.Text = truncateTextToCursor(p16)

		local TextBoundsY = current2.TextBounds.Y
		local v134 = CanvasPositionY - v88.top.Offset + v88.bottom.Offset
		local v135 = CanvasPositionY + current.AbsoluteSize.Y - v88.top.Offset - v88.bottom.Offset

		if v134 > TextBoundsY - v131 then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v131 - v134)
		end

		if v135 < TextBoundsY then
			current.CanvasPosition = current.CanvasPosition + Vector2.new(0, TextBoundsY - v135)
		end
	end, { v88 })
	local v96 = React.useCallback(function(p17) -- line: 593
		-- upvalues: v47 (copy), v51 (copy)
		if p17 == nil then
			return
		end

		v47.current = p17
		p17.ClipsDescendants = true
		p17.CanvasPosition = v51.current
	end, {})
	local v97 = React.useCallback(function(p18) -- line: 603
		-- upvalues: v48 (copy), Flags (copy)
		if p18 then
			p18.Text = v48.current
			v48.current = ""

			if Flags.FoundationTextAreaDelayMobileFocus then
				task.delay(0, function() -- line: 608
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
	local v98 = React.useCallback(function(p19) -- line: 619
		-- upvalues: v51 (copy)
		v51.current = p19.CanvasPosition
	end, {})
	local v99 = React.useMemo(function() -- line: 623
		-- upvalues: v40 (copy), React (copy), v83 (copy), v84 (copy), v85 (copy), v52 (copy)
		if not v40.onDragStarted and (not v40.onDrag and not v40.onDragEnded) then
			return nil
		end

		return React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			[React.Event.DragStart] = v83,
			[React.Event.DragContinue] = v84,
			[React.Event.DragEnd] = v85,
			Enabled = not v52 and not v40.isDisabled
		})
	end, {
		v83,
		v84,
		v85,
		v52,
		v40.isDisabled
	})
	local v100 = useBindable(if not v40.horizontalPadding then UDim.new(0, 0) else v40.horizontalPadding.left or UDim.new(0, 0))
	local v101 = useBindable(if not v40.horizontalPadding then UDim.new(0, 0) else v40.horizontalPadding.right or UDim.new(0, 0))
	local v102 = React.useMemo(function() -- line: 643
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
	local v103 = ReactUtils.useComposedRef(v45, v97)

	return React.createElement(View, withCommonProps(v40, {
		ref = v40.inputRef,
		Size = UDim2.new(1, 0, 0, v89),
		selection = {
			Selectable = if not Flags.FoundationInputSelectionProps then not v40.isDisabled else v40.Selectable and not v40.isDisabled,
			NextSelectionUp = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionUp,
			NextSelectionDown = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionDown,
			NextSelectionLeft = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionLeft,
			NextSelectionRight = if not Flags.FoundationInputSelectionProps then nil else v40.NextSelectionRight
		},
		cursor = v86,
		stroke = if not container.strokeStyle or not container.strokeThickness then nil else {
			Color = container.strokeStyle.Color3,
			Transparency = if not v40.isDisabled then container.strokeStyle.Transparency else blendTransparencies(container.strokeStyle.Transparency, Constants.DISABLED_TRANSPARENCY),
			Thickness = container.strokeThickness,
			BorderStrokePosition = if not v52 then Enum.BorderStrokePosition.Inner else Enum.BorderStrokePosition.Center
		},
		cornerRadius = if v40.radius ~= Radius.Circle then nil else UDim.new(0, (math.ceil(container.minHeight / 2))),
		padding = {
			left = v100:map(function(p20) -- line: 688
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p20
			end),
			right = if v40.trailingElement ~= nil or not v40.hasClearButton then v101:map(function(p21) -- line: 694
				-- upvalues: Standard (copy)
				return UDim.new(0, Standard) + p21
			end) else UDim.new(0, Standard),
			top = UDim.new(0, Standard),
			bottom = UDim.new(0, Standard)
		},
		onActivated = if v40.isDisabled then nil else v71,
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
		DragDetector = v99,
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
			scroll = v94,
			layout = v93,
			onCanvasPositionChanged = if not v43 then nil else v98,
			scrollingFrameRef = if not v43 then nil else v96,
			padding = if not Flags.FoundationNumberInputBeta then nil else v90,
			testId = `{ v40.testId }--textbox-wrapper`
		}, {
			TextBox = if v58 then nil else React.createElement(v32, {
				text = v40.text,
				placeholder = v40.placeholder,
				textInputType = v40.textInputType,
				fontStyle = fontStyle,
				textStyle = v64,
				isMultiLine = v43,
				isDisabled = v40.isDisabled,
				ref = v44,
				tag = `{ v56 or "" } data-testid={ v40.testId }--textbox`,
				Size = if not v43 then nil else uDim2,
				automaticSize = mapBindable(v40.text, function(p22) -- line: 748
					-- upvalues: v43 (copy), v58 (copy)
					if v43 and (not v58 and p22 ~= "") then
						return Enum.AutomaticSize.Y
					end

					return nil
				end),
				padding = v88,
				onFocusGained = v79,
				onFocusLost = if not v43 or not v60 then v82 else nil,
				onTextChanged = v77,
				onCursorPositionChanged = if not v43 then nil else v95,
				onInputChanged = v80,
				onInputEnded = v81
			}, {
				DragDetector = v99,
				BoundsChecker = if not v43 then nil else React.createElement(v32, {
					isBoundsChecker = true,
					fontStyle = fontStyle,
					textStyle = v64,
					Size = UDim2.new(1, 0, 1, v91),
					ref = v46
				})
			}),
			MobileTextBox = if not v43 or not v58 then nil else React.createElement(v32, {
				text = v40.text,
				placeholder = v40.placeholder,
				textInputType = v40.textInputType,
				fontStyle = fontStyle,
				textStyle = v64,
				isMultiLine = v43,
				isDisabled = v40.isDisabled,
				padding = v88,
				ref = v103,
				tag = `{ v56 or "" } data-testid={ v40.testId }--mobile-textbox`,
				Size = uDim2,
				onFocusLost = if not v43 or not v60 then nil else v82,
				onTextChanged = v77,
				onCursorPositionChanged = if not v43 then nil else v95
			})
		}),
		Clear = if not v40.hasClearButton then nil else React.createElement(View, {
			LayoutOrder = 3,
			isDisabled = v40.isDisabled,
			GroupTransparency = if not v40.isDisabled then nil else Constants.DISABLED_TRANSPARENCY,
			Visible = mapBindable(v40.text, function(p23) -- line: 803
				return p23 ~= ""
			end),
			tag = v54.clearButton.tag
		}, {
			ClearButton = React.createElement(View, {
				tag = "anchor-center-left auto-xy",
				onActivated = v76,
				padding = UDim.new(0, v54.clearButton.padding),
				Position = v102,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				testId = `{ v40.testId }--clear-button`
			}, {
				Icon = React.createElement(Icon, {
					name = v54.clearButton.icon
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
