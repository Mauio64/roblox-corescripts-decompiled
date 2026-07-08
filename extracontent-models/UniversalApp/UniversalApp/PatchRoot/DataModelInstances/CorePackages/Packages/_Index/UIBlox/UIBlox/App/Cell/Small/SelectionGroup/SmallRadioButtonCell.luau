local ParentParent = script.Parent.Parent.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local Cryo = require(ParentParent.Cryo)
local t = require(ParentParent.t)
local Images = require(ParentParent.UIBlox.App.ImageSet.Images)
local GenericSelectionCell = require(ParentParent.UIBlox.Core.Cell.GenericSelectionCell)
local v7 = Images["component_assets/circle_24_stroke_1"]
local v8 = Images["component_assets/circle_16"]
local v9 = Roact.PureComponent:extend("SmallRadioButtonCell")

v9.validateProps = t.strictInterface({
	id = t.string,
	text = t.optional(t.string),
	onActivated = t.optional(t.callback),
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	useDefaultControlState = t.optional(t.boolean),
	layoutOrder = t.optional(t.number),
	controlRef = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	SelectionImageObject = t.optional(t.table)
})
v9.defaultProps = {
	text = "",
	isSelected = false
}

function v9.init(p1) -- line: 59
	function p1.onSetValue() -- line: 60
		-- upvalues: p1 (copy)
		p1.props.onActivated(p1.props.id)
	end
end
function v9.render(p2) -- line: 65
	-- upvalues: Roact (copy), GenericSelectionCell (copy), v7 (copy), v8 (copy)
	assert(p2.validateProps(p2.props))

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 56),
		LayoutOrder = p2.props.layoutOrder
	}, {
		GenericSelectionCell = Roact.createElement(GenericSelectionCell, {
			isSelected = p2.props.isSelected,
			isDisabled = p2.props.isDisabled,
			defaultImage = v7,
			selectedImage = v8,
			defaultImageSize = 24,
			selectedImageSize = 16,
			text = p2.props.text,
			onActivated = p2.onSetValue,
			useDefaultControlState = p2.props.useDefaultControlState,
			[Roact.Ref] = p2.props.controlRef,
			NextSelectionUp = p2.props.NextSelectionUp,
			NextSelectionDown = p2.props.NextSelectionDown,
			NextSelectionLeft = p2.props.NextSelectionLeft,
			NextSelectionRight = p2.props.NextSelectionRight,
			SelectionImageObject = p2.props.SelectionImageObject
		})
	})
end

return Roact.forwardRef(function(p3, p4) -- line: 95
	-- upvalues: Roact (copy), v9 (copy), Cryo (copy)
	return Roact.createElement(v9, Cryo.Dictionary.join(p3, {
		controlRef = p4
	}))
end)
