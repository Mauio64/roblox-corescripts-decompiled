local parent = script.Parent.Parent.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)
local t = require(parent.t)
local Images = require(parent.UIBlox.App.ImageSet.Images)

local GenericSelectionCell = require(parent.UIBlox.Core.Cell.GenericSelectionCell)

local component_assetscircle_24_stroke_1 = Images["component_assets/circle_24_stroke_1"]
local component_assetscircle_16 = Images["component_assets/circle_16"]

local extended = Roact.PureComponent:extend("SmallRadioButtonCell")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { text = "", isSelected = false }

function extended:init()
	function self.onSetValue()
		self.props.onActivated(self.props.id)
	end
end

function extended.render(props)
	assert(props.validateProps(props.props))

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 56),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = props.props.layoutOrder
		},
		{
			GenericSelectionCell = Roact.createElement(GenericSelectionCell, {
				isSelected = props.props.isSelected,
				isDisabled = props.props.isDisabled,
				defaultImage = component_assetscircle_24_stroke_1,
				selectedImage = component_assetscircle_16,
				defaultImageSize = 24,
				selectedImageSize = 16,
				text = props.props.text,
				onActivated = props.onSetValue,
				useDefaultControlState = props.props.useDefaultControlState,
				[Roact.Ref] = props.props.controlRef,
				NextSelectionUp = props.props.NextSelectionUp,
				NextSelectionDown = props.props.NextSelectionDown,
				NextSelectionLeft = props.props.NextSelectionLeft,
				NextSelectionRight = props.props.NextSelectionRight,
				SelectionImageObject = props.props.SelectionImageObject
			})
		}
	)
end

return Roact.forwardRef(function(p, controlRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { controlRef = controlRef }))
end)
