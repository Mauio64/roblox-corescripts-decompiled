local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)
local ReactUtils = require(FoundationParent.ReactUtils)
local Components = Foundation.Components
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local InputSize = require(Foundation.Enums.InputSize)

require(Foundation.Enums.InputLabelSize)

local InputVariant = require(Foundation.Enums.InputVariant)
local NumberInputControlsVariant = require(Foundation.Enums.NumberInputControlsVariant)
local ScrubBehavior = require(Foundation.Enums.ScrubBehavior)
local OnChangeCallbackReason = require(Foundation.Enums.OnChangeCallbackReason)
local Flags = require(Foundation.Utility.Flags)
local Icon = require(Components.Icon)
local InputField = require(Components.InputField)
local InternalTextInput = require(Components.InternalTextInput)
local Text = require(Components.Text)

require(Components.Types)

local View = require(Components.View)
local getBindableValue = require(Foundation.Utility.getBindableValue)
local getInputTextSize = require(Foundation.Utility.getInputTextSize)
local getMultiLineTextHeight = require(Foundation.Utility.getMultiLineTextHeight)
local isBuilderIcon = require(Foundation.Utility.isBuilderIcon)
local joinBindables = require(Foundation.Utility.joinBindables)
local mapBindable = require(Foundation.Utility.mapBindable)
local useIconSize = require(Foundation.Utility.useIconSize)
local useTextInputVariants = require(Components.TextInput.useTextInputVariants)
local useTextSize = require(Foundation.Utility.useTextSize)
local useTokens = require(Foundation.Providers.Style.useTokens)
local NumberInputControls = require(script.Parent.NumberInputControls)
local useNumberInputVariants = require(script.Parent.useNumberInputVariants)
local Constants = require(Foundation.Constants)
local calculateNumberInputValueFromPositions = require(script.Parent.calculateNumberInputValueFromPositions)

require(Foundation.Enums.InputFocusBehavior)

local function round(n1: number, n2: number?) -- line: 61
	local v41 = 10 ^ (n2 or 0)

	return math.floor(n1 * v41 + 0.5) / v41
end

local t1 = {
	[ScrubBehavior.On] = 1,
	[ScrubBehavior.Off] = 0
}

local function defaultFormatAsString(n3: number) -- line: 129
	return (tostring(n3))
end

local t2 = {
	minimum = -1e999,
	maximum = 1e999,
	step = 1,
	precision = 3,
	value = 0,
	isScrubbable = false,
	hasControls = false,
	testId = "--foundation-number-input",
	variant = InputVariant.Standard,
	controlsVariant = if not Flags.FoundationNumberInputBeta then NumberInputControlsVariant.Stacked else nil,
	size = InputSize.Large,
	formatAsString = defaultFormatAsString,
	scrubBehavior = ScrubBehavior.Off
}

