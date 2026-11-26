local module = require("@luauforge/deferred/eiO")
local module2 = require("@luauforge/deferred/ejZ")
local module3 = require("@luauforge/deferred/eiT")
local normalizeFontFace = require("@luauforge/deferred/eiU").Utility.normalizeFontFace
local iconButton = module3.App.Button.IconButton
local iconSize = module3.App.ImageSet.Enum.IconSize
local withStyle = module3.Style.withStyle
local validateImage = module3.Core.ImageSet.Validator.validateImage

local extended = module.PureComponent:extend("AddFriendsSectionHeaderFrame")

extended.validateProps = module2.strictInterface({
	title = module2.string,
	icon = module2.optional(validateImage),
	iconVisible = module2.optional(module2.boolean),
	onIconActivated = module2.optional(module2.callback),
	iconRef = module2.optional(module2.union(module2.callback, module2.table)),
	layoutOrder = module2.optional(module2.integer)
})

extended.defaultProps = { layoutOrder = 1 }

function extended.render(p2)
	return withStyle(function(p3)
		return module.createElement("Frame", {
			ZIndex = 2,
			Position = UDim2.new(0, 24, 0, 0),
			Size = UDim2.new(1, 0, 0, p3.Tokens.Size.Size_1200),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p2.props.layoutOrder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, {
			UIListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
			}),
			HeaderLabel = module.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				FontFace = normalizeFontFace(p3.Tokens.Typography.HeadingSmall.Font),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0.8, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = p2.props.title,
				TextColor3 = p3.Tokens.Color.Content.Emphasis.Color3,
				TextSize = p3.Tokens.Typography.HeadingSmall.FontSize,
				TextTransparency = p3.Tokens.Color.Content.Emphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextWrapped = true,
				LayoutOrder = 1
			}),
			HeaderImageButton = p2.props.iconVisible and module.createElement(iconButton, {
				size = UDim2.fromOffset(iconSize.Medium, iconSize.Medium),
				position = UDim2.new(1, 0, 0, 6),
				anchorPoint = Vector2.new(1, 0),
				icon = p2.props.icon,
				iconTransparency = p3.Tokens.Color.Content.Emphasis.Transparency,
				iconColor3 = p3.Tokens.Color.Content.Emphasis.Color3,
				onActivated = p2.props.onIconActivated,
				buttonRef = p2.props.iconRef,
				layoutOrder = 2
			}) or nil
		})
	end)
end

return extended
