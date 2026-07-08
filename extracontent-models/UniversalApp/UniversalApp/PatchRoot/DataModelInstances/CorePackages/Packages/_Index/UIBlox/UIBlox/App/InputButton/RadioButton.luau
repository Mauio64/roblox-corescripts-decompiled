local ParentParent = script.Parent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local Cryo = require(ParentParent.Cryo)
local withStyle = require(ParentParent.UIBlox.Core.Style.withStyle)
local Images = require(ParentParent.UIBlox.App.ImageSet.Images)
local InputButton = require(ParentParent.UIBlox.Core.InputButton.InputButton)
local RoactGamepad = require(ParentParent.RoactGamepad)
local v9 = Roact.PureComponent:extend("RadioButton")

v9.validateProps = t.strictInterface({
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
v9.defaultProps = {
	text = "RadioButton Text",
	isSelected = false,
	isDisabled = false,
	layoutOrder = 0,
	isRoactGamepadEnabled = true
}

function v9.init(p1) -- line: 52
	function p1.onSetValue() -- line: 53
		-- upvalues: p1 (copy)
		if not p1.props.isDisabled then
			p1.props.onActivated(p1.props.id)
		end
	end
end
function v9.render(p2) -- line: 60
	-- upvalues: withStyle (copy), Images (copy), RoactGamepad (copy), InputButton (copy), Roact (copy)
	return withStyle(function(p3) -- line: 61
		-- upvalues: Images (copy), p2 (copy), RoactGamepad (copy), InputButton (copy), Roact (copy)
		local Theme = p3.Theme
		local v16 = Images["component_assets/circle_24_stroke_1"]
		local TextDefaultColor = Theme.TextDefault.Color
		local v18 = Images["component_assets/circle_16"]
		local TextDefaultColor2 = Theme.TextDefault.Color
		local isSelected = p2.props.isSelected
		local TextDefaultColor3 = Theme.TextDefault.Color
		local TextDefaultTransparency = Theme.TextDefault.Transparency

		if p2.props.isDisabled then
			TextDefaultTransparency = 0.5
		end

		local uDim2

		if isSelected then
			uDim2 = UDim2.new(0, 18, 0, 18)
			TextDefaultColor2 = Theme.SystemPrimaryDefault.Color
			TextDefaultColor = Theme.SystemPrimaryDefault.Color
		else
			uDim2 = UDim2.new(0, 0, 0, 0)
		end

		local v24 = if not p2.props.isRoactGamepadEnabled then InputButton else RoactGamepad.Focusable[InputButton]

		return Roact.createElement(v24, {
			text = p2.props.text,
			onActivated = p2.onSetValue,
			size = p2.props.size,
			image = v16,
			imageColor = TextDefaultColor,
			fillImage = v18,
			fillImageSize = uDim2,
			fillImageColor = TextDefaultColor2,
			selectedColor = Theme.SystemPrimaryDefault.Color,
			textColor = TextDefaultColor3,
			transparency = TextDefaultTransparency,
			layoutOrder = p2.props.layoutOrder,
			isDisabled = p2.props.isDisabled,
			isRoactGamepadEnabled = p2.props.isRoactGamepadEnabled,
			[Roact.Ref] = p2.props.forwardRef,
			NextSelectionUp = p2.props.NextSelectionUp,
			NextSelectionDown = p2.props.NextSelectionDown,
			NextSelectionLeft = p2.props.NextSelectionLeft,
			NextSelectionRight = p2.props.NextSelectionRight,
			SelectionImageObject = p2.props.SelectionImageObject
		})
	end)
end

return Roact.forwardRef(function(p4, p5) -- line: 117
	-- upvalues: Roact (copy), v9 (copy), Cryo (copy)
	return Roact.createElement(v9, Cryo.Dictionary.join(p4, {
		forwardRef = p5
	}))
end)
