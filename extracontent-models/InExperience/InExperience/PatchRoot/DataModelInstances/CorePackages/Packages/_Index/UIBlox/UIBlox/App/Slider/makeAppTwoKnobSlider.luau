local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local Cryo = require(parent4.Cryo)
local t = require(parent4.t)

local makeAppSlider = require(parent.makeAppSlider)
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

local function makeAppTwoKnobSlider(p)
	local extended = Roact.PureComponent:extend("TwoKnobAppSliderFor" .. p)
	local appSlider = makeAppSlider(p, true)
	local strictInterface = t.strictInterface({
		lowerValue = t.number,
		upperValue = t.number,
		min = t.number,
		max = t.number,
		stepInterval = t.optional(t.numberPositive),
		onValueChanged = t.callback,
		onDragStartLower = t.optional(t.callback),
		onDragStartUpper = t.optional(t.callback),
		onDragEnd = t.optional(t.callback),
		isDisabled = t.optional(t.boolean),
		width = t.optional(t.UDim),
		position = t.optional(t.UDim2),
		anchorPoint = t.optional(t.Vector2),
		layoutOrder = t.optional(t.integer),
		forwardedRef = t.optional(t.table),
		NextSelectionUp = t.optional(t.table),
		NextSelectionDown = t.optional(t.table),
		focusController = t.optional(t.table),
		style = validateStyle
	})

	local function valueValidator(p2)
		if p2.lowerValue > p2.upperValue then
			return false, "The upper value must be greater than or equal to the lower"
		end

		return true
	end

	extended.validateProps = t.intersection(strictInterface, valueValidator)

	extended.defaultProps = { stepInterval = 1, width = UDim.new(1, 0) }

	function extended.render(p2)
		return Roact.createElement(appSlider, p2.props)
	end

	return wrapStyleAndRef(extended)
end

return makeAppTwoKnobSlider
