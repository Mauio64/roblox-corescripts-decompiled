local Parent = script:FindFirstAncestor("UserSearch").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

require(script.Parent.Parent.UserSearchTile.useSearchTileButtons)

return function(t1: {[any]: any}) -- line: 22
	-- upvalues: useStyle (copy), React (copy), ImageSetButton (copy), ImageSetLabel (copy)
	local v8 = useStyle()
	local searchTileButtonProps = t1.searchTileButtonProps
	local v10 = searchTileButtonProps.imageColor or v8.Theme.SystemPrimaryContent.Color
	local v11 = searchTileButtonProps.backgroundColor or v8.Theme.SystemPrimaryDefault.Color

	return React.createElement(ImageSetButton, {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v11,
		BackgroundTransparency = if not searchTileButtonProps.isDisabled then v8.Theme.SystemPrimaryDefault.Transparency else v8.Theme.Overlay.Transparency,
		[React.Event.Activated] = searchTileButtonProps.onActivated
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.5, 0)
		}),
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v8.Tokens.Size.Size_350, 0, v8.Tokens.Size.Size_350),
			Image = searchTileButtonProps.icon,
			ImageColor3 = v10,
			ImageTransparency = if not searchTileButtonProps.isDisabled then v8.Theme.SystemPrimaryContent.Transparency else v8.Theme.Overlay.Transparency
		})
	})
end
