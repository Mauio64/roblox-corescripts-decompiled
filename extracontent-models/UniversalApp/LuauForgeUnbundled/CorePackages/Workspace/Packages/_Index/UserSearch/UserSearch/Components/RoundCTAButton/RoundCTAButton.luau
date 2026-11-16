local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UIBlox")
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchTile/useSearchTileButtons")

return function(p2)
	local v5 = useStyle()
	local searchTileButtonProps = p2.searchTileButtonProps
	local imageColor = searchTileButtonProps.imageColor or v5.Theme.SystemPrimaryContent.Color
	local backgroundColor = searchTileButtonProps.backgroundColor or v5.Theme.SystemPrimaryDefault.Color

	local createElement = React.createElement
	local onActivatedsByActivated = {}
	onActivatedsByActivated.Size = UDim2.fromScale(1, 1)
	onActivatedsByActivated.BackgroundColor3 = backgroundColor
	local v7 = if searchTileButtonProps.isDisabled then v5.Theme.Overlay.Transparency else v5.Theme.SystemPrimaryDefault.Transparency
	onActivatedsByActivated.BackgroundTransparency = v7

	onActivatedsByActivated[React.Event.Activated] = searchTileButtonProps.onActivated
	local v8 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Icon = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		Size = UDim2.new(0, v5.Tokens.Size.Size_350, 0, v5.Tokens.Size.Size_350),
		BackgroundTransparency = 1,
		Image = searchTileButtonProps.icon,
		ImageColor3 = imageColor,
		ImageTransparency = 0
	}

	local v11 = if searchTileButtonProps.isDisabled then v5.Theme.Overlay.Transparency else v5.Theme.SystemPrimaryContent.Transparency
	v10.ImageTransparency = v11
	v8.Icon = createElement2(imageSetLabel, v10)
	return createElement(imageSetButton, onActivatedsByActivated, v8)
end
