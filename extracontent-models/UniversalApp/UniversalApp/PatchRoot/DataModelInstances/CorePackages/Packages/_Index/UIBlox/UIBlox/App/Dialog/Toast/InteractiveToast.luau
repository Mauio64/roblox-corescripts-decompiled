local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)
local Images = require(ParentParentParent.App.ImageSet.Images)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local SpringAnimatedItem = require(ParentParentParent.Utility.SpringAnimatedItem)
local ButtonType = require(ParentParent.Button.Enum.ButtonType)
local ToastFrame = require(scriptParent.ToastFrame)
local ToastIcon = require(scriptParent.ToastIcon)
local ToastText = require(scriptParent.ToastText)
local t1 = {
	dampingRatio = 1,
	frequency = 4
}
local v16 = Images["component_assets/circle_21"]
local rect = Rect.new(10, 10, 11, 11)
local v18 = Roact.PureComponent:extend("InteractiveToast")

v18.validateProps = t.strictInterface({
	anchorPoint = t.optional(t.Vector2),
	buttonProps = t.optional(t.strictInterface({
		buttonDimensions = t.Vector2,
		buttonText = t.string,
		onActivated = t.callback,
		buttonType = t.optional(ButtonType.isEnumValue)
	})),
	iconProps = t.optional(ToastIcon.validateProps),
	iconChildren = t.optional(t.table),
	isCompact = t.optional(t.boolean),
	layoutOrder = t.optional(t.integer),
	padding = t.optional(t.numberMin(0)),
	position = t.optional(t.UDim2),
	pressed = t.optional(t.boolean),
	pressedScale = t.number,
	size = t.UDim2,
	subtitleTextProps = t.optional(ToastText.validateProps),
	textFrameSize = t.optional(t.UDim2),
	titleTextProps = ToastText.validateProps
})
v18.defaultProps = {
	layoutOrder = 1,
	pressedScale = 0.95,
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0),
	size = UDim2.new(1, 0, 1, 0)
}

function v18.render(p1) -- line: 72
	-- upvalues: withStyle (copy), Roact (copy), ImageSetComponent (copy), v16 (copy), rect (copy), SpringAnimatedItem (copy), t1 (copy), ToastFrame (copy)
	return withStyle(function(p2) -- line: 73
		-- upvalues: Roact (copy), ImageSetComponent (copy), p1 (copy), v16 (copy), rect (copy), SpringAnimatedItem (copy), t1 (copy), ToastFrame (copy)
		local Theme = p2.Theme

		return Roact.createElement(ImageSetComponent.Label, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = p1.props.anchorPoint,
			Image = v16,
			ImageColor3 = Theme.BackgroundUIDefault.Color,
			ImageTransparency = Theme.BackgroundUIDefault.Transparency,
			LayoutOrder = p1.props.layoutOrder,
			Position = p1.props.position,
			ScaleType = Enum.ScaleType.Slice,
			Size = p1.props.size,
			SliceCenter = rect
		}, {
			Scaler = Roact.createElement(SpringAnimatedItem.AnimatedUIScale, {
				springOptions = t1,
				animatedValues = {
					scale = p1.props.pressed and p1.props.pressedScale or 1
				},
				mapValuesToProps = function(p3) -- line: 94
					return {
						Scale = p3.scale
					}
				end
			}),
			ToastFrame = Roact.createElement(ToastFrame, {
				buttonProps = p1.props.buttonProps,
				iconProps = p1.props.iconProps,
				iconChildren = p1.props.iconChildren,
				isCompact = p1.props.isCompact,
				padding = p1.props.padding,
				subtitleTextProps = p1.props.subtitleTextProps,
				textFrameSize = p1.props.textFrameSize,
				titleTextProps = p1.props.titleTextProps
			})
		})
	end)
end

return v18
