local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local scriptParentParentParentParent = scriptParentParentParent.Parent
local Roact = require(scriptParentParentParentParent.Roact)
local Cryo = require(scriptParentParentParentParent.Cryo)
local t = require(scriptParentParentParentParent.t)
local makeAppSlider = require(scriptParent.makeAppSlider)
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
local function makeAppTwoKnobSlider(p5) -- line: 28
	-- upvalues: Roact (copy), makeAppSlider (copy), t (copy), validateStyle (copy), wrapStyleAndRef (copy)
	local v15 = Roact.PureComponent:extend("TwoKnobAppSliderFor" .. p5)
	local v16 = makeAppSlider(p5, true)
	local v17 = t.strictInterface({
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

	local function valueValidator(p6) -- line: 76
		if p6.lowerValue > p6.upperValue then
			return false, "The upper value must be greater than or equal to the lower"
		end

		return true
	end

	v15.validateProps = t.intersection(v17, valueValidator)
	v15.defaultProps = {
		stepInterval = 1,
		width = UDim.new(1, 0)
	}

	function v15.render(p7) -- line: 91
		-- upvalues: Roact (copy), v16 (copy)
		return Roact.createElement(v16, p7.props)
	end

	return wrapStyleAndRef(v15)
end

return makeAppTwoKnobSlider
