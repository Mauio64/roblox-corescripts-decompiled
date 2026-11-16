local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local withStyle = require(parent.Core.Style.withStyle)
local GetTextSize = require(parent.Core.Text.GetTextSize)
local GetFontFromFontStyle = require(parent.Core.Text.GetFontFromFontStyle)

local GenericTextLabel = require(parent.Core.Text.GenericTextLabel.GenericTextLabel)

local Images = require(parent.App.ImageSet.Images)
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local BadgeStates = require(script.Parent.Enum.BadgeStates)
local BadgeVariant = require(script.Parent.Enum.BadgeVariant)

local divideTransparency = require(parent.Utility.divideTransparency)

local component_assetscircle_25 = Images["component_assets/circle_25"]
local component_assetscircle_21 = Images["component_assets/circle_21"]

local extended = Roact.PureComponent:extend("Badge")

extended.validateProps = t.strictInterface({
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	disabled = t.optional(t.boolean),
	hasShadow = t.optional(t.boolean),
	value = t.union(t.string, t.integer, BadgeStates.isEnumValue),
	badgeVariant = t.optional(BadgeVariant.isEnumValue),
	layoutOrder = t.optional(t.integer)
})

extended.defaultProps = {
	position = UDim2.new(0, 0, 0, 0),
	anchorPoint = Vector2.new(0, 0),
	disabled = false,
	hasShadow = false,
	badgeVariant = BadgeVariant.Default
}

function extended.render(p)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font

		local v = tostring(p.props.value)

		if t.number(p.props.value) and p.props.value > 99 then
			v = "99+"
		elseif t.string(p.props.value) and utf8.len(utf8.nfcnormalize(p.props.value)) > 4 then
			local v2 = utf8.offset(p.props.value, 4) - 1
			v = string.sub(p.props.value, 1, v2) .. "..."
		end

		local text = p.props.value == BadgeStates.isEmpty and "" or v

		local baseSize = props.Font.BaseSize
		local v2 = GetTextSize(
			text,
			font.CaptionBody.RelativeSize * baseSize,
			GetFontFromFontStyle(font.CaptionBody),
			Vector2.new(10000, 10000)
		).X + 10 + 4
		local v3 = v2 < 24 and 24 or v2
		local v4

		if p.props.value == BadgeStates.isEmpty then
			v3 = 12
			v4 = 12
		else
			v4 = 24
		end

		local v5 = props.Tokens.Color.System.Contrast
		local colorStyle = {
			Color = props.Tokens.Inverse.Content.Emphasis.Color3,
			Transparency = props.Tokens.Inverse.Content.Emphasis.Transparency
		}

		if p.props.badgeVariant == BadgeVariant.Alert then
			v5 = props.Tokens.Color.System.Alert
			colorStyle = {
				Color = props.Tokens.Color.Extended.White.White_100.Color3,
				Transparency = props.Tokens.Inverse.Content.Emphasis.Transparency
			}
		end

		return Roact.createElement("Frame", {
			Position = p.props.position,
			AnchorPoint = p.props.anchorPoint,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v3, v4),
			LayoutOrder = p.props.layoutOrder
		}, {
			Shadow = p.props.hasShadow and Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 12, 1, 12),
				Image = Images["component_assets/dropshadow_25"],
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(18, 18, 19, 19)
			}),
			Background = Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 2,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ImageColor3 = theme.BackgroundDefault.Color,
				ImageTransparency = divideTransparency(
					theme.BackgroundDefault.Transparency,
					p.props.disabled and 2 or 1
				),
				Image = component_assetscircle_25,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(14, 14, 15, 15)
			}),
			Inner = Roact.createElement(ImageSetComponent.Label, {
				ZIndex = 3,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, -4, 1, -4),
				ImageColor3 = v5.Color3,
				ImageTransparency = divideTransparency(v5.Transparency, p.props.disabled and 2 or 1),
				Image = component_assetscircle_21,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(12, 12, 13, 13)
			}, {
				TextLabel = Roact.createElement(GenericTextLabel, {
					fontStyle = font.CaptionBody,
					colorStyle = colorStyle,
					BackgroundTransparency = 1,
					Text = text,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromScale(1, 1),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center
				})
			})
		})
	end)
end

return extended
