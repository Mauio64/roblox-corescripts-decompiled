local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local validateColorInfo = require(ParentParent.Core.Style.Validator.validateColorInfo)
local withStyle = require(ParentParent.Core.Style.withStyle)
local v9 = Roact.PureComponent:extend("ToastIcon")

v9.validateProps = t.interface({
	Image = t.union(t.table, t.string, t.callback),
	Size = t.UDim2,
	AnchorPoint = t.optional(t.Vector2),
	colorStyle = t.optional(validateColorInfo),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2)
})
v9.defaultProps = {
	BackgroundTransparency = 1
}

function v9.render(p1) -- line: 34
	-- upvalues: withStyle (copy), Cryo (copy), Roact (copy), ImageSetComponent (copy)
	return withStyle(function(p2) -- line: 35
		-- upvalues: p1 (copy), Cryo (copy), Roact (copy), ImageSetComponent (copy)
		local Theme = p2.Theme
		local colorStyle = p1.props.colorStyle

		if colorStyle == nil then
			colorStyle = Theme.IconEmphasis
		end

		local colorStyleColor = colorStyle.Color
		local colorStyleTransparency = colorStyle.Transparency
		local v16 = Cryo.Dictionary.join(p1.props, {
			colorStyle = Cryo.None,
			ImageColor3 = colorStyleColor,
			ImageTransparency = colorStyleTransparency
		})

		return Roact.createElement(ImageSetComponent.Label, v16)
	end)
end

return v9
