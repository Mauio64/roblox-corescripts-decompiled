local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)
local t = require(parent3.t)

local withStyle = require(parent2.Core.Style.withStyle)

local ToastFrame = require(parent.ToastFrame)
local ToastIcon = require(parent.ToastIcon)
local ToastText = require(parent.ToastText)

local extended = Roact.PureComponent:extend("InformativeToast")

extended.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	iconProps = t.optional(ToastIcon.validateProps),
	iconChildren = t.optional(t.table),
	layoutOrder = t.optional(t.integer),
	padding = t.optional(t.numberMin(0)),
	position = t.optional(t.UDim2),
	size = t.UDim2,
	subtitleTextProps = t.optional(ToastText.validateProps),
	textFrameSize = t.optional(t.UDim2),
	titleTextProps = ToastText.validateProps
})

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	layoutOrder = 1,
	position = UDim2.new(0.5, 0, 0.5, 0),
	size = UDim2.new(1, 0, 1, 0)
}

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme
		local settings = p2.Settings

		return Roact.createElement("Frame", {
			AnchorPoint = p.props.anchorPoint,
			BackgroundColor3 = theme.BackgroundUIContrast.Color,
			BackgroundTransparency = theme.BackgroundUIContrast.Transparency * settings.PreferredTransparency,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			LayoutOrder = p.props.layoutOrder,
			Position = p.props.position,
			Size = p.props.size
		}, {
			ToastFrame = Roact.createElement(ToastFrame, {
				iconProps = p.props.iconProps,
				iconChildren = p.props.iconChildren,
				padding = p.props.padding,
				subtitleTextProps = p.props.subtitleTextProps,
				textFrameSize = p.props.textFrameSize,
				titleTextProps = p.props.titleTextProps
			})
		})
	end)
end

return extended
