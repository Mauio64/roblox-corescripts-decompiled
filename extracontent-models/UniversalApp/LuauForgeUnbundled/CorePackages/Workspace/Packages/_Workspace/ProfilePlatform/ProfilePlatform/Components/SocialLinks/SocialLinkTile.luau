local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")

local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local useStyle = UIBlox.Core.Style.useStyle

local medium = iconSize.Medium

return function(props)
	local v5 = useStyle()
	local tileSize = props.tileSize or 80

	return React.createElement("Frame", {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(0, tileSize, 0, tileSize + 24),
		BackgroundTransparency = 1,
		Name = "SocialLinkTile_" .. props.name
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		TextLabel = React.createElement("TextLabel", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 24),
			BackgroundTransparency = 1,
			Text = props.name,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextSize = 14,
			Font = Enum.Font.GothamMedium,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Center,
			Name = "NameLabel"
		}),
		IconBackground = React.createElement("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(84, 84),
			BackgroundTransparency = 0.9,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BorderSizePixel = 0,
			Name = "IconBackground"
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			IconButton = React.createElement(iconButton, {
				icon = props.icon,
				size = UDim2.fromOffset(84, 84),
				iconColor3 = v5.Theme.IconEmphasis.Color,
				iconSize = medium,
				onActivated = props.onActivated,
				backgroundTransparency = 1
			})
		})
	})
end
