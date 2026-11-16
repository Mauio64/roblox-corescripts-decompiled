local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent

local Roact = require(parent4.Roact)
local t = require(parent4.t)

local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local Images = require(parent3.App.ImageSet.Images)
local withStyle = require(parent3.Core.Style.withStyle)
local SpringAnimatedItem = require(parent3.Utility.SpringAnimatedItem)
local ButtonType = require(parent2.Button.Enum.ButtonType)

local ToastFrame = require(parent.ToastFrame)
local ToastIcon = require(parent.ToastIcon)
local ToastText = require(parent.ToastText)

local springOptions = { dampingRatio = 1, frequency = 4 }

local component_assetscircle_21 = Images["component_assets/circle_21"]
local rect = Rect.new(10, 10, 11, 11)

local extended = Roact.PureComponent:extend("InteractiveToast")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	layoutOrder = 1,
	position = UDim2.new(0.5, 0, 0.5, 0),
	pressedScale = 0.95,
	size = UDim2.new(1, 0, 1, 0)
}

function extended.render(p)
	return withStyle(function(p2)
		local theme = p2.Theme

		return Roact.createElement(ImageSetComponent.Label, {
			AnchorPoint = p.props.anchorPoint,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = component_assetscircle_21,
			ImageColor3 = theme.BackgroundUIDefault.Color,
			ImageTransparency = theme.BackgroundUIDefault.Transparency,
			LayoutOrder = p.props.layoutOrder,
			Position = p.props.position,
			ScaleType = Enum.ScaleType.Slice,
			Size = p.props.size,
			SliceCenter = rect
		}, {
			Scaler = Roact.createElement(SpringAnimatedItem.AnimatedUIScale, {
				springOptions = springOptions,
				animatedValues = {
					scale = p.props.pressed and p.props.pressedScale or 1
				},
				mapValuesToProps = function(p3)
					return { Scale = p3.scale }
				end
			}),
			ToastFrame = Roact.createElement(ToastFrame, {
				buttonProps = p.props.buttonProps,
				iconProps = p.props.iconProps,
				iconChildren = p.props.iconChildren,
				isCompact = p.props.isCompact,
				padding = p.props.padding,
				subtitleTextProps = p.props.subtitleTextProps,
				textFrameSize = p.props.textFrameSize,
				titleTextProps = p.props.titleTextProps
			})
		})
	end)
end

return extended
