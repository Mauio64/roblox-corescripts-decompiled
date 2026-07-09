local Parent = script:FindFirstAncestor("AddFriends").Parent
local Roact = require(Parent.Roact)
local t = require(Parent.t)
local UIBlox = require(Parent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local withStyle = UIBlox.Style.withStyle
local validateImage = UIBlox.Core.ImageSet.Validator.validateImage
local v9 = Roact.PureComponent:extend("AddFriendsSectionHeaderFrame")

v9.validateProps = t.strictInterface({
	title = t.string,
	icon = t.optional(validateImage),
	iconVisible = t.optional(t.boolean),
	onIconActivated = t.optional(t.callback),
	layoutOrder = t.optional(t.integer)
})
v9.defaultProps = {
	layoutOrder = 1
}

function v9.render(p1) -- line: 29
	-- upvalues: withStyle (copy), Roact (copy), IconButton (copy), IconSize (copy)
	return withStyle(function(p2) -- line: 30
		-- upvalues: Roact (copy), p1 (copy), IconButton (copy), IconSize (copy)
		return Roact.createElement("Frame", {
			ZIndex = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 24, 0, 0),
			Size = UDim2.new(1, 0, 0, p2.Tokens.Size.Size_1200),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p1.props.layoutOrder
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
			}),
			HeaderLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextWrapped = true,
				LayoutOrder = 1,
				Font = p2.Font.Header1.Font,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0.8, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = p1.props.title,
				TextColor3 = p2.Tokens.Color.Content.Emphasis.Color3,
				TextSize = p2.Tokens.Typography.HeadingSmall.FontSize,
				TextTransparency = p2.Tokens.Color.Content.Emphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center
			}),
			HeaderImageButton = p1.props.iconVisible and Roact.createElement(IconButton, {
				layoutOrder = 2,
				size = UDim2.fromOffset(IconSize.Medium, IconSize.Medium),
				position = UDim2.new(1, 0, 0, 6),
				anchorPoint = Vector2.new(1, 0),
				icon = p1.props.icon,
				iconTransparency = p2.Tokens.Color.Content.Emphasis.Transparency,
				iconColor3 = p2.Tokens.Color.Content.Emphasis.Color3,
				onActivated = p1.props.onIconActivated
			}) or nil
		})
	end)
end

return v9
