local parent = script.Parent.Parent.Parent.Parent

local Roact = require(parent.Roact)
local t = require(parent.t)
local Cryo = require(parent.Cryo)
local withStyle = require(parent.UIBlox.Core.Style.withStyle)
local Images = require(parent.UIBlox.App.ImageSet.Images)
local InputButton = require(parent.UIBlox.Core.InputButton.InputButton)
local RoactGamepad = require(parent.RoactGamepad)

local extended = Roact.PureComponent:extend("RadioButton")

extended.validateProps = t.strictInterface({
	text = t.string,
	isSelected = t.optional(t.boolean),
	isDisabled = t.optional(t.boolean),
	onActivated = t.callback,
	size = t.UDim2,
	layoutOrder = t.optional(t.number),
	id = t.number,
	NextSelectionDown = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	SelectionImageObject = t.optional(t.table),
	isRoactGamepadEnabled = t.optional(t.boolean),
	forwardRef = t.optional(t.table)
})

extended.defaultProps = {
	text = "RadioButton Text",
	isSelected = false,
	isDisabled = false,
	layoutOrder = 0,
	isRoactGamepadEnabled = true
}

function extended:init()
	function self.onSetValue()
		if not self.props.isDisabled then
			self.props.onActivated(self.props.id)
		end
	end
end

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme

		local component_assetscircle_24_stroke_1 = Images["component_assets/circle_24_stroke_1"]
		local color = theme.TextDefault.Color

		local component_assetscircle_16 = Images["component_assets/circle_16"]
		local color2 = theme.TextDefault.Color

		local isSelected = p.props.isSelected

		local color3 = theme.TextDefault.Color
		local transparency = theme.TextDefault.Transparency

		local transparency2 = p.props.isDisabled and 0.5 or transparency
		local udim

		if isSelected then
			udim = UDim2.new(0, 18, 0, 18)
			color2 = theme.SystemPrimaryDefault.Color
			color = theme.SystemPrimaryDefault.Color
		else
			udim = UDim2.new(0, 0, 0, 0)
		end

		local v

		if p.props.isRoactGamepadEnabled then
			v = RoactGamepad.Focusable[InputButton]
		else
			v = InputButton
		end

		return Roact.createElement(v, {
			text = p.props.text,
			onActivated = p.onSetValue,
			size = p.props.size,
			image = component_assetscircle_24_stroke_1,
			imageColor = color,
			fillImage = component_assetscircle_16,
			fillImageSize = udim,
			fillImageColor = color2,
			selectedColor = theme.SystemPrimaryDefault.Color,
			textColor = color3,
			transparency = transparency2,
			layoutOrder = p.props.layoutOrder,
			isDisabled = p.props.isDisabled,
			isRoactGamepadEnabled = p.props.isRoactGamepadEnabled,
			[Roact.Ref] = p.props.forwardRef,
			NextSelectionUp = p.props.NextSelectionUp,
			NextSelectionDown = p.props.NextSelectionDown,
			NextSelectionLeft = p.props.NextSelectionLeft,
			NextSelectionRight = p.props.NextSelectionRight,
			SelectionImageObject = p.props.SelectionImageObject
		})
	end)
end

return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
