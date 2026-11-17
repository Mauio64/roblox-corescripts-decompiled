local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local ReactUtils = require(parent.ReactUtils)

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

local function round(p: number, precision: number?) -- 7 equivalent calls inferred from this helper
	local v = 10 ^ (precision or 0)
	return math.floor(p * v + 0.5) / v
end

local v = { [ScrubBehavior.On] = 1, [ScrubBehavior.Off] = 0 }

local function defaultFormatAsString(p: number)
	return (tostring(p))
end

local v2 = {
	variant = InputVariant.Standard,
	size = InputSize.Large,
	minimum = -1e999,
	maximum = 1e999,
	step = 1,
	precision = 3,
	value = 0,
	formatAsString = defaultFormatAsString,
	isScrubbable = false,
	scrubBehavior = ScrubBehavior.Off,
	hasControls = false,
	testId = "--foundation-number-input"
}

local function NumberInput(p, ref5)
	local v3 = withDefaults(p, v2)

	local v4 = useTokens()
	local v5 = useTextInputVariants(v4, v3.size, v3.variant)
	local controls = useNumberInputVariants(v4, v3.size).controls

	local ref = React.useRef(nil)

	local textBoxRef = ReactUtils.useComposedRef(ref, v3.textBoxRef)

	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)

	local v6 = React.useCallback(function()
		if ref.current then
			return (ref.current.getIsFocused())
		end

		return false
	end, {})

	local state, setState = React.useState(false)
	local hasError = v3.hasError or state
	local controlsVariant = v3.controlsVariant
	local v7

	if v3.isScrubbable then
		v7 = ScrubBehavior.On
	else
		v7 = v3.scrubBehavior
	end

	local v8 = v7 and v7 ~= ScrubBehavior.Off

	local v9 = v[v7]
	local v10 = React.useCallback(function(value: number)
		return (math.clamp(value, v3.minimum, v3.maximum))
	end, { v3.minimum, v3.maximum })

	local v11 = React.useCallback(function(p2: number, callback)
		return callback(p2 / v3.step) * v3.step
	end, { v3.step })

	local v12 = React.useMemo(function()
		return mapBindable(v3.value, function(p2)
			local v12 = round(p2, v3.precision) -- inferred equivalent call
			local v13 = round(p2 + v3.step, v3.precision) -- inferred equivalent call
			local v14 = round(v11(p2, math.ceil), v3.precision) -- inferred equivalent call

			if v12 ~= v14 then
				v13 = v14
			end

			return v10(v13)
		end)
	end, { v3.value, v3.step, v3.precision, v10, v11 })

	local v13 = React.useMemo(function()
		return mapBindable(v3.value, function(p2)
			local v13 = round(p2, v3.precision) -- inferred equivalent call
			local v14 = round(p2 - v3.step, v3.precision) -- inferred equivalent call
			local v15 = round(v11(p2, math.floor), v3.precision) -- inferred equivalent call

			if v13 ~= v15 then
				v14 = v15
			end

			return v10(v14)
		end)
	end, { v3.value, v3.step, v3.precision, v10, v11 })

	local isDisabled = React.useMemo(function()
		return mapBindable(v3.value, function(p2)
			return v3.isDisabled or p2 == v3.maximum
		end)
	end, { v3.isDisabled, v3.value, v3.maximum })

	local isDisabled2 = React.useMemo(function()
		return mapBindable(v3.value, function(p2)
			return v3.isDisabled or p2 == v3.minimum
		end)
	end, { v3.isDisabled, v3.value, v3.minimum })

	local v14 = React.useCallback(function(value: number)
		return round(math.clamp(value, v3.minimum, v3.maximum), v3.precision) -- inferred equivalent call
	end, { v3.minimum, v3.maximum, v3.precision })

	local text, v15 = React.useBinding(v3.formatAsString(v14(getBindableValue(v3.value))))
	local v16

	if v3.size == InputSize.XSmall then
		v16 = v4.Gap.Small - v4.Gap.XSmall / 2
	else
		v16 = v4.Gap.Small
	end

	local fontStyle = v5.textBox.fontStyle
	local fontSize = fontStyle.FontSize

	local v17 = v3.prefix and v3.prefix ~= "" and true or v3.suffix and v3.suffix ~= ""
	local v18

	if v3.prefix then
		v18 = v3.prefix .. " "
	end

	local v19 = useTextSize(v18, (React.useMemo(function()
		return {
			Font = fontStyle.Font,
			FontSize = math.floor(fontSize),
			LineHeight = fontStyle.LineHeight
		}
	end, { fontStyle, fontSize })))

	local v20 = useIconSize(v5.icon.size, isBuilderIcon(v3.leadingIcon))
	local v21 = useIconSize(v5.icon.size, isBuilderIcon(v3.trailingIcon))
	local v22 = not v3.leadingIcon and 0 or v20.X.Offset
	local v23 = not v3.trailingIcon and 0 or v21.X.Offset
	local v24

	if v3.size == InputSize.XSmall then
		v24 = v4.Gap.Small
	elseif v3.size == InputSize.Small then
		v24 = v4.Gap.Medium
	else
		v24 = v4.Gap.Large
	end

	local v25 = not v3.leadingIcon and 0 or v24
	local v26 = not v3.trailingIcon and 0 or v24

	local v27 = React.useMemo(function()
		return {
			left = UDim.new(0, v5.container.horizontalPadding.Offset + v22 + v25),
			right = UDim.new(0, v5.container.horizontalPadding.Offset + v23 + v26)
		}
	end, { v5.container.horizontalPadding, v25, v26, v22, v23 })

	local padding = React.useMemo(function()
		local multiLineTextHeight = getMultiLineTextHeight(fontSize, 1, fontStyle.LineHeight)

		local v28 = math.round((v5.container.minHeight - 2 - multiLineTextHeight) * 2) / 2

		return {
			top = UDim.new(0, math.floor(v28 / 2) + 1),
			bottom = UDim.new(0, math.ceil(v28 / 2) + 1),
			left = UDim.new(),
			right = UDim.new()
		}
	end, { v5.container.minHeight, fontStyle, fontSize })
	local width

	if v3.width then
		width = v3.width
	else
		width = UDim.new(0, Constants.DEFAULT_NUMBER_INPUT_WIDTH)
	end

	local onFocus = React.useCallback(function()
		v15((tostring(getBindableValue(v3.value))))

		if v3.onFocusGained then
			v3.onFocusGained()
		end
	end, { v3.onFocusGained, v3.value })

	local v28 = React.useCallback(function(p2: number, p3)
		local v28 = v14(p2)
		local v29

		if v6() then
			v29 = tostring(v28)
		else
			v29 = v3.formatAsString(v28)
		end

		v15(v29)
		v3.onChanged(v28, p3)
	end, { v3.onChanged, v3.formatAsString, v14, v6 })

	local onFocusLost = React.useCallback(function(p2)
		setState(false)
		v28(getBindableValue(v3.value), OnChangeCallbackReason.FocusLost)

		if v3.onFocusLost then
			v3.onFocusLost(p2)
		end
	end, { v28, v3.onFocusLost, v3.value, v14 })

	local onChanged = React.useCallback(function(p2)
		v15(p2)

		if not v6() then
			return
		end

		local v29 = tonumber(p2)

		if v3.onTextChanged == nil then
			if v29 == nil then
				setState(true)
				return
			end
		else
			v3.onTextChanged(p2)
		end

		if v29 ~= nil then
			setState(false)
			v3.onChanged(v29, OnChangeCallbackReason.Keyboard)
		end
	end, { v6, v3.onChanged, v3.onTextChanged })

	local onClick = React.useCallback(function()
		if getBindableValue(isDisabled) then
			return
		end

		v28(getBindableValue(v12), OnChangeCallbackReason.Activate)
	end, { isDisabled, v12, v28 })

	local onClick2 = React.useCallback(function()
		if getBindableValue(isDisabled2) then
			return
		end

		v28(getBindableValue(v13), OnChangeCallbackReason.Activate)
	end, { isDisabled2, v13, v28 })

	local v29 = v3.hasControls

	if v29 then
		if controlsVariant == NumberInputControlsVariant.None then
			v29 = false
		else
			v29 = controlsVariant ~= NumberInputControlsVariant.Stacked
		end
	end

	local v30

	if v29 then
		v30 = React.createElement(NumberInputControls, {
			variant = v3.variant,
			size = v3.size,
			increment = { isDisabled = isDisabled, onClick = onClick },
			decrement = { isDisabled = isDisabled2, onClick = onClick2 },
			testId = v3.testId
		})
	else
		v30 = nil
	end

	local v31 = React.useMemo(function()
		if v29 then
			return UDim.new(0, controls.width + v16)
		end

		return UDim.new()
	end, { v4, controlsVariant, v4.Gap.XSmall, controls, v16, v29 })

	local v32 = React.useCallback(function(_, vector2: Vector2)
		local value = v3.value
		ref3.current = false

		if value then
			ref2.current = { position = vector2.X, value = getBindableValue(value) }
		end
	end, { v3.value })

	local useCallback = React.useCallback
	local function fn(_, vector2: Vector2)
		if ref2.current then
			if Flags.FoundationNumberInputScrubEndedAlone then
				if not ref3.current then
					ref3.current = true

					if Flags.FoundationNumberInputScrubCallbackProps and v3.onScrubStarted then
						v3.onScrubStarted()
					end
				end
			elseif Flags.FoundationNumberInputScrubCallbackProps and v3.onScrubStarted and not ref3.current then
				v3.onScrubStarted()
				ref3.current = true
			end

			v28(
				calculateNumberInputValueFromPositions(
					ref2.current.value,
					ref2.current.position,
					vector2.X,
					v3.step,
					v9
				),
				OnChangeCallbackReason.Drag
			)
		end
	end

	local step = v3.step
	local v46

	if Flags.FoundationNumberInputScrubCallbackProps then
		v46 = v3.onScrubStarted
	end

	local v47 = useCallback(fn, { v28, step, v14, v46, v9 })

	local useCallback2 = React.useCallback
	local function fn2()
		if ref2.current then
			ref2.current = nil

			if Flags.FoundationNumberInputScrubCallbackProps and v3.onScrubEnded and ref3.current then
				v3.onScrubEnded()
			end
		end

		ref3.current = false
	end

	local v49

	if Flags.FoundationNumberInputScrubCallbackProps then
		v49 = v3.onScrubEnded
	end

	local v50 = useCallback2(fn2, { v49 })

	local color3 = nil
	local transparency, transparency2

	if Flags.FoundationFixColorOnScrubbableNumberInput then
		local fgStyle = v5.container.fgStyle
		local bgStyle = v5.container.bgStyle

		if bgStyle and bgStyle.Color3 then
			color3 = bgStyle.Color3
		else
			color3 = v4.Color.Shift.Shift_100.Color3
		end

		if fgStyle and fgStyle.Transparency then
			transparency = fgStyle.Transparency
		else
			transparency = v4.Color.None.Transparency
		end

		if bgStyle and bgStyle.Transparency then
			transparency2 = bgStyle.Transparency
		else
			transparency2 = v4.Color.None.Transparency
		end
	else
		transparency = v4.Color.Shift.Shift_300.Transparency
		transparency2 = v4.Color.Shift.Shift_100.Transparency
	end

	local v51

	if math.abs(v3.maximum) < 1e999 then
		v51 = math.abs(v3.minimum) < 1e999
	else
		v51 = false
	end

	local offset = nil
	local transparency3

	if Flags.FoundationNumberInputScrubbingUsesOffset then
		transparency3 = React.useMemo(function()
			return NumberSequence.new({
				NumberSequenceKeypoint.new(0, transparency),
				NumberSequenceKeypoint.new(0.499, transparency),
				NumberSequenceKeypoint.new(0.5, transparency2),
				NumberSequenceKeypoint.new(1, transparency2)
			})
		end, { transparency, transparency2 })

		offset = React.useMemo(function()
			return mapBindable(v3.value, function(p2)
				local v54

				if p2 and v51 then
					local v55 = v10(p2)
					v54 = v3.maximum == v3.minimum and 1 or (v55 - v3.minimum) / (v3.maximum - v3.minimum)
				else
					v54 = 0
				end

				if v54 <= 0 then
					return Vector2.new(-1, 0)
				end

				if v54 >= 1 then
					return Vector2.new(1, 0)
				end

				return Vector2.new(v54 - 0.5, 0)
			end)
		end, { v3.value, v10, v3.maximum, v3.minimum, v51 })
	else
		transparency3 = React.useMemo(function()
			return mapBindable(v3.value, function(p2)
				local v54

				if p2 and v3.maximum and v3.minimum then
					local v55 = v10(p2)
					v54 = v3.maximum == v3.minimum and 1 or (v55 - v3.minimum) / (v3.maximum - v3.minimum)
				else
					v54 = 0
				end

				if v54 == 0 then
					return NumberSequence.new(transparency2)
				elseif v54 == 1 then
					return NumberSequence.new(transparency)
				end

				if not (v54 > 0 or v54 < 1) then
					return NumberSequence.new(transparency2)
				end

				local numberSequenceKeypoints = {
					NumberSequenceKeypoint.new(0, transparency),
					NumberSequenceKeypoint.new(v54, transparency),
					NumberSequenceKeypoint.new(math.min(v54 + 0.001, 1), transparency2)
				}

				if v54 < 0.999 then
					table.insert(numberSequenceKeypoints, NumberSequenceKeypoint.new(1, transparency2))
				end

				return NumberSequence.new(numberSequenceKeypoints)
			end)
		end, { transparency, transparency2, v3.value, v10, v3.maximum, v3.minimum })
	end

	React.useEffect(function()
		if not (v6() or ReactIs.isBinding(v3.value)) then
			v15(v3.formatAsString(v14(v3.value)))
		end
	end, { v3.value, v3.formatAsString, v14, v6 })

	return React.createElement(InputField, withCommonProps(v3, {
		width = width,
		ref = ref5,
		hasError = hasError,
		label = v3.label,
		size = getInputTextSize(v3.size),
		isRequired = v3.isRequired,
		isDisabled = v3.isDisabled,
		hint = v3.hint,
		textBoxRef = textBoxRef,
		input = function(ref4)
			local v54 = v29 and v30
			local createElement = React.createElement
			local v55 = {
				inputRef = v3.inputRef,
				text = joinBindables({ text = text, value = v3.value }, function(p2)
					if v6() then
						return p2.text
					end

					return v3.formatAsString(v14(p2.value))
				end),
				hasError = hasError,
				variant = v3.variant,
				size = v3.size,
				Selectable = v3.Selectable,
				NextSelectionUp = v3.NextSelectionUp,
				NextSelectionDown = v3.NextSelectionDown,
				NextSelectionLeft = v3.NextSelectionLeft,
				NextSelectionRight = v3.NextSelectionRight,
				horizontalPadding = 0,
				focusBehavior = 0,
				onChanged = 0,
				onFocusLost = 0,
				onFocus = 0,
				onDragStarted = 0,
				onDrag = 0,
				onDragEnded = 0,
				onReturnPressed = 0,
				ref = 0,
				backgroundGradient = 0,
				trailingElement = 0,
				leadingElement = 0,
				isDisabled = 0,
				LayoutOrder = 0,
				testId = 0
			}
			local horizontalPadding = {
				left = v5.container.horizontalPadding,
				right = v5.container.horizontalPadding,
				innerLeft = 0
			}
			local innerLeft

			if v19 and v19.X > 0 then
				innerLeft = UDim.new(0, v19.X)
			end

			horizontalPadding.innerLeft = innerLeft
			v55.horizontalPadding = horizontalPadding

			v55.focusBehavior = p.focusBehavior
			v55.onChanged = onChanged
			v55.onFocusLost = onFocusLost
			v55.onFocus = onFocus
			local onDragStarted

			if v8 then
				onDragStarted = v32
			end

			v55.onDragStarted = onDragStarted
			local onDrag

			if v8 then
				onDrag = v47
			end

			v55.onDrag = onDrag
			local onDragEnded

			if v8 then
				onDragEnded = v50
			end

			v55.onDragEnded = onDragEnded
			v55.onReturnPressed = v3.onReturnPressed
			v55.ref = ref4
			local backgroundGradient

			if Flags.FoundationNumberInputScrubbingUsesOffset then
				if v8 and v51 then
					backgroundGradient = React.createElement("UIGradient", {
						Color = ColorSequence.new(color3),
						Transparency = transparency3,
						Offset = offset
					})
				end
			elseif v8 and transparency3 then
				local createElement2 = React.createElement
				local color

				if Flags.FoundationFixColorOnScrubbableNumberInput then
					color = ColorSequence.new(color3)
				else
					color = ColorSequence.new(v4.Color.Shift.Shift_300.Color3)
				end

				backgroundGradient = createElement2("UIGradient", {
					Color = color,
					Transparency = transparency3,
					Rotation = 0
				})
			end

			v55.backgroundGradient = backgroundGradient
			local trailingElement

			if v3.trailingIcon then
				trailingElement = React.createElement(
					View,
					{ tag = "row align-y-center size-0-full auto-x" },
					React.createElement(Icon, {
						name = v3.trailingIcon,
						style = v5.icon.style,
						size = v5.icon.size
					})
				)
			end

			v55.trailingElement = trailingElement
			local leadingElement

			if v3.leadingIcon then
				leadingElement = React.createElement(
					View,
					{ tag = "row align-y-center size-0-full auto-x" },
					React.createElement(Icon, {
						name = v3.leadingIcon,
						style = v5.icon.style,
						size = v5.icon.size
					})
				)
			end

			v55.leadingElement = leadingElement

			v55.isDisabled = v3.isDisabled
			v55.LayoutOrder = v54 and 0 or nil
			v55.testId = `{v3.testId}--field`
			local element = createElement(InternalTextInput, v55)
			local units

			if v17 then
				units = React.createElement(Text, {
					tag = "text-align-x-left text-align-y-center content-muted",
					fontStyle = v5.textBox.fontStyle,
					Size = UDim2.new(1, -(v27.left.Offset + v27.right.Offset), 1, 0),
					Position = UDim2.fromOffset(v27.left.Offset, 0),
					Text = text:map(function(p2)
						return `{not v3.prefix and "" or v3.prefix .. " "}<font transparency="1">{p2}</font>{not v3.suffix and "" or " " .. v3.suffix}`
					end),
					RichText = true,
					ClipsDescendants = true,
					padding = padding,
					testId = `{v3.testId}--units`
				})
			end

			local element2 = React.createElement(View, { tag = "size-full-0 auto-y" }, {
				Input = element,
				Units = units
			})

			local createElement2 = React.createElement
			local v65 = {
				Size = UDim2.new(width.Scale - v31.Scale, width.Offset - v31.Offset, 0, 0),
				tag = "row align-y-center auto-y",
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v16),
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}
			local controls2

			if v54 then
				controls2 = v30
			end

			return createElement2(View, v65, { InputField = element2, Controls = controls2 })
		end
	}))
end

return React.memo(React.forwardRef(NumberInput))
