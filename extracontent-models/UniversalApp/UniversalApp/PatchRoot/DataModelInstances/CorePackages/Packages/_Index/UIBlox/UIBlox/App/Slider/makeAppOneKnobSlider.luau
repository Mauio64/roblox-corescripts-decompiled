local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local Cryo = require(parent4.Cryo)
local t = require(parent4.t)

local makeAppSlider = require(parent.makeAppSlider)
local SliderTextInput = require(parent.SliderTextInput)
local withStyle = require(parent3.Core.Style.withStyle)
local validateStyle = require(parent2.Style.Validator.validateStyle)

local function wrapStyleAndRef(extended)
	return Roact.forwardRef(function(p, forwardedRef)
		return withStyle(function(style)
			local joined = Cryo.Dictionary.join(p, { style = style, forwardedRef = forwardedRef })

			return Roact.createElement(extended, joined)
		end)
	end)
end

local function makeAppOneKnobSlider(p)
	local extended = Roact.PureComponent:extend("OneKnobAppSliderFor" .. p)
	local appSlider = makeAppSlider(p, false)

	extended.validateProps = t.strictInterface({
		value = t.number,
		min = t.number,
		max = t.number,
		onValueChanged = t.callback,
		onDragStart = t.optional(t.callback),
		onDragEnd = t.optional(t.callback),
		stepInterval = t.optional(t.numberPositive),
		textInputEnabled = t.optional(t.boolean),
		isDisabled = t.optional(t.boolean),
		width = t.optional(t.UDim),
		position = t.optional(t.UDim2),
		anchorPoint = t.optional(t.Vector2),
		layoutOrder = t.optional(t.integer),
		forwardedRef = t.optional(t.table),
		NextSelectionUp = t.optional(t.table),
		NextSelectionDown = t.optional(t.table),
		customTrack = t.optional(t.table),
		customKnobColorLower = t.optional(t.Color3),
		customPressedKnobShadowTransparencyLower = t.optional(t.number),
		customKnobHeight = t.optional(t.number),
		customKnobBorderSize = t.optional(t.number),
		customKnobBorderColor = t.optional(t.Color3),
		style = validateStyle,
		containerRef = t.optional(t.table)
	})

	extended.defaultProps = { stepInterval = 1, width = UDim.new(1, 0), textInputEnabled = false }

	function extended.render(p2)
		local props = p2.props

		local v = {
			value = props.value,
			min = props.min,
			max = props.max,
			stepInterval = props.stepInterval,
			isDisabled = props.isDisabled,
			onValueChanged = props.onValueChanged,
			onDragStartLower = props.onDragStart,
			onDragEnd = props.onDragEnd,
			style = props.style,
			forwardedRef = props.forwardedRef,
			NextSelectionUp = props.NextSelectionUp,
			NextSelectionDown = props.NextSelectionDown,
			customTrack = props.customTrack,
			customKnobHeight = props.customKnobHeight,
			customKnobBorderColor = props.customKnobBorderColor,
			customKnobBorderSize = props.customKnobBorderSize,
			customKnobColorLower = props.customKnobColorLower,
			customPressedKnobShadowTransparencyLower = props.customPressedKnobShadowTransparencyLower,
			containerRef = props.containerRef
		}

		if props.textInputEnabled then
			v.width = UDim.new(1, -68)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(props.width.Scale, props.width.Offset, 0, 44),
				AnchorPoint = props.anchorPoint,
				LayoutOrder = props.layoutOrder,
				Position = props.position
			}, {
				Slider = Roact.createElement(appSlider, v),
				TextInput = Roact.createElement(SliderTextInput, {
					position = UDim2.new(1, 0, 0.5, 0),
					anchorPoint = Vector2.new(1, 0.5),
					value = props.value,
					min = props.min,
					max = props.max,
					disabled = props.isDisabled,
					stepInterval = props.stepInterval,
					onValueChanged = props.onValueChanged
				})
			})
		end

		v.width = props.width
		v.position = props.position
		v.anchorPoint = props.anchorPoint
		v.layoutOrder = props.layoutOrder
		return Roact.createElement(appSlider, v)
	end

	return wrapStyleAndRef(extended)
end

return makeAppOneKnobSlider