local function NumberInput(p1, p2) -- line: 150
	-- upvalues: withDefaults (copy), t2 (copy), useTokens (copy), useTextInputVariants (copy), useNumberInputVariants (copy), Flags (copy), React (copy), ReactUtils (copy), ScrubBehavior (copy), t1 (copy), mapBindable (copy), getBindableValue (copy), InputSize (copy), useTextSize (copy), useIconSize (copy), isBuilderIcon (copy), getMultiLineTextHeight (copy), Constants (copy), OnChangeCallbackReason (copy), NumberInputControlsVariant (copy), NumberInputControls (copy), calculateNumberInputValueFromPositions (copy), ReactIs (copy), InputField (copy), withCommonProps (copy), getInputTextSize (copy), InternalTextInput (copy), joinBindables (copy), View (copy), Icon (copy), Text (copy)
	local v45 = withDefaults(p1, t2)
	local v46 = useTokens()
	local v47 = useTextInputVariants(v46, v45.size, v45.variant)
	local v48 = useNumberInputVariants(v46, v45.size, if not Flags.FoundationNumberInputBeta then v45.controlsVariant else nil)
	local v49 = if not Flags.FoundationNumberInputBeta then nil else v48.controls
	local v50 = React.useRef(nil)
	local v51 = ReactUtils.useComposedRef(v50, v45.textBoxRef)
	local v52 = React.useRef(nil)
	local v53 = React.useCallback(function() -- line: 205
		-- upvalues: v50 (copy)
		if v50.current then
			return (v50.current.getIsFocused())
		end

		return false
	end, {})
	local v54, v55 = React.useState(false)
	local v56 = v45.hasError or v54
	local controlsVariant = v45.controlsVariant
	local v58 = if not v45.isScrubbable then v45.scrubBehavior else ScrubBehavior.On
	local v59 = v58 and v58 ~= ScrubBehavior.Off
	local v60 = if not Flags.FoundationNumberInputBeta then nil else t1[v58]
	local v61 = React.useCallback(function(n4: number) -- line: 217
		-- upvalues: v45 (copy)
		return (math.clamp(n4, v45.minimum, v45.maximum))
	end, {
		v45.minimum,
		v45.maximum
	})
	local v62 = React.useCallback(function(n5: number, p3: ((...any) -> ...any)) -- line: 221
		-- upvalues: v45 (copy)
		return p3(n5 / v45.step) * v45.step
	end, { v45.step })
	local v63 = React.useMemo(function() -- line: 225
		-- upvalues: mapBindable (copy), v45 (copy), v62 (copy), v61 (copy)
		return mapBindable(v45.value, function(p4) -- line: 226
			-- upvalues: v45 (copy), v62 (copy), v61 (copy)
			local v128 = 10 ^ (v45.precision or 0)
			local v129 = math.floor(p4 * v128 + 0.5) / v128
			local v130 = p4 + v45.step
			local v131 = 10 ^ (v45.precision or 0)
			local v132 = math.floor(v130 * v131 + 0.5) / v131
			local v133 = v62(p4, math.ceil)
			local v134 = 10 ^ (v45.precision or 0)
			local v135 = math.floor(v133 * v134 + 0.5) / v134

			if v129 ~= v135 then
				v132 = v135
			end

			return v61(v132)
		end)
	end, {
		v45.value,
		v45.step,
		v45.precision,
		v61,
		v62
	})
	local v64 = React.useMemo(function() -- line: 237
		-- upvalues: mapBindable (copy), v45 (copy), v62 (copy), v61 (copy)
		return mapBindable(v45.value, function(p5) -- line: 238
			-- upvalues: v45 (copy), v62 (copy), v61 (copy)
			local v137 = 10 ^ (v45.precision or 0)
			local v138 = math.floor(p5 * v137 + 0.5) / v137
			local v139 = p5 - v45.step
			local v140 = 10 ^ (v45.precision or 0)
			local v141 = math.floor(v139 * v140 + 0.5) / v140
			local v142 = v62(p5, math.floor)
			local v143 = 10 ^ (v45.precision or 0)
			local v144 = math.floor(v142 * v143 + 0.5) / v143

			if v138 ~= v144 then
				v141 = v144
			end

			return v61(v141)
		end)
	end, {
		v45.value,
		v45.step,
		v45.precision,
		v61,
		v62
	})
	local v65 = React.useMemo(function() -- line: 249
		-- upvalues: mapBindable (copy), v45 (copy)
		return mapBindable(v45.value, function(p6) -- line: 250
			-- upvalues: v45 (copy)
			return v45.isDisabled or p6 == v45.maximum
		end)
	end, {
		v45.isDisabled,
		v45.value,
		v45.maximum
	})
	local v66 = React.useMemo(function() -- line: 255
		-- upvalues: mapBindable (copy), v45 (copy)
		return mapBindable(v45.value, function(p7) -- line: 256
			-- upvalues: v45 (copy)
			return v45.isDisabled or p7 == v45.minimum
		end)
	end, {
		v45.isDisabled,
		v45.value,
		v45.minimum
	})
	local v67 = React.useCallback(function(n6: number) -- line: 261
		-- upvalues: v45 (copy)
		local v106 = math.clamp(n6, v45.minimum, v45.maximum)
		local v107 = 10 ^ (v45.precision or 0)

		return math.floor(v106 * v107 + 0.5) / v107
	end, {
		v45.minimum,
		v45.maximum,
		v45.precision
	})
	local v68, v69 = React.useBinding(v45.formatAsString(v67(getBindableValue(v45.value))))
	local v70 = if not Flags.FoundationNumberInputBeta then nil else if v45.size ~= InputSize.XSmall then v46.Gap.Small else v46.Gap.Small - v46.Gap.XSmall / 2
	local u71 = nil
	local u72 = nil
	local u73 = nil
	local u74 = nil

	if Flags.FoundationNumberInputBeta then
		local fontStyle = v47.textBox.fontStyle
		local FontSize = fontStyle.FontSize

		u71 = v45.prefix and v45.prefix ~= "" or v45.suffix and v45.suffix ~= ""

		local v77 = if not v45.prefix then nil else v45.prefix .. " "
		local v78 = React.useMemo(function() -- line: 287
			-- upvalues: fontStyle (copy), FontSize (copy)
			return {
				Font = fontStyle.Font,
				FontSize = math.floor(FontSize),
				LineHeight = fontStyle.LineHeight
			}
		end, {
			fontStyle,
			FontSize
		})

		u72 = useTextSize(v77, v78)

		local v79 = useIconSize(v47.icon.size, isBuilderIcon(v45.leadingIcon))
		local v80 = useIconSize(v47.icon.size, isBuilderIcon(v45.trailingIcon))
		local v81 = not v45.leadingIcon and 0 or v79.X.Offset
		local v82 = (not Flags.FoundationNumberInputBeta or not v45.trailingIcon) and 0 or v80.X.Offset
		local v83 = if v45.size ~= InputSize.XSmall then if v45.size ~= InputSize.Small then v46.Gap.Large else v46.Gap.Medium else v46.Gap.Small
		local v84 = not v45.leadingIcon and 0 or v83
		local v85 = (not Flags.FoundationNumberInputBeta or not v45.trailingIcon) and 0 or v83

		u74 = React.useMemo(function() -- line: 310
			-- upvalues: v47 (copy), v81 (copy), v84 (copy), v82 (copy), v85 (copy)
			return {
				left = UDim.new(0, v47.container.horizontalPadding.Offset + v81 + v84),
				right = UDim.new(0, v47.container.horizontalPadding.Offset + v82 + v85)
			}
		end, {
			v47.container.horizontalPadding,
			v84,
			v85,
			v81,
			v82
		})
		u73 = React.useMemo(function() -- line: 334
			-- upvalues: getMultiLineTextHeight (copy), FontSize (copy), fontStyle (copy), v47 (copy)
			local v108 = getMultiLineTextHeight(FontSize, 1, fontStyle.LineHeight)
			local v109 = math.round((v47.container.minHeight - 2 - v108) * 2) / 2

			return {
				top = UDim.new(0, math.floor(v109 / 2) + 1),
				bottom = UDim.new(0, math.ceil(v109 / 2) + 1),
				left = UDim.new(),
				right = UDim.new()
			}
		end, {
			v47.container.minHeight,
			fontStyle,
			FontSize
		})
	end

	local v86 = if not v45.width then if not Flags.FoundationNumberInputBeta then UDim.new(0, v48.container.width) else UDim.new(0, Constants.DEFAULT_NUMBER_INPUT_WIDTH) else v45.width
	local v87 = React.useCallback(function() -- line: 361
		-- upvalues: v69 (copy), getBindableValue (copy), v45 (copy)
		v69((tostring(getBindableValue(v45.value))))

		if v45.onFocusGained then
			v45.onFocusGained()
		end
	end, {
		v45.onFocusGained,
		v45.value
	})
	local v88 = React.useCallback(function(n7: number, p8) -- line: 369
		-- upvalues: v67 (copy), v69 (copy), v53 (copy), v45 (copy)
		local v112 = v67(n7)

		v69(if not v53() then v45.formatAsString(v112) else tostring(v112))
		v45.onChanged(v112, p8)
	end, {
		v45.onChanged,
		v45.formatAsString,
		v67,
		v53
	})
	local v89 = React.useCallback(function(p9) -- line: 375
		-- upvalues: v55 (copy), v88 (copy), getBindableValue (copy), v45 (copy), OnChangeCallbackReason (copy)
		v55(false)
		v88(getBindableValue(v45.value), OnChangeCallbackReason.FocusLost)

		if v45.onFocusLost then
			v45.onFocusLost(p9)
		end
	end, {
		v88,
		v45.onFocusLost,
		v45.value,
		v67
	})
	local v90 = React.useCallback(function(p10) -- line: 385
		-- upvalues: v69 (copy), v53 (copy), Flags (copy), v45 (copy), v55 (copy), OnChangeCallbackReason (copy)
		v69(p10)

		if not v53() then
			return
		end

		if Flags.FoundationNumberInputOnTextChanged then
			local num = tonumber(p10)

			if v45.onTextChanged ~= nil then
				v45.onTextChanged(p10)
			elseif num == nil then
				v55(true)

				return
			end

			if num ~= nil then
				v55(false)
				v45.onChanged(num, OnChangeCallbackReason.Keyboard)

				return
			end
		else
			local num = tonumber(p10)

			if num == nil then
				v55(true)

				return
			end

			v55(false)
			v45.onChanged(num, OnChangeCallbackReason.Keyboard)
		end
	end, {
		v53,
		v45.onChanged,
		if not Flags.FoundationNumberInputOnTextChanged then nil else v45.onTextChanged
	})
	local v91 = React.useCallback(function() -- line: 419
		-- upvalues: getBindableValue (copy), v65 (copy), v88 (copy), v63 (copy), OnChangeCallbackReason (copy)
		if getBindableValue(v65) then
			return
		end

		v88(getBindableValue(v63), OnChangeCallbackReason.Activate)
	end, {
		v65,
		v63,
		v88
	})
	local v92 = React.useCallback(function() -- line: 426
		-- upvalues: getBindableValue (copy), v66 (copy), v88 (copy), v64 (copy), OnChangeCallbackReason (copy)
		if getBindableValue(v66) then
			return
		end

		v88(getBindableValue(v64), OnChangeCallbackReason.Activate)
	end, {
		v66,
		v64,
		v88
	})
	local v93 = if not Flags.FoundationNumberInputBeta then nil else v45.hasControls and (controlsVariant ~= NumberInputControlsVariant.None and controlsVariant ~= NumberInputControlsVariant.Stacked)
	local v94 = if not (not not Flags.FoundationNumberInputBeta and v93) and Flags.FoundationNumberInputBeta then nil else React.createElement(NumberInputControls, {
		variant = v45.variant,
		controlsVariant = if not Flags.FoundationNumberInputBeta then controlsVariant else nil,
		size = v45.size,
		increment = {
			isDisabled = v65,
			onClick = v91
		},
		decrement = {
			isDisabled = v66,
			onClick = v92
		},
		testId = v45.testId
	})
	local v95 = React.useMemo(function() -- line: 459
		-- upvalues: Flags (copy), v93 (copy), v49 (copy), v70 (copy), controlsVariant (copy), NumberInputControlsVariant (copy), v48 (copy), v46 (copy)
		if Flags.FoundationNumberInputBeta then
			if v93 then
				return UDim.new(0, v49.width + v70)
			end
		elseif controlsVariant == NumberInputControlsVariant.Split then
			return UDim.new(0, 2 * v48.splitButton.size + 2 * v46.Gap.XSmall)
		end

		return UDim.new()
	end, {
		v46,
		controlsVariant,
		if not Flags.FoundationNumberInputBeta then v48.splitButton.size else nil,
		v46.Gap.XSmall,
		if not Flags.FoundationNumberInputBeta then nil else v49,
		if not Flags.FoundationNumberInputBeta then nil else v70,
		if not Flags.FoundationNumberInputBeta then nil else v93
	})
	local v96 = React.useCallback(function(_, vector2: Vector2) -- line: 481
		-- upvalues: v45 (copy), v52 (copy), getBindableValue (copy)
		local value = v45.value

		if value then
			v52.current = {
				position = vector2.X,
				value = getBindableValue(value)
			}
		end
	end, { v45.value })
	local v97 = React.useCallback(function(_, vector2: Vector2) -- line: 492
		-- upvalues: v52 (copy), calculateNumberInputValueFromPositions (copy), v45 (copy), Flags (copy), v60 (copy), v88 (copy), OnChangeCallbackReason (copy)
		if v52.current then
			local v122 = calculateNumberInputValueFromPositions(v52.current.value, v52.current.position, vector2.X, v45.step, if not Flags.FoundationNumberInputBeta then nil else v60)

			v88(v122, OnChangeCallbackReason.Drag)
		end
	end, {
		v88,
		v45.step,
		v67,
		if not Flags.FoundationNumberInputBeta then nil else v60
	})
	local v98 = React.useCallback(function() -- line: 512
		-- upvalues: v52 (copy)
		if v52.current then
			v52.current = nil
		end
	end, {})
	local Shift_300Transparency = v46.Color.Shift.Shift_300.Transparency
	local Shift_100Transparency = v46.Color.Shift.Shift_100.Transparency
	local v101 = React.useMemo(function() -- line: 521
		-- upvalues: mapBindable (copy), v45 (copy), v61 (copy), Shift_100Transparency (copy), Shift_300Transparency (copy)
		return mapBindable(v45.value, function(p13) -- line: 522
			-- upvalues: v45 (copy), v61 (copy), Shift_100Transparency (copy), Shift_300Transparency (copy)
			local n8 = 0

			if p13 and (v45.maximum and v45.minimum) then
				local v149 = v61(p13)

				n8 = if v45.maximum ~= v45.minimum then (v149 - v45.minimum) / (v45.maximum - v45.minimum) else 1
			end

			if n8 == 0 then
				return NumberSequence.new(Shift_100Transparency)
			end

			if n8 == 1 then
				return NumberSequence.new(Shift_300Transparency)
			end

			if n8 > 0 or n8 < 1 then
				local t3 = {
					NumberSequenceKeypoint.new(0, Shift_300Transparency),
					NumberSequenceKeypoint.new(n8, Shift_300Transparency),
					NumberSequenceKeypoint.new(math.min(n8 + 0.001, 1), Shift_100Transparency)
				}

				if n8 < 0.999 then
					table.insert(t3, NumberSequenceKeypoint.new(1, Shift_100Transparency))
				end

				return NumberSequence.new(t3)
			end

			return NumberSequence.new(Shift_100Transparency)
		end)
	end, {
		Shift_300Transparency,
		Shift_100Transparency,
		v45.value,
		v61,
		v45.maximum,
		v45.minimum
	})

	React.useEffect(function() -- line: 565
		-- upvalues: v53 (copy), ReactIs (copy), v45 (copy), v69 (copy), v67 (copy)
		if not v53() and not ReactIs.isBinding(v45.value) then
			v69(v45.formatAsString(v67(v45.value)))
		end
	end, {
		v45.value,
		v45.formatAsString,
		v67,
		v53
	})

	return React.createElement(InputField, withCommonProps(v45, {
		width = v86,
		ref = p2,
		hasError = v56,
		label = v45.label,
		size = getInputTextSize(v45.size),
		isRequired = v45.isRequired,
		isDisabled = v45.isDisabled,
		hint = v45.hint,
		textBoxRef = v51,
		input = function(p14) -- line: 584
			-- upvalues: Flags (copy), v93 (copy), v94 (copy), controlsVariant (copy), NumberInputControlsVariant (copy), React (copy), InternalTextInput (copy), v45 (copy), joinBindables (copy), v68 (copy), v53 (copy), v67 (copy), v56 (copy), v47 (copy), u72 (ref), p1 (copy), v90 (copy), v89 (copy), v87 (copy), v59 (copy), v96 (copy), v97 (copy), v98 (copy), v101 (copy), v46 (copy), View (copy), Icon (copy), u71 (ref), Text (copy), u74 (ref), u73 (ref), v86 (copy), v95 (copy), v70 (copy)
			local v124 = if not Flags.FoundationNumberInputBeta then controlsVariant == NumberInputControlsVariant.Split else v93 and v94
			local v125 = React.createElement(InternalTextInput, {
				inputRef = v45.inputRef,
				text = joinBindables({
					text = v68,
					value = v45.value
				}, function(p15) -- line: 594
					-- upvalues: v53 (copy), v45 (copy), v67 (copy)
					if v53() then
						return p15.text
					end

					return v45.formatAsString(v67(p15.value))
				end),
				hasError = v56,
				variant = v45.variant,
				size = v45.size,
				Selectable = if not Flags.FoundationInputSelectionProps then nil else v45.Selectable,
				NextSelectionUp = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionUp,
				NextSelectionDown = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionDown,
				NextSelectionLeft = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionLeft,
				NextSelectionRight = if not Flags.FoundationInputSelectionProps then nil else v45.NextSelectionRight,
				horizontalPadding = {
					left = v47.container.horizontalPadding,
					right = if not Flags.FoundationNumberInputBeta then nil else v47.container.horizontalPadding,
					innerLeft = if not Flags.FoundationNumberInputBeta then nil else if not u72 or not (u72.X > 0) then nil else UDim.new(0, u72.X)
				},
				focusBehavior = p1.focusBehavior,
				onChanged = v90,
				onFocusLost = v89,
				onFocus = v87,
				onDragStarted = if not v59 then nil else v96,
				onDrag = if not v59 then nil else v97,
				onDragEnded = if not v59 then nil else v98,
				onReturnPressed = v45.onReturnPressed,
				ref = p14,
				backgroundGradient = if not v59 or not v101 then nil else React.createElement("UIGradient", {
					Rotation = 0,
					Color = ColorSequence.new(v46.Color.Shift.Shift_300.Color3),
					Transparency = v101
				}),
				trailingElement = if not Flags.FoundationNumberInputBeta then if controlsVariant ~= NumberInputControlsVariant.Stacked then nil else v94 else if not v45.trailingIcon then nil else React.createElement(View, {
					tag = "row align-y-center size-0-full auto-x"
				}, React.createElement(Icon, {
					name = v45.trailingIcon,
					style = v47.icon.style,
					size = v47.icon.size
				})),
				leadingElement = if not v45.leadingIcon then nil else React.createElement(View, {
					tag = "row align-y-center size-0-full auto-x"
				}, React.createElement(Icon, {
					name = v45.leadingIcon,
					style = v47.icon.style,
					size = v47.icon.size
				})),
				isDisabled = v45.isDisabled,
				LayoutOrder = if not v124 or not Flags.FoundationNumberInputBeta then nil else 0,
				testId = `{ v45.testId }--field`
			})
			local v126 = if not Flags.FoundationNumberInputBeta or not u71 then nil else React.createElement(Text, {
				tag = "text-align-x-left text-align-y-center content-muted",
				RichText = true,
				ClipsDescendants = true,
				fontStyle = v47.textBox.fontStyle,
				Size = UDim2.new(1, -(u74.left.Offset + u74.right.Offset), 1, 0),
				Position = UDim2.fromOffset(u74.left.Offset, 0),
				Text = v68:map(function(p16) -- line: 678
					-- upvalues: v45 (copy)
					return `{ not v45.prefix and "" or v45.prefix .. " " }<font transparency="1">{ p16 }</font>{ not v45.suffix and "" or " " .. v45.suffix }`
				end),
				padding = u73,
				testId = `{ v45.testId }--units`
			})

			if Flags.FoundationNumberInputBeta then
				v125 = React.createElement(View, {
					tag = "size-full-0 auto-y"
				}, {
					Input = v125,
					Units = v126
				})
			end

			if v124 or Flags.FoundationNumberInputBeta then
				return (React.createElement(View, {
					Size = if not Flags.FoundationNumberInputBeta then UDim2.fromOffset(v86.Offset - v95.Offset, 0) else UDim2.new(v86.Scale - v95.Scale, v86.Offset - v95.Offset, 0, 0),
					tag = not Flags.FoundationNumberInputBeta and "row align-y-center gap-xsmall auto-y" or "row align-y-center auto-y",
					layout = if not Flags.FoundationNumberInputBeta then nil else {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, v70),
						SortOrder = Enum.SortOrder.LayoutOrder
					}
				}, {
					InputField = v125,
					Controls = if not v124 then nil else v94
				}))
			end

			return v125
		end
	}))
end

return React.memo(React.forwardRef(NumberInput))
