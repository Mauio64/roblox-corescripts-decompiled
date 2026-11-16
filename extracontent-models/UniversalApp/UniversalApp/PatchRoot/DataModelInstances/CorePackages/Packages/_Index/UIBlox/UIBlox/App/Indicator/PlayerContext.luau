local App = script:FindFirstAncestor("App")
local parent = App.Parent
local core = parent.Core
local parent2 = parent.Parent

local t = require(parent2.t)
local Roact = require(parent2.Roact)

local ControlState = require(core.Control.Enum.ControlState)
local GenericTextLabel = require(core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(core.Style.withStyle)
local getContentStyle = require(core.Button.getContentStyle)
local getIconSize = require(App.ImageSet.getIconSize)
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local IconSize = require(App.ImageSet.Enum.IconSize)
local validateFontInfo = require(parent.Core.Style.Validator.validateFontInfo)
local validateTypographyInfo = require(parent.Core.Style.Validator.validateTypographyInfo)
local validateColorInfo = require(parent.Core.Style.Validator.validateColorInfo)

local extended = Roact.PureComponent:extend("PlayerContext")

local v = { [ControlState.Default] = "TextDefault" }

local v2 = { [ControlState.Default] = "IconOnHover", [ControlState.Hover] = "IconDefault" }

local function doesNotUseScale(p)
	if p.X.Scale == 0 and p.Y.Scale == 0 then
		return true
	end

	return false, "Only Offset values are allowed"
end

extended.validateProps = t.strictInterface({
	text = t.optional(t.string),
	icon = t.optional(t.union(t.string, t.table)),
	iconSize = t.optional(t.intersection(t.UDim2, doesNotUseScale)),
	iconColor = t.optional(t.Color3),
	iconTransparency = t.optional(t.number),
	onActivated = t.optional(t.callback),
	Selectable = t.optional(t.boolean),
	fontStyle = t.optional(t.union(validateFontInfo, validateTypographyInfo)),
	textHeight = t.optional(t.number),
	textColorStyle = t.optional(validateColorInfo),
	iconPadding = t.optional(t.number),
	iconTextSpacing = t.optional(t.number),
	layoutOrder = t.optional(t.number),
	horizontalAlignment = t.optional(t.EnumItem),
	textXAlignment = t.optional(t.EnumItem)
})

extended.defaultProps = {
	text = "",
	icon = nil,
	Selectable = true,
	iconSize = UDim2.fromOffset(getIconSize(IconSize.Small), getIconSize(IconSize.Small)),
	textHeight = 28,
	iconPadding = 4,
	iconTextSpacing = 4,
	layoutOrder = 1,
	horizontalAlignment = Enum.HorizontalAlignment.Left,
	textXAlignment = Enum.TextXAlignment.Left
}

function extended:init()
	self.state = {}
end

function extended.render(p)
	local controlState = p.state.controlState
	local text = p.props.text
	local icon = p.props.icon
	local iconSize = p.props.iconSize
	local horizontalAlignment = p.props.horizontalAlignment

	local onActivated = p.props.onActivated

	return withStyle(function(p2)
		local contentStyle = getContentStyle(v2, controlState, p2)
		local contentStyle2 = getContentStyle(v, controlState, p2)
		local v3 = onActivated and contentStyle or contentStyle2
		local imageTransparency = p.props.iconTransparency

		if not p.props.iconTransparency then
			imageTransparency = p.props.iconColor and 0 or v3.Transparency
		end

		local imageColor = p.props.iconColor

		if not p.props.iconColor then
			imageColor = v3.Color
		end

		local textHeight = p.props.textHeight

		local colorStyle = p.props.textColorStyle

		if not colorStyle then
			if onActivated then
				colorStyle = contentStyle
			else
				colorStyle = contentStyle2
			end
		end

		local iconPadding = p.props.iconPadding
		local iconTextSpacing = p.props.iconTextSpacing

		local v4 = iconSize.X.Offset + iconPadding * 2
		local v5 = iconSize.Y.Offset + iconPadding * 2

		local fontStyle = p.props.fontStyle or p2.Font.CaptionHeader
		return Roact.createElement("ImageButton", {
			Size = UDim2.new(1, 0, 0, textHeight),
			BackgroundTransparency = 1,
			Selectable = p.props.Selectable,
			Active = onActivated and true or false,
			LayoutOrder = p.props.layoutOrder,
			[Roact.Event.Activated] = onActivated
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = horizontalAlignment,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, iconTextSpacing)
			}),
			IconFrame = icon and Roact.createElement(
				"Frame",
				{ Size = UDim2.fromOffset(v4, v5), BackgroundTransparency = 1 },
				{
					layout = Roact.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					icon = Roact.createElement(ImageSetComponent.Label, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Size = iconSize,
						BackgroundTransparency = 1,
						Image = icon,
						ImageColor3 = imageColor,
						ImageTransparency = imageTransparency
					})
				}
			),
			Text = text and Roact.createElement(GenericTextLabel, {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, not icon and 0 or -(v4 + iconTextSpacing), 0, 0),
				Text = text,
				TextWrapped = true,
				TextXAlignment = p.props.textXAlignment,
				fontStyle = fontStyle,
				colorStyle = colorStyle,
				LayoutOrder = 2,
				TextTruncate = Enum.TextTruncate.AtEnd
			})
		})
	end)
end

return extended
