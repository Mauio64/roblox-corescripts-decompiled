local parent = script:FindFirstAncestor("UserSearch").Parent
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

require(script.Parent.Parent.UserSearchTile.useSearchTileButtons)

return function(p)
	local v = useStyle()
	local searchTileButtonProps = p.searchTileButtonProps
	local imageColor = searchTileButtonProps.imageColor or v.Theme.SystemPrimaryContent.Color
	local backgroundColor = searchTileButtonProps.backgroundColor or v.Theme.SystemPrimaryDefault.Color

	local createElement = React.createElement
	local onActivatedsByActivated = {}
	onActivatedsByActivated.Size = UDim2.fromScale(1, 1)
	onActivatedsByActivated.BackgroundColor3 = backgroundColor
	local backgroundTransparency

	if searchTileButtonProps.isDisabled then
		backgroundTransparency = v.Theme.Overlay.Transparency
	else
		backgroundTransparency = v.Theme.SystemPrimaryDefault.Transparency
	end

	onActivatedsByActivated.BackgroundTransparency = backgroundTransparency

	onActivatedsByActivated[React.Event.Activated] = searchTileButtonProps.onActivated
	local v2 = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) }),
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Icon = 0
	}

	local createElement2 = React.createElement
	local v3 = {
		Size = UDim2.new(0, v.Tokens.Size.Size_350, 0, v.Tokens.Size.Size_350),
		BackgroundTransparency = 1,
		Image = searchTileButtonProps.icon,
		ImageColor3 = imageColor,
		ImageTransparency = 0
	}
	local imageTransparency

	if searchTileButtonProps.isDisabled then
		imageTransparency = v.Theme.Overlay.Transparency
	else
		imageTransparency = v.Theme.SystemPrimaryContent.Transparency
	end

	v3.ImageTransparency = imageTransparency
	v2.Icon = createElement2(ImageSetLabel, v3)
	return createElement(ImageSetButton, onActivatedsByActivated, v2)
end
