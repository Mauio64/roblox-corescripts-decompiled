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
local calculateNumberInputValueFromPositions = require(script.Parent.calculateNumberInputValueFromPositions)

require(Foundation.Enums.InputFocusBehavior)

local function round(n1: number, n2: number?) -- line: 57
	local v38 = 10 ^ (n2 or 0)

	return math.floor(n1 * v38 + 0.5) / v38
end
local function defaultFormatAsString(n3: number) -- line: 109
	return (tostring(n3))
end

local t1 = {
	minimum = -1e999,
	maximum = 1e999,
	step = 1,
	precision = 3,
	value = 0,
	isScrubbable = false,
	testId = "--foundation-number-input",
	variant = InputVariant.Standard,
	controlsVariant = NumberInputControlsVariant.Stacked,
	size = InputSize.Large,
	formatAsString = defaultFormatAsString
}

local function NumberInput(p1, p2) -- line: 127
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useTextInputVariants (copy), useNumberInputVariants (copy), React (copy), ReactUtils (copy), mapBindable (copy), getBindableValue (copy), Flags (copy), useTextSize (copy), useIconSize (copy), isBuilderIcon (copy), InputSize (copy), getMultiLineTextHeight (copy), OnChangeCallbackReason (copy), NumberInputControls (copy), NumberInputControlsVariant (copy), calculateNumberInputValueFromPositions (copy), ReactIs (copy), InputField (copy), withCommonProps (copy), getInputTextSize (copy), InternalTextInput (copy), joinBindables (copy), View (copy), Icon (copy), Text (copy)
	local v42 = withDefaults(p1, t1)
	local v43 = useTokens()
	local v44 = useTextInputVariants(v43, v42.size, v42.variant)
	local v45 = useNumberInputVariants(v43, v42.size, v42.controlsVariant)
	local v46 = React.useRef(nil)
	local v47 = ReactUtils.useComposedRef(v46, v42.textBoxRef)
	local v48 = React.useRef(nil)
	local v49 = React.useCallback(function() -- line: 170
		-- upvalues: v46 (copy)
		if v46.current then
			return (v46.current.getIsFocused())
		end

		return false
	end, {})
	local v50, v51 = React.useState(false)
	local v52 = v42.hasError or v50
	local controlsVariant = v42.controlsVariant
	local v54 = React.useCallback(function(n4: number) -- line: 178
		-- upvalues: v42 (copy)
		return (math.clamp(n4, v42.minimum, v42.maximum))
	end, {
		v42.minimum,
		v42.maximum
	})
	local v55 = React.useCallback(function(n5: number, p3: ((...any) -> ...any)) -- line: 182
		-- upvalues: v42 (copy)
		return p3(n5 / v42.step) * v42.step
	end, { v42.step })
	local v56 = React.useMemo(function() -- line: 186
		-- upvalues: mapBindable (copy), v42 (copy), v55 (copy), v54 (copy)
		return mapBindable(v42.value, function(p4) -- line: 187
			-- upvalues: v42 (copy), v55 (copy), v54 (copy)
			local v114 = 10 ^ (v42.precision or 0)
			local v115 = math.floor(p4 * v114 + 0.5) / v114
			local v116 = p4 + v42.step
			local v117 = 10 ^ (v42.precision or 0)
			local v118 = math.floor(v116 * v117 + 0.5) / v117
			local v119 = v55(p4, math.ceil)
			local v120 = 10 ^ (v42.precision or 0)
			local v121 = math.floor(v119 * v120 + 0.5) / v120

			if v115 ~= v121 then
				v118 = v121
			end

			return v54(v118)
		end)
	end, {
		v42.value,
		v42.step,
		v42.precision,
		v54,
		v55
	})
	local v57 = React.useMemo(function() -- line: 198
		-- upvalues: mapBindable (copy), v42 (copy), v55 (copy), v54 (copy)
		return mapBindable(v42.value, function(p5) -- line: 199
			-- upvalues: v42 (copy), v55 (copy), v54 (copy)
			local v123 = 10 ^ (v42.precision or 0)
			local v124 = math.floor(p5 * v123 + 0.5) / v123
			local v125 = p5 - v42.step
			local v126 = 10 ^ (v42.precision or 0)
			local v127 = math.floor(v125 * v126 + 0.5) / v126
			local v128 = v55(p5, math.floor)
			local v129 = 10 ^ (v42.precision or 0)
			local v130 = math.floor(v128 * v129 + 0.5) / v129

			if v124 ~= v130 then
				v127 = v130
			end

			return v54(v127)
		end)
	end, {
		v42.value,
		v42.step,
		v42.precision,
		v54,
		v55
	})
	local v58 = React.useMemo(function() -- line: 210
		-- upvalues: mapBindable (copy), v42 (copy)
		return mapBindable(v42.value, function(p6) -- line: 211
			-- upvalues: v42 (copy)
			return v42.isDisabled or p6 == v42.maximum
		end)
	end, {
		v42.isDisabled,
		v42.value,
		v42.maximum
	})
	local v59 = React.useMemo(function() -- line: 216
		-- upvalues: mapBindable (copy), v42 (copy)
		return mapBindable(v42.value, function(p7) -- line: 217
			-- upvalues: v42 (copy)
			return v42.isDisabled or p7 == v42.minimum
		end)
	end, {
		v42.isDisabled,
		v42.value,
		v42.minimum
	})
	local v60 = React.useCallback(function(n6: number) -- line: 222
		-- upvalues: v42 (copy)
		local v93 = math.clamp(n6, v42.minimum, v42.maximum)
		local v94 = 10 ^ (v42.precision or 0)

		return math.floor(v93 * v94 + 0.5) / v94
	end, {
		v42.minimum,
		v42.maximum,
		v42.precision
	})
	local v61, v62 = React.useBinding(v42.formatAsString(v60(getBindableValue(v42.value))))
	local u63 = nil
	local u64 = nil
	local u65 = nil

	if Flags.FoundationSupportPrefixSuffixNumberInput then
		local fontStyle = v44.textBox.fontStyle
		local FontSize = fontStyle.FontSize

		u63 = v42.prefix and v42.prefix ~= "" or v42.suffix and v42.suffix ~= ""

		local v68 = if not v42.prefix then nil else v42.prefix .. " "
		local v69 = React.useMemo(function() -- line: 243
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

		u64 = useTextSize(v68, v69)

		local v70 = useIconSize(v44.icon.size, isBuilderIcon(v42.leadingIcon))
		local v71 = not v42.leadingIcon and 0 or v70.X.Offset
		local v72 = if v42.size ~= InputSize.XSmall then if v42.size ~= InputSize.Small then v43.Gap.Large else v43.Gap.Medium else v43.Gap.Small
		local v73 = not v42.leadingIcon and 0 or v72

		u65 = React.useMemo(function() -- line: 263
			-- upvalues: getMultiLineTextHeight (copy), FontSize (copy), fontStyle (copy), v44 (copy), v71 (copy), v73 (copy)
			local v95 = getMultiLineTextHeight(FontSize, 1, fontStyle.LineHeight)
			local v96 = math.round((v44.container.minHeight - 2 - v95) * 2) / 2

			return {
				left = UDim.new(0, v44.container.horizontalPadding.Offset + v71 + v73),
				right = v44.container.horizontalPadding,
				top = UDim.new(0, math.floor(v96 / 2) + 1),
				bottom = UDim.new(0, math.ceil(v96 / 2) + 1)
			}
		end, {
			v44.container.minHeight,
			v44.container.horizontalPadding,
			fontStyle,
			v71,
			v73,
			FontSize
		})
	end

	local v74 = if not v42.width then UDim.new(0, v45.container.width) else v42.width
	local v75 = React.useCallback(function() -- line: 295
		-- upvalues: v62 (copy), getBindableValue (copy), v42 (copy)
		v62((tostring(getBindableValue(v42.value))))

		if v42.onFocusGained then
			v42.onFocusGained()
		end
	end, {
		v42.onFocusGained,
		v42.value
	})
	local v76 = React.useCallback(function(n7: number, p8) -- line: 303
		-- upvalues: v60 (copy), v62 (copy), v49 (copy), v42 (copy)
		local v99 = v60(n7)

		v62(if not v49() then v42.formatAsString(v99) else tostring(v99))
		v42.onChanged(v99, p8)
	end, {
		v42.onChanged,
		v42.formatAsString,
		v60,
		v49
	})
	local v77 = React.useCallback(function(p9) -- line: 309
		-- upvalues: v51 (copy), v76 (copy), getBindableValue (copy), v42 (copy), OnChangeCallbackReason (copy)
		v51(false)
		v76(getBindableValue(v42.value), OnChangeCallbackReason.FocusLost)

		if v42.onFocusLost then
			v42.onFocusLost(p9)
		end
	end, {
		v76,
		v42.onFocusLost,
		v42.value,
		v60
	})
	local v78 = React.useCallback(function(p10) -- line: 318
		-- upvalues: v62 (copy), v49 (copy), v51 (copy), v42 (copy), OnChangeCallbackReason (copy)
		v62(p10)

		if not v49() then
			return
		end

		local num = tonumber(p10)

		if num == nil then
			v51(true)

			return
		end

		v51(false)
		v42.onChanged(num, OnChangeCallbackReason.Keyboard)
	end, {
		v49,
		v42.onChanged
	})
	local v79 = React.useCallback(function() -- line: 334
		-- upvalues: getBindableValue (copy), v58 (copy), v76 (copy), v56 (copy), OnChangeCallbackReason (copy)
		if getBindableValue(v58) then
			return
		end

		v76(getBindableValue(v56), OnChangeCallbackReason.Activate)
	end, {
		v58,
		v56,
		v76
	})
	local v80 = React.useCallback(function() -- line: 341
		-- upvalues: getBindableValue (copy), v59 (copy), v76 (copy), v57 (copy), OnChangeCallbackReason (copy)
		if getBindableValue(v59) then
			return
		end

		v76(getBindableValue(v57), OnChangeCallbackReason.Activate)
	end, {
		v59,
		v57,
		v76
	})
	local v81 = React.createElement(NumberInputControls, {
		variant = v42.variant,
		controlsVariant = controlsVariant,
		size = v42.size,
		increment = {
			isDisabled = v58,
			onClick = v79
		},
		decrement = {
			isDisabled = v59,
			onClick = v80
		},
		testId = v42.testId
	})
	local v82 = React.useMemo(function() -- line: 364
		-- upvalues: controlsVariant (copy), NumberInputControlsVariant (copy), v45 (copy), v43 (copy)
		if controlsVariant == NumberInputControlsVariant.Split then
			return UDim.new(0, 2 * v45.splitButton.size + 2 * v43.Gap.XSmall)
		end

		return UDim.new()
	end, {
		v43,
		controlsVariant,
		v45.splitButton.size,
		v43.Gap.XSmall
	})
	local v83 = React.useCallback(function(_, vector2: Vector2) -- line: 374
		-- upvalues: v42 (copy), v48 (copy), getBindableValue (copy)
		local value = v42.value

		if value then
			v48.current = {
				position = vector2.X,
				value = getBindableValue(value)
			}
		end
	end, { v42.value })
	local v84 = React.useCallback(function(_, vector2: Vector2) -- line: 384
		-- upvalues: v48 (copy), calculateNumberInputValueFromPositions (copy), v42 (copy), v76 (copy), OnChangeCallbackReason (copy)
		if v48.current then
			local v108 = calculateNumberInputValueFromPositions(v48.current.value, v48.current.position, vector2.X, v42.step)

			v76(v108, OnChangeCallbackReason.Drag)
		end
	end, {
		v76,
		v42.step,
		v60
	})
	local v85 = React.useCallback(function() -- line: 396
		-- upvalues: v48 (copy)
		if v48.current then
			v48.current = nil
		end
	end, {})
	local Shift_300Transparency = v43.Color.Shift.Shift_300.Transparency
	local Shift_100Transparency = v43.Color.Shift.Shift_100.Transparency
	local v88 = React.useMemo(function() -- line: 405
		-- upvalues: mapBindable (copy), v42 (copy), v54 (copy), Shift_100Transparency (copy), Shift_300Transparency (copy)
		return mapBindable(v42.value, function(p13) -- line: 406
			-- upvalues: v42 (copy), v54 (copy), Shift_100Transparency (copy), Shift_300Transparency (copy)
			local n8 = 0

			if p13 and (v42.maximum and v42.minimum) then
				local v135 = v54(p13)

				n8 = if v42.maximum ~= v42.minimum then (v135 - v42.minimum) / (v42.maximum - v42.minimum) else 1
			end

			if n8 == 0 then
				return NumberSequence.new(Shift_100Transparency)
			end

			if n8 == 1 then
				return NumberSequence.new(Shift_300Transparency)
			end

			if n8 > 0 or n8 < 1 then
				local t2 = {
					NumberSequenceKeypoint.new(0, Shift_300Transparency),
					NumberSequenceKeypoint.new(n8, Shift_300Transparency),
					NumberSequenceKeypoint.new(math.min(n8 + 0.001, 1), Shift_100Transparency)
				}

				if n8 < 0.999 then
					table.insert(t2, NumberSequenceKeypoint.new(1, Shift_100Transparency))
				end

				return NumberSequence.new(t2)
			end

			return NumberSequence.new(Shift_100Transparency)
		end)
	end, {
		Shift_300Transparency,
		Shift_100Transparency,
		v42.value,
		v54,
		v42.maximum,
		v42.minimum
	})

	React.useEffect(function() -- line: 449
		-- upvalues: v49 (copy), ReactIs (copy), v42 (copy), v62 (copy), v60 (copy)
		if not v49() and not ReactIs.isBinding(v42.value) then
			v62(v42.formatAsString(v60(v42.value)))
		end
	end, {
		v42.value,
		v42.formatAsString,
		v60,
		v49
	})

	return React.createElement(InputField, withCommonProps(v42, {
		width = v74,
		ref = p2,
		hasError = v52,
		label = v42.label,
		size = getInputTextSize(v42.size),
		isRequired = v42.isRequired,
		isDisabled = v42.isDisabled,
		hint = v42.hint,
		textBoxRef = v47,
		input = function(p14) -- line: 467
			-- upvalues: controlsVariant (copy), NumberInputControlsVariant (copy), React (copy), InternalTextInput (copy), v42 (copy), joinBindables (copy), v61 (copy), v49 (copy), v60 (copy), v52 (copy), Flags (copy), v44 (copy), u64 (ref), p1 (copy), v78 (copy), v77 (copy), v75 (copy), v83 (copy), v84 (copy), v85 (copy), v88 (copy), v43 (copy), v81 (copy), View (copy), Icon (copy), u63 (ref), Text (copy), u65 (ref), v74 (copy), v82 (copy)
			local v110 = controlsVariant == NumberInputControlsVariant.Split
			local v111 = React.createElement(InternalTextInput, {
				inputRef = v42.inputRef,
				text = joinBindables({
					text = v61,
					value = v42.value
				}, function(p15) -- line: 475
					-- upvalues: v49 (copy), v42 (copy), v60 (copy)
					if v49() then
						return p15.text
					end

					return v42.formatAsString(v60(p15.value))
				end),
				hasError = v52,
				variant = v42.variant,
				size = v42.size,
				Selectable = if not Flags.FoundationInputSelectionProps then nil else v42.Selectable,
				NextSelectionUp = if not Flags.FoundationInputSelectionProps then nil else v42.NextSelectionUp,
				NextSelectionDown = if not Flags.FoundationInputSelectionProps then nil else v42.NextSelectionDown,
				NextSelectionLeft = if not Flags.FoundationInputSelectionProps then nil else v42.NextSelectionLeft,
				NextSelectionRight = if not Flags.FoundationInputSelectionProps then nil else v42.NextSelectionRight,
				horizontalPadding = {
					left = v44.container.horizontalPadding,
					innerLeft = if not Flags.FoundationSupportPrefixSuffixNumberInput then nil else if not u64 or not (u64.X > 0) then nil else UDim.new(0, u64.X)
				},
				focusBehavior = p1.focusBehavior,
				onChanged = v78,
				onFocusLost = v77,
				onFocus = v75,
				onDragStarted = if not v42.isScrubbable then nil else v83,
				onDrag = if not v42.isScrubbable then nil else v84,
				onDragEnded = if not v42.isScrubbable then nil else v85,
				onReturnPressed = v42.onReturnPressed,
				ref = p14,
				backgroundGradient = if not v42.isScrubbable or not v88 then nil else React.createElement("UIGradient", {
					Rotation = 0,
					Color = ColorSequence.new(v43.Color.Shift.Shift_300.Color3),
					Transparency = v88
				}),
				trailingElement = if controlsVariant ~= NumberInputControlsVariant.Stacked then nil else v81,
				leadingElement = if not v42.leadingIcon then nil else React.createElement(View, {
					tag = "row align-y-center size-0-full auto-x"
				}, React.createElement(Icon, {
					name = v42.leadingIcon,
					style = v44.icon.style,
					size = v44.icon.size
				})),
				isDisabled = v42.isDisabled,
				testId = `{ v42.testId }--field`
			})
			local v112 = if not Flags.FoundationSupportPrefixSuffixNumberInput or not u63 then nil else React.createElement(Text, {
				tag = "size-full text-align-x-left text-align-y-center content-muted",
				RichText = true,
				ClipsDescendants = true,
				fontStyle = v44.textBox.fontStyle,
				Text = v61:map(function(p16) -- line: 540
					-- upvalues: v42 (copy)
					return `{ not v42.prefix and "" or v42.prefix .. " " }<font transparency="1">{ p16 }</font>{ not v42.suffix and "" or " " .. v42.suffix }`
				end),
				padding = u65,
				testId = `{ v42.testId }--units`
			})

			if Flags.FoundationSupportPrefixSuffixNumberInput then
				v111 = React.createElement(View, {
					tag = "size-full-0 auto-y"
				}, {
					Input = v111,
					Units = v112
				})
			end

			if v110 then
				return (React.createElement(View, {
					tag = "row align-y-center gap-xsmall auto-y",
					Size = UDim2.fromOffset(v74.Offset - v82.Offset, 0)
				}, {
					InputField = v111,
					Controls = if not v110 then nil else v81
				}))
			end

			return v111
		end
	}))
end

return React.memo(React.forwardRef(NumberInput))
