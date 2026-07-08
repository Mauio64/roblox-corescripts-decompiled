local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Roact = require(scriptParentParentParentParent.Roact)
local Cryo = require(scriptParentParentParentParent.Cryo)
local t = require(scriptParentParentParentParent.t)
local makeAppSlider = require(scriptParent.makeAppSlider)
local SliderTextInput = require(scriptParent.SliderTextInput)
local withStyle = require(scriptParentParentParent.Core.Style.withStyle)
local validateStyle = require(scriptParentParent.Style.Validator.validateStyle)

local function wrapStyleAndRef(p1) -- line: 15
	-- upvalues: Roact (copy), withStyle (copy), Cryo (copy)
	return Roact.forwardRef(function(p2, p3) -- line: 16
		-- upvalues: withStyle (copy), Cryo (copy), Roact (copy), p1 (copy)
		return withStyle(function(p4) -- line: 17
			-- upvalues: Cryo (copy), p2 (copy), p3 (copy), Roact (copy), p1 (copy)
			local v24 = Cryo.Dictionary.join(p2, {
				style = p4,
				forwardedRef = p3
			})

			return Roact.createElement(p1, v24)
		end)
	end)
end
local function makeAppOneKnobSlider(p5) -- line: 28
	-- upvalues: Roact (copy), makeAppSlider (copy), t (copy), validateStyle (copy), SliderTextInput (copy), wrapStyleAndRef (copy)
	local v16 = Roact.PureComponent:extend("OneKnobAppSliderFor" .. p5)
	local v17 = makeAppSlider(p5, false)

	v16.validateProps = t.strictInterface({
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
	v16.defaultProps = {
		stepInterval = 1,
		textInputEnabled = false,
		width = UDim.new(1, 0)
	}

	function v16.render(p6) -- line: 86
		-- upvalues: Roact (copy), v17 (copy), SliderTextInput (copy)
		local props = p6.props
		local t1 = {
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

		if not props.textInputEnabled then
			t1.width = props.width
			t1.position = props.position
			t1.anchorPoint = props.anchorPoint
			t1.layoutOrder = props.layoutOrder

			return Roact.createElement(v17, t1)
		end

		t1.width = UDim.new(1, -68)

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(props.width.Scale, props.width.Offset, 0, 44),
			AnchorPoint = props.anchorPoint,
			LayoutOrder = props.layoutOrder,
			Position = props.position
		}, {
			Slider = Roact.createElement(v17, t1),
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

	return wrapStyleAndRef(v16)
end

return makeAppOneKnobSlider
