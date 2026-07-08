local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local ToastFrame = require(scriptParent.ToastFrame)
local ToastIcon = require(scriptParent.ToastIcon)
local ToastText = require(scriptParent.ToastText)
local v10 = Roact.PureComponent:extend("InformativeToast")

v10.validateProps = t.strictInterface({
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
v10.defaultProps = {
	layoutOrder = 1,
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0),
	size = UDim2.new(1, 0, 1, 0)
}

function v10.render(p1) -- line: 44
	-- upvalues: withStyle (copy), Roact (copy), ToastFrame (copy)
	return withStyle(function(p2) -- line: 45
		-- upvalues: Roact (copy), p1 (copy), ToastFrame (copy)
		local Theme = p2.Theme
		local Settings = p2.Settings

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			ClipsDescendants = true,
			AnchorPoint = p1.props.anchorPoint,
			BackgroundColor3 = Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = Theme.BackgroundUIContrast.Transparency * Settings.PreferredTransparency,
			LayoutOrder = p1.props.layoutOrder,
			Position = p1.props.position,
			Size = p1.props.size
		}, {
			ToastFrame = Roact.createElement(ToastFrame, {
				iconProps = p1.props.iconProps,
				iconChildren = p1.props.iconChildren,
				padding = p1.props.padding,
				subtitleTextProps = p1.props.subtitleTextProps,
				textFrameSize = p1.props.textFrameSize,
				titleTextProps = p1.props.titleTextProps
			})
		})
	end)
end

return v10
