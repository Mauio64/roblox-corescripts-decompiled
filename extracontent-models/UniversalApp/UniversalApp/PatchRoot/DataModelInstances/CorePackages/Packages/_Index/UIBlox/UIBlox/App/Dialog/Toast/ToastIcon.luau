local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)
local t = require(parent2.t)

local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)
local withStyle = require(parent.Core.Style.withStyle)

local extended = Roact.PureComponent:extend("ToastIcon")

extended.validateProps = t.interface({
	Image = t.union(t.table, t.string, t.callback),
	Size = t.UDim2,
	AnchorPoint = t.optional(t.Vector2),
	colorStyle = t.optional(validateColorInfo),
	LayoutOrder = t.optional(t.integer),
	Position = t.optional(t.UDim2)
})

extended.defaultProps = { BackgroundTransparency = 1 }

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme

		local v = p.props.colorStyle

		if v == nil then
			v = theme.IconEmphasis
		end

		local color = v.Color
		local transparency = v.Transparency

		local joined = Cryo.Dictionary.join(p.props, {
			colorStyle = Cryo.None,
			ImageColor3 = color,
			ImageTransparency = transparency
		})

		return Roact.createElement(ImageSetComponent.Label, joined)
	end)
end

return extended
