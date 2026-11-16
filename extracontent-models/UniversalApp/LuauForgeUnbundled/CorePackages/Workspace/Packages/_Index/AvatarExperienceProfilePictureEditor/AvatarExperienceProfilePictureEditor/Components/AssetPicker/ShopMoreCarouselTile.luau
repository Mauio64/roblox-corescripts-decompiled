local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local function ShopMoreCarouselTile(props)
	local v5 = React.useCallback(function()
		props.onActivated()
	end, { props.onActivated })

	return React.createElement(
		view,
		{
			tag = "col align-x-left gap-small auto-y",
			Size = UDim2.fromOffset(props.tileSize, 0),
			LayoutOrder = props.layoutOrder,
			onActivated = v5
		},
		{
			Thumbnail = React.createElement(
				view,
				{
					tag = "align-x-center align-y-center radius-medium bg-surface-100",
					Size = UDim2.fromOffset(props.tileSize, props.tileSize),
					LayoutOrder = 1
				},
				{
					Icon = React.createElement(icon, {
						name = iconName.ShoppingCart,
						size = iconSize.XXLarge
					})
				}
			),
			Label = React.createElement(text, {
				tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-emphasis",
				Text = props.label,
				LayoutOrder = 2
			})
		}
	)
end

return ShopMoreCarouselTile
