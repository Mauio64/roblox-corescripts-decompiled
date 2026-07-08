local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local useStyle = UIBlox.Core.Style.useStyle
local Medium = IconSize.Medium

return function(t1: {[any]: any}) -- line: 24
	-- upvalues: useStyle (copy), React (copy), IconButton (copy), Medium (copy)
	local v9 = useStyle()
	local v10 = t1.tileSize or 80

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.new(0, v10, 0, v10 + 24),
		Name = "SocialLinkTile_" .. t1.name
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		TextLabel = React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			TextSize = 14,
			TextWrapped = true,
			Name = "NameLabel",
			Size = UDim2.new(1, 0, 0, 24),
			Text = t1.name,
			TextColor3 = v9.Theme.TextDefault.Color,
			Font = Enum.Font.GothamMedium,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Center
		}),
		IconBackground = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 0.9,
			BorderSizePixel = 0,
			Name = "IconBackground",
			Size = UDim2.fromOffset(84, 84),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			IconButton = React.createElement(IconButton, {
				backgroundTransparency = 1,
				icon = t1.icon,
				size = UDim2.fromOffset(84, 84),
				iconColor3 = v9.Theme.IconEmphasis.Color,
				iconSize = Medium,
				onActivated = t1.onActivated
			})
		})
	})
end
